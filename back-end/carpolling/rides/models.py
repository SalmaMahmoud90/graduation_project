from django.db import models
from users.models import  Rider

class Ride(models.Model):
    class RideStatus(models.TextChoices):
        ACTIVE = 'active', 'Active'
        COMPLETED = 'completed', 'Completed'
        CANCELLED = 'cancelled', 'Cancelled'

    departure_time = models.TimeField(null=True, blank=True)
    arrival_time = models.TimeField(null=True, blank=True)
    location = models.CharField(max_length=50)
    destination = models.CharField(max_length=50)
    driver = models.ForeignKey("users.Driver", on_delete=models.CASCADE, related_name="rides")
    cost = models.CharField(max_length=50)
    capacity = models.IntegerField()
    status = models.CharField(max_length=20, choices=RideStatus.choices, default=RideStatus.ACTIVE)
    rider = models.ManyToManyField(Rider, through='Reservation', related_name="rides")
    car_image = models.ImageField(upload_to='car_images/', null=True, blank=True)

    def __str__(self):
        return f"{self.location} to {self.destination} at {self.departure_time}"

    @property
    def available_seats(self):
        return self.capacity - self.reservation_set.count()

class Reservation(models.Model):
    class ReservationStatus(models.TextChoices):
        PENDING = 'pending', 'Pending'
        ACCEPTED = 'accepted', 'Accepted'
        REJECTED = 'rejected', 'Rejected'

    class PaymentStatus(models.TextChoices):
        UNPAID = 'unpaid', 'Unpaid'
        PAID = 'paid', 'Paid'

    ride = models.ForeignKey(Ride, on_delete=models.CASCADE)
    rider = models.ForeignKey(Rider, on_delete=models.CASCADE)
    status = models.CharField(max_length=20, choices=ReservationStatus.choices, default=ReservationStatus.PENDING)
    payment = models.CharField(max_length=20, choices=PaymentStatus.choices, default=PaymentStatus.UNPAID)

    def __str__(self):
        return f"{self.rider.user.name} -> {self.ride}"
