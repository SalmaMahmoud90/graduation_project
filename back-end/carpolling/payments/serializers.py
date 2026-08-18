from payments.models import *
from django.db.models import F
from rest_framework import serializers
from rides.models import Reservation

class ViewBalanceSerializer(serializers.ModelSerializer):
    class Meta:
        model= Wallet
        fields= ['balance']

class CreateDepositRequestSerializer(serializers.ModelSerializer):
    class Meta:
        model= DepositRequest
        fields=['id', 'amount', 'payment_method', 'transaction_reference', ]

    def validate_amount(self, value):
        if value <= 0:
            raise serializers.ValidationError("Amount must be greater than zero.")
        return value
    
class ViewDepositRequestSerializer(serializers.ModelSerializer):
    class Meta:
        model= DepositRequest
        fields= ['id', 'payment_method', 'transaction_reference', 'amount', 'status', 'created_at']

class ViewTransactionsSerializer(serializers.ModelSerializer):
    class Meta:
        model= Transaction
        fields= ['id', 'transaction_type', 'created_at']


# class PaySerializer(serializers.ModelSerializer):

#     class Meta:
#         model = Transaction
#         fields = ["reservation"]

#     def validate(self, attrs):
#         user = self.context["request"].user
#         reservation = attrs["reservation"]

#         if reservation.rider.user != user:
#             raise serializers.ValidationError(
#                 "This isn't your reservation."
#             )

#         if reservation.status != Reservation.ReservationStatus.PENDING:
#             raise serializers.ValidationError(
#                 "Only pending reservations can be paid."
#             )

#         if reservation.payment != Reservation.PaymentStatus.UNPAID:
#             raise serializers.ValidationError(
#                 "This reservation has already been paid."
#             )

#         wallet = Wallet.objects.select_for_update().get(user=user)

#         if wallet.balance < reservation.ride.cost:
#             raise serializers.ValidationError(
#                 "Insufficient balance."
#             )

#         return attrs

#     def create(self, validated_data):
#         user = self.context["request"].user

#         wallet = Wallet.objects.select_for_update().get(user=user)
#         reservation = validated_data["reservation"]

#         wallet.balance = F("balance") - reservation.ride.cost
#         wallet.save()
#         wallet.refresh_from_db()

#         reservation.payment = Reservation.PaymentStatus.PAID
#         reservation.save()
        
#         return Transaction.objects.create(
#             wallet=wallet,
#             reservation=reservation,
#             amount=reservation.ride.cost,
#             transaction_type=Transaction.TransactionType.PAYMENT
#         )
