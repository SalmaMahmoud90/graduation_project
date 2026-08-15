# from django.db import models
# from users.models import MainUser

# class UserDevice(models.Model):
#     user = models.ForeignKey(
#         MainUser,
#         on_delete=models.CASCADE,
#         related_name="devices"
#     )
#     token = models.TextField(unique=True)
#     is_active = models.BooleanField(default=True)
#     created_at = models.DateTimeField(auto_now_add=True)
#     updated_at = models.DateTimeField(auto_now=True)