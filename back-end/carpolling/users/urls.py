from django.urls import path
from .views import *


urlpatterns = [
   path('create/', CreateAccount.as_view(), name="create_user"),
   path('login/', Login.as_view(), name="login"),
   path('view_profile/', ViewProfile.as_view(), name="view_profile"),
   path('update_driver_profile/', UpdateDriverProfile.as_view(), name="update_driver_profile"),
   path('update_rider_profile/', UpdateRiderProfile.as_view(), name="update_rider_profile"),
   path('logout/', Logout.as_view(), name= "logout"),
   ]