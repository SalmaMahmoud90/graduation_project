from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status

from .models import DeviceToken
from .serializers import DeviceTokenSerializer


class RegisterDeviceTokenView(APIView):

    def post(self, request):

        serializer = DeviceTokenSerializer(data=request.data)

        if serializer.is_valid():

            token = serializer.validated_data["token"]

            device_token, created = DeviceToken.objects.update_or_create(
                token=token,
                defaults={
                    "user": request.user
                }
            )

            return Response(
                {
                    "message": "Device token registered successfully.",
                    "token_id": device_token.id
                },
                status=status.HTTP_200_OK
            )

        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )