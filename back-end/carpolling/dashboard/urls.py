from django.urls import path 
from .views import *

urlpatterns = [
    path('view_rides/', ViewRidesView.as_view(), name= "view_rides"),
    path('view_ride_details/<int:ride_id>/', ViewRideDetailsView.as_view(), name= "view_ride_details"),
    path('view_users/', ViewUsersView.as_view(), name= "view_users"),
    path('view_user_details/<int:user_id>/', ViewUserDetailsView.as_view(), name= "view_user_details"),
    path('view_reservations/', ViewReservationsView.as_view(), name= "view_reservations"),
    path('view_reports/', ViewReportsView.as_view(), name= "view_reports"),
    path('view_report_details/<int:report_id>/', ViewReportDetailsView.as_view(), name= "view_report_details"),
    path('ban/<int:user_id>/', BanUserView.as_view(), name= "ban"),
    path('unban/<int:user_id>/', UnBanUserView.as_view(), name= "unban"),
    path('view_deposit_requests/', ViewDepositRequestsView.as_view(), name= "view_deposit_requests"),
    path('view_deposit_requests/<int:deposit_request_id>/', ViewDepositRequestDetailsView.as_view(), name= "view_deposit_details"),
    path('accept/<int:deposit_request_id>/', AcceptDepositRequestView.as_view(), name= "accept_deposit_request"),
    path('reject/<int:deposit_request_id>/', RejectDepositRequestView.as_view(), name= "reject_deposit_request"),
]
