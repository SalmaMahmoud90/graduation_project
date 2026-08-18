from django.urls import path
from .views import *

urlpatterns = [
    path('view_balance/', ViewBalanceView.as_view(), name= 'view_balance'),
    path('deposit_request/', DepositRequestView.as_view(), name= 'deposit_request'),
    path('view_deposit_requests/', ViewDepositRequestView.as_view(), name= 'view_deposit_requests'),
    path('view_transactions/', ViewTransactionsView.as_view(), name= 'view_transactions'),
]