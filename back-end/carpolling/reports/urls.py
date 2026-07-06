from django.urls import path
from .views import *

urlpatterns = [
    path('report/', CreateReportAPIView.as_view(), name= 'report')
]
