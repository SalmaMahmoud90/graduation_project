from rest_framework import serializers
from .models import Report
from rides.models import *
from users.models import MainUser

def get_shared_rides(user, target_user):
    if user.user_type == "driver":
        user_rides = Ride.objects.filter(
            driver=user.driver
        )
    elif user.user_type == "rider":
        user_rides = Ride.objects.filter(
            reservations__rider__user=user
        )
    else:
        return Ride.objects.none()

    if target_user.user_type == "driver":
        target_rides = Ride.objects.filter(
            driver=target_user.driver
        )
    elif target_user.user_type == "rider":
        target_rides = Ride.objects.filter(
            reservations__rider__user=target_user
        )
    else:
        return Ride.objects.none()

    return user_rides.filter(
        id__in=target_rides.values("id")
    ).distinct()

class CreateReportSerializer(serializers.ModelSerializer):
    class Meta:
        model = Report
        fields = ["id", "ride", "type", "reason", "status"]
        read_only_fields = ["id", "status"]

    def validate(self, attrs):
        request = self.context["request"]
        reporter = request.user
        reported_user = self.context["reported_user"]
        ride = attrs.get("ride")

        if reporter == reported_user:
            raise serializers.ValidationError(
                "You cannot report yourself."
            )

        if ride:
            shared_rides = get_shared_rides(
                reporter,
                reported_user
            )

            if not shared_rides.filter(id=ride.id).exists():
                raise serializers.ValidationError({
                    "ride": "This ride is not shared between you and the reported user."
                })

        return attrs
        
class SharedRideSerializer(serializers.ModelSerializer):
    available_seats = serializers.IntegerField(read_only=True)
    class Meta:
        model = Ride
        fields = [
            "id",
            "location",
            "destination",
            "departure_date",
            "departure_time",
            "cost",
            "available_seats",
            "status",
        ]

class MyReportsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Report
        fields = [
            "id",
            "reported_user",
            "type",
            "reason",
            "status",
            "created_at",
            "updated_at",
        ]

class ViewReportDetailsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Report
        fields = [
            "id",
            "reported_user",
            "ride",
            "type",
            "reason",
            "status",
            "admin_note",
            "created_at",
            "updated_at",
        ]