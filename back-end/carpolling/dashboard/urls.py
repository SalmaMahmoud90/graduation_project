from django.urls import path 
from .views import *

urlpatterns = [
    path('view_rides/', ViewRidesView.as_view(), name= "view_rides"),
    path('view_ride_details/<int:ride_id>/', ViewRideDetailsView.as_view(), name= "view_ride_details"),
    path('view_users/', ViewUsersView.as_view(), name= "view_users"),
    path('view_user_details/<int:user_id>/', ViewUserDetailsView.as_view(), name= "view_user_details"),
    path('view_reservations/', ViewReservationsView.as_view(), name= "view_reservations"),
    path('ban/<int:user_id>/', BanUserView.as_view(), name= "ban"),
    path('unban/<int:user_id>/', UnBanUserView.as_view(), name= "unban"),
]
