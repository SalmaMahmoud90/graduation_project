from django.urls import path
from .views import *


urlpatterns = [
    path('create/',CreateRideAPIView.as_view(), name='create_ride'),
    path('<int:ride_id>/update/',UpdateRideView.as_view(), name='update_ride'),
    path("<int:ride_id>/cancel/", CancelRideView.as_view(), name="cancel-ride"),
    path('reservations/create/', CreateReservationView.as_view(), name='create-reservation'),
    path("search/", SearchRides.as_view(), name="ride-search"),
    path("myrides/", MyRidesView.as_view(), name="my-rides"),
]