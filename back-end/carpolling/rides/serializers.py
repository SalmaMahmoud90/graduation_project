from rest_framework import serializers
from users.models import  Driver, Rider
from .models import  Ride, Reservation


class CreateRideSerializer(serializers.ModelSerializer):
    class Meta:
        model = Ride
        fields = ["id", "location", "destination", "departure_time", "arrival_time", "cost", "capacity"]

    def create(self, validated_data):
        return Ride.objects.create(**validated_data)


class UpdateRideSerializer(serializers.ModelSerializer):
    class Meta:
        model = Ride
        fields = ["id", "location", "destination", "departure_time", "arrival_time", "cost", "capacity", "status"]


class CreateReservationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Reservation
        fields = ['id', 'ride', 'rider', 'status', "created_at", "pickup_location"]
        read_only_fields = ['status', 'rider'] 

    def validate(self, attrs):
        ride = attrs.get('ride')
        rider = self.context['request'].user.rider 

        if ride.available_seats <= 0: 
            raise serializers.ValidationError("No available seats left on this ride.")

        if Reservation.objects.filter(ride=ride, rider=rider).exists():
            raise serializers.ValidationError("You have already reserved a seat on this ride.")
            
        if ride.driver.user == self.context['request'].user:
            raise serializers.ValidationError("You cannot reserve your own ride.")
        return attrs

    def create(self, validated_data):
        reservation = Reservation.objects.create(**validated_data)
        return reservation

class DriverInfoSerializers(serializers.ModelSerializer):
    driver_name= serializers.CharField(source= 'user.name', read_only= True)
    class Meta:
        model=  Driver
        fields=['driver_name', 'car_image']

class RideSearchSerializer(serializers.ModelSerializer):
    driver_info= DriverInfoSerializers(source= 'driver', read_only= True)
    available_seats = serializers.IntegerField(read_only=True)
    class Meta:
        model = Ride
        fields = ["id",
                "location", 
                "destination", 
                "departure_time", 
                "cost", 
                "capacity", 
                "available_seats", 
                "status",
                "driver_info"]

class MyRidesSerializer(serializers.ModelSerializer):
    car_image = serializers.ImageField(source= 'driver.car_image', read_only=True)
    available_seats = serializers.IntegerField(read_only=True)
    class Meta:
        model = Ride
        fields = ["id", "location", "destination", "departure_time", "arrival_time", "cost", "capacity", "available_seats", "status", "car_image"]

class ReservationDetailSerializer(serializers.ModelSerializer):
    ride_location= serializers.CharField(source= 'ride.location', read_only= True)
    ride_destination= serializers.CharField(source= 'ride.destination', read_only= True)
    rider_name= serializers.CharField(source= 'rider.user.name', read_only= True)
    class Meta:
        model= Reservation
        fields= ['id', 'rider_name', 'status', 'payment', 'ride_location', 'ride_destination', "created_at", "pickup_location", ]

class RideDetailsSerializer(serializers.ModelSerializer):
    available_seats = serializers.IntegerField(read_only=True)
    driver_info= DriverInfoSerializers(source= 'driver', read_only= True)
    class Meta:
        model = Ride
        fields = ["id",
                   "location", 
                   "destination", 
                   "departure_time", 
                   "arrival_time", 
                   "cost",
                   "capacity", 
                   "available_seats", 
                   "status", 
                   "driver_info"]
