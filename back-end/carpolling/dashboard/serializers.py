from rest_framework import serializers
from users.models import *
from rides.models import *

class ViewRidesSerializer(serializers.ModelSerializer):
    driver_name = serializers.CharField(source='driver.user.name', read_only=True)
    available_seats = serializers.IntegerField(read_only=True)
    class Meta:
        model= Ride
        fields=["id", "location", "destination", "driver_name", "departure_time", "capacity", "available_seats", "cost", "status"]

class ViewUsersSerializer(serializers.ModelSerializer):
    class Meta:
        model= MainUser
        fields=["id", "name", "user_type", "created_at", "is_active", "email"]

class ViewReservationsSerializer(serializers.ModelSerializer):
    rider_name = serializers.CharField(source='rider.user.name', read_only=True)
    class Meta:
        model= Reservation
        fields=["id", "rider_name", "ride", "status", "created_at", "payment"]

class ViewRideDetailSerializer(serializers.ModelSerializer):
    available_seats = serializers.IntegerField(read_only=True)

    reservations = ViewReservationsSerializer(
        source='reservation_set',
        many=True,
        read_only=True
    )

    driver_name = serializers.CharField(
        source='driver.user.name',
        read_only=True
    )

    class Meta:
        model = Ride
        fields = [
            "id",
            "location",
            "destination",
            "departure_time",
            "arrival_time",
            "cost",
            "capacity",
            "available_seats",
            "status",
            "driver_name",
            "reservations"
        ]