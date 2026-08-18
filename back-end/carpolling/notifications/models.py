from django.db import models
from users.models import MainUser


class DeviceToken(models.Model):

    user = models.ForeignKey(
        MainUser,
        on_delete=models.CASCADE,
        related_name="device_tokens"
    )

    token = models.CharField(max_length=500, unique=True)

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ["-updated_at"]

    def __str__(self):
        return f"{self.user.email} - {self.token[:20]}"