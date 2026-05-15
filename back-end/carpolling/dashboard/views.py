from users.pagination import CustomerCursorPagination
from .serializers import *
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rides.serializers import ReservationDetailSerializer, RideSearchSerializer

class ViewRidesView(APIView):
    def get(self, request):
        user = request.user
        if user.user_type != "admin":
            return Response({"error": "Only Admin access this."}, status=status.HTTP_403_FORBIDDEN)
        else:
            rides= Ride.objects.all().order_by('-created_at')
            paginator = CustomerCursorPagination()
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
            users= MainUser.objects.all().order_by('-created_at')
            paginator = CustomerCursorPagination()
            paginated_users = paginator.paginate_queryset(users, request)
            serializer= ViewUsersSerializer(paginated_users, many= True)
            return paginator.get_paginated_response(serializer.data)
        
class ViewUserDetailsView(APIView):
    def get(self, request, user_id):
        admin_user = request.user
        if admin_user.user_type != "admin":
            return Response({"error": "Only Admin access this."}, status=status.HTTP_403_FORBIDDEN)
        else:
            user= MainUser.objects.get(id= user_id)
            if(user.user_type== "driver"):
                try:
                    driver= user.driver
                except AttributeError:
                    return Response({"error": "Driver profile not found"}, status= status.HTTP_404_NOT_FOUND)
                rides= Ride.objects.filter(driver= driver, status=Ride.RideStatus.ACTIVE).order_by('-id')
                serializer= RideSearchSerializer(rides, many= True)
                return Response({
                    "user_type": "driver",
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
                    "user_type": "rider",
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
            paginator = CustomerCursorPagination()
            paginated_reservations = paginator.paginate_queryset(reservations, request)
            serializer= ViewReservationsSerializer(paginated_reservations, many= True)
            return paginator.get_paginated_response(serializer.data)

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