from django.shortcuts import render
from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from payments.models import Wallet, DepositRequest, Transaction
from .serializers import *
from django.db import transaction
from notifications.services import safe_send_notification
# Create your views here.

class ViewBalanceView(APIView):
    def get(self, request):
        user= request.user
        wallet= Wallet.objects.get(user= user)
        serializer= ViewBalanceSerializer(wallet)
        return Response(serializer.data, status= status.HTTP_200_OK)
    
class DepositRequestView(APIView):
    def post(self, request):
        user= request.user
        if user.user_type!= "rider":
            return Response(
                {"error": "Only riders can deposit request"}, 
                status=status.HTTP_403_FORBIDDEN
            )
        serializer= CreateDepositRequestSerializer(data= request.data)
        if serializer.is_valid():
            deposit_requests= serializer.save(user= user)
            return Response(CreateDepositRequestSerializer(deposit_requests).data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
class ViewDepositRequestView(APIView):
    def get(self, request):
        user= request.user
        if user.user_type== 'rider':
            deposit_requests= DepositRequest.objects.filter(user= user)
            serializer= ViewDepositRequestSerializer(deposit_requests, many=True)
            return Response({
                "deposit_requests": serializer.data
            }, status= status.HTTP_200_OK)
        return Response({"error": "Invalid user type"}, status=status.HTTP_400_BAD_REQUEST)
    
class ViewTransactionsView(APIView):
    def get(self, request):
        user= request.user
        transactions= Transaction.objects.filter(wallet__user=user)
        serializer= ViewTransactionsSerializer(transactions, many=True)
        return Response({
            "transactions": serializer.data
        }, status= status.HTTP_200_OK)
    
# class PayView(APIView):
#     @transaction.atomic
#     def post(self, request):
#         if not hasattr(request.user, 'rider'):
#             return Response(
#                {
#                     "error": "Only riders can pay for reservations."
#                 }, status=status.HTTP_403_FORBIDDEN
#             )
#         serializer = PaySerializer(
#         data=request.data,
#         context={"request": request}
#         )

#         if serializer.is_valid():
#             transaction_obj = serializer.save()

#             reservation = transaction_obj.reservation
#             wallet = Wallet.objects.get(user=request.user)

#             # Send notification after successful payment
#             safe_send_notification(
#                 user=request.user,
#                 title="Payment Successful",
#                 body=(
#                     f"Payment for your ride from "
#                     f"{reservation.ride.location} to "
#                     f"{reservation.ride.destination} "
#                     f"was completed successfully."
#                 ),
#                 data={
#                     "type": "payment_success",
#                     "reservation_id": str(reservation.id),
#                     "ride_id": str(reservation.ride.id),
#                 }
#             )
#             return Response({ "message": "Payment completed successfully.", 
#                              "transaction_id": transaction_obj.id, 
#                              "remaining_balance": wallet.balance},
#                                status=status.HTTP_200_OK)

#         return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
