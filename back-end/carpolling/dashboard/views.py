from django.shortcuts import render
from .serializers import *
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status

class ViewRidesView(APIView):
    def get(self, request):
        user = request.user
        if user.user_type != "admin":
            return Response({"error": "Only Admin access this."}, status=status.HTTP_403_FORBIDDEN)
        else:
            rides= Ride.objects.all()
            serializer= ViewRidesSerializer(rides, many= True)
            return Response(serializer.data, status= status.HTTP_200_OK)

class ViewUsersView(APIView):
    def get(self, request):
        user = request.user
        if user.user_type != "admin":
            return Response({"error": "Only Admin access this."}, status=status.HTTP_403_FORBIDDEN)
        else:
            users= MainUser.objects.all()
            serializer= ViewUsersSerializer(users, many= True)
            return Response(serializer.data, status= status.HTTP_200_OK)
    
class ViewReservationsView(APIView):
    def get(self, request):
        user = request.user
        if user.user_type != "admin":
            return Response({"error": "Only Admin access this."}, status=status.HTTP_403_FORBIDDEN)
        else:
            reservations= Reservation.objects.all()
            serializer= ViewReservationsSerializer(reservations, many= True)
            return Response(serializer.data, status= status.HTTP_200_OK)

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