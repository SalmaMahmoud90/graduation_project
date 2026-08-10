# Backend Dashboard API TODOs

Commit: `9a342eb0093e3ea244edd81e03cafaf468798050`
Repository: `graduation_project`
Scope: backend `back-end/carpolling` dashboard and related API changes

## Summary

This commit updates the admin dashboard API behavior and adds new detail endpoints. The frontend team should update dashboard pages to use the new paginated list endpoints and the new ride/user detail endpoints.

## Changed backend files

- `back-end/carpolling/dashboard/urls.py`
- `back-end/carpolling/dashboard/views.py`
- `back-end/carpolling/dashboard/serializers.py`
- `back-end/carpolling/users/pagination.py`
- `back-end/carpolling/rides/models.py`
- `back-end/carpolling/rides/serializers.py`
- `back-end/carpolling/users/models.py`

## Frontend TODOs

1. Update dashboard rides listing
   - Use `GET /dashboard/view_rides/`
   - Expect paginated response via `CustomerCursorPagination`
   - Each ride object now includes:
     - `id`
     - `location`
     - `destination`
     - `departure_time`
     - `arrival_time`
     - `cost`
     - `capacity`
     - `status`
     - `driver_name`
   - If needed, adapt UI to handle `next` / `previous` cursor pagination fields.

2. Add or update ride detail screen
   - Use `GET /dashboard/view_ride_details/<ride_id>/`
   - Response includes:
     - `id`
     - `location`
     - `destination`
     - `departure_time`
     - `arrival_time`
     - `cost`
     - `capacity`
     - `available_seats`
     - `status`
     - `driver_name`
     - `reservations` (list)
   - Each reservation includes:
     - `id`
     - `rider_name`
     - `ride`
     - `status`
     - `created_at`
     - `payment`

3. Update dashboard users listing
   - Use `GET /dashboard/view_users/`
   - Expect paginated response
   - Each user object now includes:
     - `id`
     - `name`
     - `user_type`
     - `created_at`
     - `is_active`
     - `email`

4. Add or update user detail screen
   - Use `GET /dashboard/view_user_details/<user_id>/`
   - Response varies by `user_type`:
     - `driver` returns `user_type: driver` and `rides` list
     - `rider` returns `user_type: rider` and `reservations` list
   - Driver rides use `RideSearchSerializer`, including `available_seats`.
   - Rider reservations include:
     - `id`
     - `rider_name`
     - `status`
     - `payment`
     - `ride_location`
     - `ride_destination`
     - `created_at`

5. Update reservations listing
   - Use `GET /dashboard/view_reservations/`
   - Expect paginated response
   - Each reservation object now includes `payment` in the list response.

6. Verify datetime format handling
   - `Ride` model now uses `departure_time` and `arrival_time` as `DateTimeField`
   - Ensure frontend date/time parsing/formatting is compatible with full datetimes.

7. Review user-type handling
   - `MainUser.user_type` is now nullable.
   - Guard UI flows if any user record has missing or undefined `user_type`.

## Notes

- The backend uses cursor pagination (`CustomerCursorPagination`) with page size `10`.
- The new detail endpoints are admin-only, so make sure auth headers and permission handling are set in dashboard requests.
- No frontend changes were made in this commit; this file is for coordinating the frontend update.
