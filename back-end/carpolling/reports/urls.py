from django.urls import path
from .views import *

urlpatterns = [
    path('report/user/<int:user_id>/', CreateReportView.as_view(), name= 'report'),
    path('shared_rides/<int:user_id>/', SharedRidesView.as_view(), name= 'shared_rides'),
    path('my_reports/', MyReportsView.as_view(), name='my_reports'),
    path('view_report_details/<int:report_id>/', ViewReportDetailsView.as_view(), name='view_report_details'),
]
