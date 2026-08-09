from rest_framework import serializers
from payments.models import *
from users.models import *
from rides.models import *
from reports.models import *

class ViewRidesSerializer(serializers.ModelSerializer):
    driver_name = serializers.CharField(source='driver.user.name', read_only=True)
    available_seats = serializers.IntegerField(read_only=True)
    class Meta:
        model= Ride
        fields=["id", "location", "destination", "driver_name", "departure_time", "departure_date", "expected_duration", "capacity", "available_seats", "cost", "status"]

class ViewUsersSerializer(serializers.ModelSerializer):
    reports_count = serializers.IntegerField(read_only=True)
    balance = serializers.DecimalField(source="wallet.balance", max_digits=10, decimal_places=2, read_only=True)
    class Meta:
        model= MainUser
        fields=["id", "name", "user_type", "reports_count", "created_at", "is_active", "email", "balance"]

class ViewReservationsSerializer(serializers.ModelSerializer):
    rider_name = serializers.CharField(source='rider.user.name', read_only=True)
    class Meta:
        model= Reservation
        fields=["id", "rider_name", "ride", "status", "created_at", "payment"]

class ViewRideDetailSerializer(serializers.ModelSerializer):
    available_seats = serializers.IntegerField(read_only=True)

    reservations = ViewReservationsSerializer(
        source='reservation_set',
        many=True,
        read_only=True
    )

    driver_name = serializers.CharField(
        source='driver.user.name',
        read_only=True
    )

    class Meta:
        model = Ride
        fields = [
            "id",
            "location",
            "destination",
            "departure_time",
            "departure_date",
            "expected_duration"
            "cost",
            "capacity",
            "available_seats",
            "status",
            "driver_name",
            "reservations"
        ]

class TransactionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Transaction
        fields = [
            "id",
            "amount",
            "transaction_type",
            "created_at",
        ]
    
class UserProfileSerializer(serializers.ModelSerializer):
    transactions = serializers.SerializerMethodField()
    user_type = serializers.CharField()
    status = serializers.SerializerMethodField()
    balance = serializers.DecimalField(source="wallet.balance",max_digits=10,decimal_places=2,read_only=True)
    class Meta:
        model = MainUser
        fields = [
            "id",
            "user_type",
            "status",
            "created_at",
            "transactions",
            "balance"
        ]
    def get_status(self, obj):
        return "Active" if obj.is_active else "Blocked"

    def get_transactions(self, obj):
        try:
            transactions = Transaction.objects.filter(
                wallet=obj.wallet
            ).order_by("-created_at")

            return TransactionSerializer(
                transactions,
                many=True
            ).data

        except Wallet.DoesNotExist:
            return []
    

class ViewReportsSerializer(serializers.ModelSerializer):
    class Meta:
        model= Report
        fields= [
            'id',
            'reporter',
            'reported_user',
            'ride',
            'type',
            'reason',
            'status',
            'created_at',
            'updated_at',
        ]

class ViewReportDetailsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Report
        fields = [
            'id',
            'reporter',
            'reported_user',
            'ride',
            'type',
            'reason',
            'status',
            'admin_note',
            'created_at',
            'updated_at',
        ]


class AdminNoteSerializer(serializers.ModelSerializer):
    class Meta:
        model = Report
        fields = ["admin_note"]

    def validate_admin_note(self, value):
        if not value.strip():
            raise serializers.ValidationError(
                "Admin note cannot be empty."
            )
        return value

class ViewDepositRequestsSerializer(serializers.ModelSerializer):
    user_name = serializers.CharField(source="user.name", read_only=True)
    class Meta:
        model= DepositRequest
        fields= ['id', 'user_name', 'payment_method', 'amount', 'status', 'created_at']

class ViewDepositRequestDetailsSerializer(serializers.ModelSerializer):
    user_name = serializers.CharField(source="user.name", read_only=True)
    class Meta:
        model= DepositRequest
        fields= ['id', 'user_name', 'payment_method', 'amount', 'status', 'transaction_reference', 'created_at']