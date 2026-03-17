from rest_framework import serializers
from users.models import  Driver, Rider
from .models import  Ride, Reservation


class CreateRideSerializer(serializers.ModelSerializer):
    class Meta:
        model = Ride
        fields = ["id", "location", "destination", "departure_time", "arrival_time", "cost", "capacity", "car_image"]

    def create(self, validated_data):
        return Ride.objects.create(**validated_data)


class UpdateRideSerializer(serializers.ModelSerializer):
    class Meta:
        model = Ride
        fields = ["id", "location", "destination", "departure_time", "arrival_time", "cost", "capacity", "status"]




class CreateReservationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Reservation
        fields = ['id', 'ride', 'rider', 'status']
        read_only_fields = ['status', ]

    def validate(self, attrs):
        ride = attrs.get('ride')

       
        if ride.capacity == 0:
            raise serializers.ValidationError("No available seats.")
        return attrs

    def create(self, validated_data):
        ride = validated_data['ride']

        reservation = Reservation.objects.create(**validated_data)

        ride.capacity -= 1
        ride.save()

        return reservation


class RideSearchSerializer(serializers.ModelSerializer):
    car_image = serializers.ImageField(source='driver.profile_picture', read_only=True)

    class Meta:
        model = Ride
        fields = ["id", "location", "destination", "departure_time", "arrival_time", "cost", "car_image", "capacity"]