from rest_framework import serializers

from django.conf import settings
from .models import MainUser, Driver, Rider, AppAdmin

class RegistrationSerializer(serializers.ModelSerializer):
    class Meta:
        model = MainUser
        fields = ('email', 'password', 'user_type')
        extra_kwargs = {'password': {'write_only': True}}
    def validate(self, attrs):
        user_type = attrs.get('user_type')
        email= attrs.get('email')
        password= attrs.get('password')
        if user_type == 'admin':
            if email != settings.ADMIN_EMAIL or password != settings.ADMIN_PASSWORD:
                raise serializers.ValidationError(
                    {"user_type": "An admin account is wrong."}
                )
        return attrs
    def create(self, validated_data):
        password = validated_data.pop('password', None)
        user = self.Meta.model(**validated_data)
        if password is not None:
            user.set_password(password)
        user.save()
        if user.user_type == 'driver':
            if not hasattr(user, 'driver'):
                Driver.objects.create(user=user)
        elif user.user_type == 'rider':
            if not hasattr(user, 'rider'):
                Rider.objects.create(user=user)
        elif user.user_type == 'admin':
            AppAdmin.objects.get_or_create(user=user)
        return user

class LoginSerializer(serializers.Serializer):
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True)

class MainUserProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = MainUser
        fields = ["name","language1","language2","created_at","phone", "email",]
        
class DriverProfileSerializer(serializers.ModelSerializer):
    user = MainUserProfileSerializer(read_only=True)

    class Meta:
        model = Driver
        fields = (
            "user",
            "car_model",
            "license_number",
            "license_expiry_date",
            "car_number",
            "car_color",
            "car_image"
        )

class RiderProfileSerializer(serializers.ModelSerializer):
    user = MainUserProfileSerializer(read_only=True)

    class Meta:
        model = Rider
        fields = (
            "user",
            "current_location"
        )


class DriverProfileUpdateSerializer(serializers.ModelSerializer):
    
    name = serializers.CharField(source="user.name", required=False)
    language1 = serializers.CharField(source="user.language1", required=False)
    language2 = serializers.CharField(source="user.language2", required=False)  
    phone = serializers.IntegerField(source="user.phone", required=False)
    email = serializers.EmailField(source="user.email", required=False)

    class Meta:
        model = Driver
        fields = [
            "name",
            "language1",
            "language2",
            "phone",
            "email",
            "car_model",
            "license_number",
            "license_expiry_date",
            "car_number",
            "car_color",
            "car_image"
        ]

    def update(self, instance, validated_data):
        
        user_data = validated_data.pop("user", {})
        for attr, value in user_data.items():
            setattr(instance.user, attr, value)
        instance.user.save()

        
        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        instance.save()

        return instance



class RiderProfileUpdateSerializer(serializers.ModelSerializer):
    name = serializers.CharField(source="user.name", required=False)
    language1 = serializers.CharField(source="user.language1", required=False)
    language2 = serializers.CharField(source="user.language2", required=False) 
    phone = serializers.IntegerField(source="user.phone", required=False)
    email = serializers.EmailField(source="user.email", required=False)

    class Meta:
        model = Rider
        fields = [
            "name",
            "language1",
            "language2",
            "phone",
            "email",
            "current_location"
        ]

    def update(self, instance, validated_data):
     
        user_data = validated_data.pop("user", {})
        for attr, value in user_data.items():
            setattr(instance.user, attr, value)
        instance.user.save()

        
        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        instance.save()

        return instance