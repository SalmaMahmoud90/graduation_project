from django.db import models

class Wallet(models.Model):
    user = models.OneToOneField('users.MainUser', on_delete=models.CASCADE)
    balance = models.DecimalField(max_digits=10, decimal_places=2, default=0)

class Transaction(models.Model):
    class TransactionType(models.TextChoices):
        DEPOSIT = "deposit", "Deposit"
        PAYMENT = "payment", "Payment"
        EARNING = "earning", "Earning"

    wallet = models.ForeignKey(Wallet, on_delete=models.CASCADE)
    reservation = models.ForeignKey('rides.Reservation', on_delete=models.SET_NULL, null=True, blank=True)
    deposit_request = models.ForeignKey('DepositRequest', on_delete=models.SET_NULL, null=True, blank=True)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    transaction_type = models.CharField(max_length=20, choices=TransactionType.choices)
    created_at = models.DateTimeField(auto_now_add=True)

class DepositRequest(models.Model):
    class PaymentMethod(models.TextChoices):
        SYRIATEL_CASH = "syriatel_cash", "Syriatel Cash"
        SHAM_CASH= 'sham_cash', 'Sham Cash'
    class Status(models.TextChoices):
        PENDING = "pending"
        APPROVED = "approved"
        REJECTED = "rejected"

    user = models.ForeignKey('users.MainUser', on_delete=models.CASCADE)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    payment_method = models.CharField(max_length=20, choices=PaymentMethod.choices)
    transaction_reference = models.CharField(max_length=100)
    status = models.CharField(max_length=20, choices=Status.choices, default=Status.PENDING)
    created_at = models.DateTimeField(auto_now_add=True)