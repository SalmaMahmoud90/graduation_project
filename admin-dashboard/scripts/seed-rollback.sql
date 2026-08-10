-- =============================================================================
-- Roll back dev seed data created by seed.sql (MySQL 8+)
-- Matches rows tied to emails ending in @seed.local
-- =============================================================================
-- If you added OAuth tokens, sessions, or admin log rows for these users,
-- clear those tables separately (e.g. oauth2_provider_accesstoken, django_session).
-- =============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- Reservations on rides driven by seeded drivers
DELETE rr
FROM rides_reservation rr
left join rides_ride ri ON rr.ride_id = ri.id
left join users_driver ud ON ri.driver_id = ud.id
left join users_mainuser u ON ud.user_id = u.id
WHERE (u.email LIKE '%@seed.local') or u.email is null;

-- Reservations booked by seeded riders (covers edge cases)
DELETE rr
FROM rides_reservation rr
left join users_rider ur ON rr.rider_id = ur.id
left join users_mainuser u ON ur.user_id = u.id
WHERE (u.email LIKE '%@seed.local') or u.email is null;

-- Rides from seeded drivers
DELETE ri
FROM rides_ride ri
left join users_driver ud ON ri.driver_id = ud.id
left join users_mainuser u ON ud.user_id = u.id
WHERE (u.email LIKE '%@seed.local') or u.email is null;

DELETE ua
FROM users_appadmin ua
left join users_mainuser u ON ua.user_id = u.id
WHERE (u.email LIKE '%@seed.local') or u.email is null;

DELETE ud
FROM users_driver ud
left join users_mainuser u ON ud.user_id = u.id
WHERE (u.email LIKE '%@seed.local') or u.email is null;

DELETE ur
FROM users_rider ur
left join users_mainuser u ON ur.user_id = u.id
WHERE (u.email LIKE '%@seed.local') or u.email is null;

DELETE FROM users_mainuser
WHERE email LIKE '%@seed.local';

SET FOREIGN_KEY_CHECKS = 1;

-- Optional: reset AUTO_INCREMENT when tables are empty (uncomment if needed)
SELECT IFNULL(MAX(id), 0) + 1 FROM users_mainuser;  -- then set each table accordingly
ALTER TABLE users_mainuser AUTO_INCREMENT = 1;
ALTER TABLE users_driver AUTO_INCREMENT = 1;
ALTER TABLE users_rider AUTO_INCREMENT = 1;
ALTER TABLE users_appadmin AUTO_INCREMENT = 1;
ALTER TABLE rides_ride AUTO_INCREMENT = 1;
ALTER TABLE rides_reservation AUTO_INCREMENT = 1;
