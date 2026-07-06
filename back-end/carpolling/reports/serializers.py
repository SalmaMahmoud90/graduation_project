from rest_framework import serializers
from .models import Report
from rides.models import *

class CreateReportSerializer(serializers.ModelSerializer):
    class Meta:
        model = Report
        fields = ["id", "reported_user", "ride", "type", "reason", "status"]
        read_only_fields = ["status"]
        
    def validate(self, attrs):

        reporter = self.context["request"].user
        reported_user = attrs["reported_user"]
        ride = attrs.get("ride")

        if reporter == reported_user:
            raise serializers.ValidationError(
                "You cannot report yourself."
            )

        if ride:
            is_driver = (ride.driver.user == reported_user)
            is_rider = Reservation.objects.filter(ride=ride, rider__user=reported_user).exists()
            if not (is_driver or is_rider):
                raise serializers.ValidationError(
                    "Reported user is not related to this ride."
                )

        return attrs