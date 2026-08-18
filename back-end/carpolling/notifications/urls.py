from django.urls import path
from .views import RegisterDeviceTokenView


urlpatterns = [

    path("register-device/", RegisterDeviceTokenView.as_view(), name="register-device"),

]