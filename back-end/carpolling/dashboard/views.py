from users.pagination import CustomerLimitOffsetPagination
from .serializers import *
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rides.serializers import ReservationDetailSerializer, RideSearchSerializer
from django.db.models import Count
from payments.models import Wallet, Transaction
from django.db import transaction
from django.db import connection

class ViewRidesView(APIView):
    def get(self, request):
        user = request.user
        if user.user_type != "admin":
            return Response({"error": "Only Admin access this."}, status=status.HTTP_403_FORBIDDEN)
        else:
            rides= Ride.objects.all().order_by('-created_at')
            paginator = CustomerLimitOffsetPagination()
            paginated_rides = paginator.paginate_queryset(rides, request)
            serializer= ViewRidesSerializer(paginated_rides, many= True)
            return paginator.get_paginated_response(serializer.data)
        
class ViewRideDetailsView(APIView):
    def get(self, request, ride_id):
        user= request.user
        if user.user_type != "admin":
            return Response({"error": "Only Admin access this."}, status=status.HTTP_403_FORBIDDEN)
        else:
            try:
                ride = Ride.objects.get(id=ride_id)
            except Ride.DoesNotExist:
                return Response(
                    {"error": "Ride not found"},
                    status=status.HTTP_404_NOT_FOUND
                )
            serializer= ViewRideDetailSerializer(ride)
            return Response(serializer.data, status= status.HTTP_200_OK)
            
class ViewUsersView(APIView):
    def get(self, request):
        user = request.user
        if user.user_type != "admin":
            return Response({"error": "Only Admin access this."}, status=status.HTTP_403_FORBIDDEN)
        else:
            users = MainUser.objects.annotate(reports_count=Count('reports_received')).order_by('-created_at')
            paginator = CustomerLimitOffsetPagination()
            paginated_users = paginator.paginate_queryset(users, request)
            serializer= ViewUsersSerializer(paginated_users, many= True)
            return paginator.get_paginated_response(serializer.data)
        
class ViewUserDetailsView(APIView):
    def get(self, request, user_id):
        admin_user = request.user
        if admin_user.user_type != "admin":
            return Response({"error": "Only Admin access this."}, status=status.HTTP_403_FORBIDDEN)
        else:
            try:
                user = MainUser.objects.select_related("wallet").get(id=user_id)
            except MainUser.DoesNotExist:
                return Response(
                    {"error": "User not found"},
                    status=status.HTTP_404_NOT_FOUND
                )
            profile = UserProfileSerializer(user).data
            if user.user_type== "driver":
                try:
                    driver= user.driver
                except AttributeError:
                    return Response({"error": "Driver profile not found"}, status= status.HTTP_404_NOT_FOUND)
                rides= Ride.objects.filter(driver= driver).order_by('-id')
                serializer= RideSearchSerializer(rides, many= True)
                return Response({
                    "profile": profile,
                    "rides": serializer.data
                }, status=status.HTTP_200_OK)
            elif user.user_type== 'rider':
                try:
                    rider= user.rider
                except AttributeError:
                    return Response({"error": "Rider profile not found"}, status= status.HTTP_404_NOT_FOUND)
                reservations= Reservation.objects.filter(rider= rider).order_by('-id')
                serializer= ReservationDetailSerializer(reservations, many= True)
                return Response({
                    "profile": profile,
                    "reservations" : serializer.data
                }, status= status.HTTP_200_OK)
            else:
                return Response({"error": "Invalid user type"}, status=status.HTTP_400_BAD_REQUEST)

    
class ViewReservationsView(APIView):
    def get(self, request):
        user = request.user
        if user.user_type != "admin":
            return Response({"error": "Only Admin access this."}, status=status.HTTP_403_FORBIDDEN)
        else:
            reservations= Reservation.objects.all().order_by('-created_at')
            paginator = CustomerLimitOffsetPagination()
            paginated_reservations = paginator.paginate_queryset(reservations, request)
            serializer= ViewReservationsSerializer(paginated_reservations, many= True)
            return paginator.get_paginated_response(serializer.data)

class ViewReportsView(APIView):
    def get(self, request):
        user = request.user
        if user.user_type != "admin":
            return Response({"error": "Only Admin access this."}, status=status.HTTP_403_FORBIDDEN)
        else:
            reports= Report.objects.all().order_by('-created_at')
            paginator = CustomerLimitOffsetPagination()
            paginated_reports = paginator.paginate_queryset(reports, request)
            serializer= ViewReportsSerializer(paginated_reports, many= True)
            return paginator.get_paginated_response(serializer.data)
        
class ViewReportDetailsView(APIView):
    def get(self, request, report_id):
        user= request.user
        if user.user_type != "admin":
            return Response({"error": "Only Admin access this."}, status=status.HTTP_403_FORBIDDEN)
        
        try:
            report = Report.objects.get(id=report_id)
            if report.status == Report.ReportStatus.PENDING:
                report.status = Report.ReportStatus.REVIEWED
                report.save(update_fields=["status"])
        except Report.DoesNotExist:
            return Response(
                {"error": "Report not found"},
                status=status.HTTP_404_NOT_FOUND
                )
        serializer= ViewReportDetailsSerializer(report)
        return Response(serializer.data, status= status.HTTP_200_OK)

class SendNote(APIView):
    def patch(self, request, report_id):
        admin_user = request.user
        if admin_user.user_type != "admin":
            return Response({"error": "Only Admin access this."}, status=status.HTTP_403_FORBIDDEN)
        try:
            report = Report.objects.get(id=report_id)
        except Report.DoesNotExist:
            return Response(
                {"error": "Report not found"},
                status=status.HTTP_404_NOT_FOUND
            )
        serializer = AdminNoteSerializer(
            report,
            data=request.data,
            partial=True
        )
        serializer.is_valid(raise_exception=True)
        serializer.save()

        return Response(
            serializer.data,
            status=status.HTTP_200_OK
        )


class BanUserView(APIView):
    def post(self, request, user_id):
        admin_user = request.user
        if admin_user.user_type != "admin":
            return Response({"error": "Only Admin access this."}, status=status.HTTP_403_FORBIDDEN)
        else:
            try:
                target_user= MainUser.objects.get(id= user_id)
                if target_user.user_type== "admin":
                    return Response(
                        {"error": "Cannot block admin"},
                        status= status.HTTP_403_FORBIDDEN
                    )
                target_user.is_active = False
                target_user.save()
                return Response(
                {"message": "User banned successfully"},
                status=status.HTTP_200_OK
                )
            except MainUser.DoesNotExist:
                return Response(
                {"error": "User not found"},
                status=status.HTTP_404_NOT_FOUND
                )
            
class UnBanUserView(APIView):
    def post(self, request, user_id):
        admin_user = request.user
        if admin_user.user_type != "admin":
            return Response({"error": "Only Admin access this."}, status=status.HTTP_403_FORBIDDEN)
        else:
            try:
                target_user= MainUser.objects.get(id= user_id)
                target_user.is_active = True
                target_user.save()
                return Response(
                {"message": "User unbanned successfully"},
                status=status.HTTP_200_OK
                )
            except MainUser.DoesNotExist:
                return Response(
                {"error": "User not found"},
                status=status.HTTP_404_NOT_FOUND
                )
            
class ViewDepositRequestsView(APIView):
    def get(self, request):
        admin_user = request.user
        if admin_user.user_type != "admin":
            return Response({"error": "Only Admin access this."}, status=status.HTTP_403_FORBIDDEN)
        deposit_requests= DepositRequest.objects.select_related("user").all().order_by("-created_at")
        paginator = CustomerLimitOffsetPagination()
        paginated_requests = paginator.paginate_queryset(deposit_requests, request)
        serializer= ViewDepositRequestsSerializer(paginated_requests, many=True)
        return paginator.get_paginated_response(serializer.data)
    
class ViewDepositRequestDetailsView(APIView):
    def get(self, request, deposit_request_id):
        admin_user = request.user
        if admin_user.user_type != "admin":
            return Response({"error": "Only Admin access this."}, status=status.HTTP_403_FORBIDDEN)
        try:
            deposit_requests= DepositRequest.objects.select_related("user").get(id=deposit_request_id)
        except DepositRequest.DoesNotExist:
            return Response(
                    {"error": "DepositRequest not found"},
                    status=status.HTTP_404_NOT_FOUND
                )
        serializer= ViewDepositRequestsSerializer(deposit_requests)
        return Response(serializer.data, status= status.HTTP_200_OK)

class AcceptDepositRequestView(APIView):
    @transaction.atomic
    def post(self, request, deposit_request_id):
        admin_user = request.user
        if admin_user.user_type != "admin":
            return Response({"error": "Only Admin access this."}, status=status.HTTP_403_FORBIDDEN)
        try:
                deposit_request= DepositRequest.objects.select_for_update().get(id= deposit_request_id)
                if deposit_request.status != DepositRequest.Status.PENDING:
                    return Response(
                        {"error": "This request has already been processed."},
                        status=status.HTTP_400_BAD_REQUEST
                    )
                deposit_request.status= DepositRequest.Status.APPROVED
                deposit_request.save()
                wallet = Wallet.objects.get(user=deposit_request.user)
                wallet.balance += deposit_request.amount
                wallet.save()
                Transaction.objects.create(
                    wallet=wallet,
                    deposit_request=deposit_request,
                    amount=deposit_request.amount,
                    transaction_type=Transaction.TransactionType.DEPOSIT
                )
                return Response({"message": "Deposit request accepted successfully."}, status= status.HTTP_200_OK)
        except DepositRequest.DoesNotExist:
            return Response(
            {"error": "Deposit Request not found"},
            status=status.HTTP_404_NOT_FOUND
            )


class RejectDepositRequestView(APIView):
    @transaction.atomic
    def post(self, request, deposit_request_id):
        admin_user = request.user
        if admin_user.user_type != "admin":
            return Response({"error": "Only Admin access this."}, status=status.HTTP_403_FORBIDDEN)
        try:
                deposit_request= DepositRequest.objects.select_for_update().get(id= deposit_request_id)
                if deposit_request.status != DepositRequest.Status.PENDING:
                    return Response(
                        {"error": "This request has already been processed."},
                        status=status.HTTP_400_BAD_REQUEST
                    )
                deposit_request.status= DepositRequest.Status.REJECTED
                deposit_request.save()
                return Response({"message": "Deposit request rejected successfully."}, status= status.HTTP_200_OK)
        except DepositRequest.DoesNotExist:
            return Response(
            {"error": "Deposit Request not found"},
            status=status.HTTP_404_NOT_FOUND
            )


class DashboardStatisticsAPIView(APIView):

    def execute_view_query(self, query):
        with connection.cursor() as cursor:
            cursor.execute(query)

            columns = [column[0] for column in cursor.description]

            return [
                dict(zip(columns, row))
                for row in cursor.fetchall()
            ]

    def get(self, request):
        driver_trips = self.execute_view_query("""
                    SELECT *
                    FROM view_driver_trips_count
                """)

        active_riders = self.execute_view_query("""
            SELECT *
            FROM view_most_active_riders
        """)

        popular_destinations = self.execute_view_query("""
            SELECT *
            FROM view_popular_destinations
            """)

        popular_pickup_locations = self.execute_view_query("""
            SELECT *
            FROM view_popular_pickup_locations
            """)
        return Response({
                "driver_trips": driver_trips,
                "active_riders": active_riders,
                "popular_destinations": popular_destinations,
                "popular_pickup_locations": popular_pickup_locations,
                })

class DailyPlatformSummaryView(APIView):

    def get(self, request):
        with connection.cursor() as cursor:
            cursor.execute("""
                SELECT
                    summary_date,
                    total_rides_created,
                    total_reservations_made
                FROM daily_platform_summary
                ORDER BY summary_date DESC
            """)

            rows = cursor.fetchall()

        data = [
            {
                "summary_date": row[0],
                "total_rides_created": row[1],
                "total_reservations_made": row[2],
            }
            for row in rows
        ]

        return Response(data)