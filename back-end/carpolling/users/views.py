import email
from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework import status,generics
from rest_framework.response import Response  
from .serializers import *
from rest_framework import permissions
from .models import  MainUser, Driver, Rider
import requests # add this
from django.conf import settings
from requests.auth import HTTPBasicAuth

class CreateAccount(APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        reg_serializer = RegistrationSerializer(data=request.data)
        if reg_serializer.is_valid():
            new_user = reg_serializer.save() 

            client_id = getattr(settings, 'OAUTH_CLIENT_ID', None)
            client_secret = getattr(settings, 'OAUTH_CLIENT_SECRET', None)
            token_url = getattr(settings, 'OAUTH_TOKEN_URL', 'http://127.0.0.1:8000/auth/token')

            r = requests.post(
                token_url,
                data={
                    'username': new_user.email,
                    'password': request.data['password'],
                    'grant_type': 'password'
                },
                auth=HTTPBasicAuth(client_id, client_secret)
            )

            token_data = r.json()
            token_data["user"] = {
                "email": new_user.email,
                "name": new_user.name,
                "user_type": new_user.user_type
            }

            return Response(token_data, status=status.HTTP_201_CREATED)

        return Response(reg_serializer.errors, status=status.HTTP_400_BAD_REQUEST)




class Login(APIView):
    permission_classes=[permissions.AllowAny]
    def post(self,request) :
        log_serializer=LoginSerializer(data=request.data)
        if not log_serializer.is_valid():
            return Response(log_serializer.errors, status=status.HTTP_400_BAD_REQUEST)

        email=log_serializer.validated_data['email']
        password=log_serializer.validated_data['password']
        token_url = getattr(settings, 'OAUTH_TOKEN_URL', 'http://127.0.0.1:8000/auth/token')
        client_id = getattr(settings, 'OAUTH_CLIENT_ID', 'Your Client ID')
        client_secret = getattr(settings, 'OAUTH_CLIENT_SECRET', 'Your Client Secret')

        try:
            resp = requests.post(token_url, data={
            'grant_type': 'password',
            'username': email,
            'password': password,
            }, auth=HTTPBasicAuth(client_id, client_secret), timeout=5)

        except requests.RequestException as e:
            return Response({'detail': 'Token server error', 'error': str(e)}, status=status.HTTP_502_BAD_GATEWAY)

       
        if resp.status_code != 200:
            try:
                return Response(resp.json(), status=resp.status_code)
            except ValueError:
                return Response({'detail': 'Token server returned an error', 'body': resp.text}, status=resp.status_code)

        token_data = resp.json()

        
        try:
            user = MainUser.objects.get(email=email)
            token_data['user'] = {
                'email': user.email,
                'name': user.name,
                'user_type': user.user_type,
            }
        except MainUser.DoesNotExist:
            
            token_data['user'] = {'email': email}

        return Response(token_data, status=status.HTTP_200_OK)

            


class ViewProfile(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        user = request.user

        if user.user_type == "driver":
            try:
                driver = user.driver
                serializer = DriverProfileSerializer(driver)
            except Driver.DoesNotExist:
                return Response({"error": "Driver profile not found"}, status=status.HTTP_404_NOT_FOUND)

        elif user.user_type == "rider":
            try:
                rider = user.rider
                serializer = RiderProfileSerializer(rider)
            except Rider.DoesNotExist:
                return Response({"error": "Rider profile not found"}, status=status.HTTP_404_NOT_FOUND)

        else:
            return Response({"error": "Invalid user type"}, status=status.HTTP_400_BAD_REQUEST)

        return Response(serializer.data, status=status.HTTP_200_OK)



class UpdateDriverProfile(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def patch(self, request):
        user = request.user

        if user.user_type != "driver":
            return Response({"error": "Only drivers can update profile"}, status=status.HTTP_403_FORBIDDEN)

        try:
            driver = user.driver
        except Driver.DoesNotExist:
            return Response({"error": "Driver profile not found"}, status=status.HTTP_404_NOT_FOUND)

        serializer = DriverProfileUpdateSerializer(driver, data=request.data, partial=True)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class UpdateRiderProfile(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def patch(self, request):
        user = request.user

        if user.user_type != "rider":
            return Response({"error": "Only riders can update this profile."}, status=status.HTTP_403_FORBIDDEN)

        try:
            rider = Rider.objects.get(user=user)
        except Rider.DoesNotExist:
            return Response({"error": "Rider profile not found."}, status=status.HTTP_404_NOT_FOUND)

        serializer = RiderProfileUpdateSerializer(rider, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)