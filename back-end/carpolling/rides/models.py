from django.db import models
from users.models import  Rider, MainUser

class Ride(models.Model):
    class RideStatus(models.TextChoices):
        ACTIVE = 'active', 'Active'
        COMPLETED = 'completed', 'Completed'
        CANCELLED = 'cancelled', 'Cancelled'

    departure_time = models.TimeField()
    departure_date = models.DateField()
    expected_duration= models.CharField(max_length=50, null= True, blank= True)
    location = models.CharField(max_length=50)
    destination = models.CharField(max_length=50)
    driver = models.ForeignKey("users.Driver", on_delete=models.CASCADE, related_name="drives")
    cost = models.DecimalField(max_digits=10, decimal_places=2)
    capacity = models.IntegerField()
    status = models.CharField(max_length=20, choices=RideStatus.choices, default=RideStatus.ACTIVE)
    rider = models.ManyToManyField(Rider, through='Reservation', related_name="rides")
    created_at= models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.location} to {self.destination} at {self.departure_time}"

    @property
    def available_seats(self):
        reserved_count = self.reservations.filter(
            status__in=[
                Reservation.ReservationStatus.PENDING,
                Reservation.ReservationStatus.ACCEPTED
            ]
        ).count()

        return self.capacity - reserved_count

class Reservation(models.Model):
    class ReservationStatus(models.TextChoices):
        PENDING = 'pending', 'Pending'
        ACCEPTED = 'accepted', 'Accepted'
        REJECTED = 'rejected', 'Rejected'
        CANCELLED = 'cancelled'

    class PaymentStatus(models.TextChoices):
        UNPAID = 'unpaid', 'Unpaid'
        PAID = 'paid', 'Paid'

    ride = models.ForeignKey(Ride, on_delete=models.CASCADE,related_name="reservations")
    rider = models.ForeignKey(Rider, on_delete=models.CASCADE)
    status = models.CharField(max_length=20, choices=ReservationStatus.choices, default=ReservationStatus.PENDING)
    payment = models.CharField(max_length=20, choices=PaymentStatus.choices, default=PaymentStatus.UNPAID)
    pickup_location = models.CharField(max_length=255)
    created_at= models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.rider.user.name} -> {self.ride}"
    class Meta:
        unique_together = ['ride', 'rider']


