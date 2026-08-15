from django.db import models
from users.models import MainUser
from rides.models import Ride

class LocationPoint(models.Model):
    ride= models.ForeignKey(Ride, on_delete=models.CASCADE, related_name="location_points")
    user= models.ForeignKey(MainUser, on_delete= models.CASCADE)
    latitude= models.DecimalField(max_digits= 10, decimal_places= 6)
    longitude= models.DecimalField(max_digits= 10, decimal_places= 6)
    recorded_at= models.DateTimeField(auto_now_add= True)

class CurrentLocation(models.Model):
    user= models.OneToOneField(MainUser, on_delete= models.CASCADE, related_name="current_location")
    latitude= models.DecimalField(max_digits= 10, decimal_places= 6)
    longitude= models.DecimalField(max_digits= 10, decimal_places= 6)
    updated_at= models.DateTimeField(auto_now=True)
