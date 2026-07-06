from django.db.models.signals import post_save
from django.dispatch import receiver
from users.models import MainUser
from .models import Wallet

@receiver(post_save, sender=MainUser)
def create_wallet(sender, instance, created, **kwargs):
    if created:
        Wallet.objects.create(user=instance)