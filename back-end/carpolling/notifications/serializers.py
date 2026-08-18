from rest_framework import serializers
from .models import DeviceToken


class DeviceTokenSerializer(serializers.ModelSerializer):

    class Meta:
        model = DeviceToken
        fields = ["token"]

    def validate_token(self, value):

        if not value:
            raise serializers.ValidationError(
                "Device token is required."
            )

        return value