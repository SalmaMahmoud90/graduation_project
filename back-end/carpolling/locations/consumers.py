import json

from channels.generic.websocket import AsyncJsonWebsocketConsumer
from channels.db import database_sync_to_async
from rides.models import Ride, Reservation
from .models import CurrentLocation, LocationPoint

class LocationConsumer(AsyncJsonWebsocketConsumer):
    async def connect(self):
        self.user = self.scope["user"]
        self.ride_id = self.scope["url_route"]["kwargs"]["ride_id"]
        if self.user.is_anonymous:
            await self.close()
            return

        if not await self.user_can_access_ride():
            await self.close()
            return

        self.room_group_name = f"ride_{self.ride_id}"

        await self.channel_layer.group_add(
            self.room_group_name,
            self.channel_name
        )

        await self.accept()

    async def disconnect(self, close_code):
        if hasattr(self, "room_group_name"):
            await self.channel_layer.group_discard(
                self.room_group_name,
                self.channel_name
            )

    async def receive_json(self, content, **kwargs):

        latitude = content.get("latitude")
        longitude = content.get("longitude")

        if latitude is None or longitude is None:
            await self.send_json({
                "error": "latitude and longitude are required."
            })
            return

        location = await self.save_location(
            latitude,
            longitude
        )

        await self.channel_layer.group_send(
            self.room_group_name,
            {
                "type": "location_update",
                "user_id": self.user.id,
                "latitude": float(location["latitude"]),
                "longitude": float(location["longitude"]),
                "recorded_at": location["recorded_at"],
            }
        )

    async def location_update(self, event):

        await self.send_json({
            "type": "location_update",
            "user_id": event["user_id"],
            "latitude": event["latitude"],
            "longitude": event["longitude"],
            "recorded_at": event["recorded_at"],
        })

    @database_sync_to_async
    def user_can_access_ride(self):

        try:
            ride = Ride.objects.get(id=self.ride_id)
        except Ride.DoesNotExist:
            return False

        # Driver
        if hasattr(self.user, "driver"):
            return ride.driver.user_id == self.user.id

        # Rider
        if hasattr(self.user, "rider"):
            return Reservation.objects.filter(
                ride=ride,
                rider=self.user.rider,
                status=Reservation.ReservationStatus.ACCEPTED
            ).exists()
        
        # Admin
        if self.user.user_type == "admin":
            return True
        
        return False

    @database_sync_to_async
    def save_location(self, latitude, longitude):

        ride = Ride.objects.get(id=self.ride_id)

        current_location, _ = CurrentLocation.objects.update_or_create(
            user=self.user,
            defaults={
                "latitude": latitude,
                "longitude": longitude,
            }
        )

        location_point = LocationPoint.objects.create(
            ride=ride,
            user=self.user,
            latitude=latitude,
            longitude=longitude,
        )

        return {
            "latitude": location_point.latitude,
            "longitude": location_point.longitude,
            "recorded_at": location_point.recorded_at.isoformat(),
        }