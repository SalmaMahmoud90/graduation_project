from django.shortcuts import render
from .serializers import *
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status, permissions
from .models import Ride

class CreateRideAPIView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request):
        user = request.user
        if user.user_type != "driver":
            return Response(
                {"error": "Only drivers can create rides"}, 
                status=status.HTTP_403_FORBIDDEN
            )
        
        serializer = CreateRideSerializer(data=request.data)
        if serializer.is_valid():
            # Set the car image to the driver's profile picture
            ride = serializer.save(driver=user.driver, car_image=user.driver.profile_picture)
            return Response(CreateRideSerializer(ride).data, status=status.HTTP_201_CREATED)
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)



class UpdateRideView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def patch(self, request, ride_id):
        try:
            ride = Ride.objects.get(id=ride_id, driver=request.user.driver)
        except Ride.DoesNotExist:
            return Response({"error": "Ride not found"}, status=status.HTTP_404_NOT_FOUND)

        # مسموح التعديل فقط إذا كانت الرحلة Active
        if ride.status != Ride.RideStatus.ACTIVE:
            return Response({"error": "Only active rides can be updated"}, status=status.HTTP_400_BAD_REQUEST)

        serializer = UpdateRideSerializer(ride, data=request.data, partial=True)  
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class CancelRideView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def delete(self, request, ride_id):
        try:
            ride = Ride.objects.get(id=ride_id, driver=request.user.driver)
        except Ride.DoesNotExist:
            return Response({"error": "Ride not found"}, status=status.HTTP_404_NOT_FOUND)

        if ride.status != Ride.RideStatus.ACTIVE:
            return Response({"error": "Only active rides can be cancelled"}, status=status.HTTP_400_BAD_REQUEST)

        # حذف الرحلة من قاعدة البيانات
        ride.delete()
        return Response({"message": "Ride deleted successfully"}, status=status.HTTP_200_OK)



class CreateReservationView(APIView):
    permission_classes = [permissions.IsAuthenticated]  # لازم تسجيل دخول

    def post(self, request, *args, **kwargs):
        if not hasattr(request.user, 'rider'):
            return Response({"error": "Only riders can search for rides"}, status=status.HTTP_403_FORBIDDEN)
        serializer = CreateReservationSerializer(data=request.data)

        if serializer.is_valid():
            # تعيين الراكب من المستخدم الحالي
            serializer.save(rider=request.user.rider)
            return Response(serializer.data, status=status.HTTP_201_CREATED)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)



class SearchRides(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        # أخذ قيم البحث من Query Params
        location = request.query_params.get('location')
        destination = request.query_params.get('destination')

        if not location or not destination:
            return Response(
                {"error": "Please provide both location and destination."},
                status=status.HTTP_400_BAD_REQUEST
            )

        # البحث عن الرحلات
        rides = Ride.objects.filter(
            location__icontains=location,
            destination__icontains=destination,
            status='active'  # نعرض فقط الرحلات النشطة
        )

        serializer = RideSearchSerializer(rides, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


class MyRidesView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        user = request.user
        if not hasattr(user, 'driver'):
            return Response({"error": "Only drivers can view their rides"}, status=status.HTTP_403_FORBIDDEN)

        rides = Ride.objects.filter(driver=user.driver).order_by('-id')
        serializer = RideSearchSerializer(rides, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)