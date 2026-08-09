from django.urls import path
from .views import *


urlpatterns = [
    path('create/',CreateRideView.as_view(), name='create_ride'),
    path('<int:ride_id>/update/',UpdateRideView.as_view(), name='update_ride'),
    path("<int:ride_id>/cancel/", CancelRideView.as_view(), name="cancel-ride"),
    path('reservations/create/', CreateReservationView.as_view(), name='create-reservation'),
    path('reservations/<int:reservation_id>/cancel/', CancelReservationView.as_view(), name='cancel-reservation'),
    path("reservations/<int:reservation_id>/accept/", AcceptReservationView.as_view(), name="accept-reservation"),
    path("reservations/<int:reservation_id>/reject/", RejectReservationView.as_view(), name="reject-reservation"),
    path("search/", SearchRides.as_view(), name="ride-search"),
    path("my_rides/", MyRidesView.as_view(), name="my-rides"),
    path("my_reservations/", MyReservationView.as_view(), name="my-reservations"),
    path("ride_details/<int:ride_id>/", ViewRideDetails.as_view(), name="ride-details"),
]