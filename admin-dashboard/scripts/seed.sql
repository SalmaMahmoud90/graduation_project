-- =============================================================================
-- Carpool dev seed (MySQL 8+) — large dataset, SQL only
-- Database: carpool_db (match settings.py)
-- All seeded users password: seedpass123
-- Names: short Syrian-style Arabic given names (users_mainuser.name max 15 chars)
-- Places: Syrian cities for rider locations and ride origin/destination
--
-- IDs are allocated AFTER your current MAX(id) so this works even when user id 1
-- already exists (e.g. createsuperuser). Without that, MySQL errors with:
--   ERROR 1062: Duplicate entry '1' for key 'users_mainuser.PRIMARY'
-- and inserts zero main users.
--
-- Rollback: scripts/seed-rollback.sql
-- =============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;
SET UNIQUE_CHECKS = 0;
SET autocommit = 0;
START TRANSACTION;

-- Drop prior seed snapshot (same logic as seed-rollback.sql)
DELETE rr
FROM rides_reservation rr
INNER JOIN rides_ride ri ON rr.ride_id = ri.id
INNER JOIN users_driver ud ON ri.driver_id = ud.id
INNER JOIN users_mainuser u ON ud.user_id = u.id
WHERE u.email LIKE '%@seed.local';

DELETE rr
FROM rides_reservation rr
INNER JOIN users_rider ur ON rr.rider_id = ur.id
INNER JOIN users_mainuser u ON ur.user_id = u.id
WHERE u.email LIKE '%@seed.local';

DELETE ri
FROM rides_ride ri
INNER JOIN users_driver ud ON ri.driver_id = ud.id
INNER JOIN users_mainuser u ON ud.user_id = u.id
WHERE u.email LIKE '%@seed.local';

DELETE ua
FROM users_appadmin ua
INNER JOIN users_mainuser u ON ua.user_id = u.id
WHERE u.email LIKE '%@seed.local';

DELETE ud
FROM users_driver ud
INNER JOIN users_mainuser u ON ud.user_id = u.id
WHERE u.email LIKE '%@seed.local';

DELETE ur
FROM users_rider ur
INNER JOIN users_mainuser u ON ur.user_id = u.id
WHERE u.email LIKE '%@seed.local';

DELETE FROM users_mainuser
WHERE email LIKE '%@seed.local';

-- Next block of user PKs starts after existing rows
SET @seed_base := (SELECT IFNULL(MAX(id), 0) FROM users_mainuser);

-- -----------------------------------------------------------------------------
-- users_mainuser: 201 rows — admin + 50 drivers + 150 riders
-- PKs: @seed_base + 1 .. @seed_base + 201
-- -----------------------------------------------------------------------------
INSERT INTO users_mainuser (
  id, password, last_login, is_superuser,
  name, email, profile_picture, user_type,
  phone,
  is_staff, is_active, created_at, updated_at
)
WITH RECURSIVE seq AS (
  SELECT 1 AS id
  UNION ALL
  SELECT id + 1 FROM seq WHERE id < 201
)
SELECT
  @seed_base + s.id,
  'pbkdf2_sha256$1000000$7TZlaJS71yGuzISvdTv0in$LgPN1tpXWVincTE1/lcemBtHLYtbSGReW3iMiIkia2k=',
  NULL,
  IF(s.id = 1, 1, 0),
  CASE
    WHEN s.id = 1 THEN 'مسؤول النظام'
    WHEN s.id BETWEEN 2 AND 51 THEN ELT(
      1 + ((s.id - 2) % 40),
      'أحمد', 'ليلى', 'رامي', 'نور', 'يوسف', 'مروان', 'غسان', 'سمية', 'طارق', 'هبة',
      'باسل', 'رانيا', 'فادي', 'كنان', 'مازن', 'دلال', 'سمير', 'هند', 'كريم', 'أماني',
      'بشرى', 'عمر', 'سارة', 'خالد', 'فاطمة', 'حسن', 'زينب', 'علي', 'ميساء', 'وائل',
      'لانا', 'تيسير', 'رشا', 'جمانة', 'معن', 'سلمى', 'فارس', 'إيمان', 'تميم', 'نهى'
    )
    ELSE ELT(
      1 + ((s.id - 52 + 7) % 40),
      'بلال', 'شهد', 'أنس', 'دعاء', 'جميل', 'ليان', 'يارا', 'بدر', 'رغد', 'سامي',
      'هاجر', 'طارق', 'لينا', 'عدي', 'سحر', 'رائد', 'مها', 'سفيان', 'رنا', 'عادل',
      'وفاء', 'ماهر', 'إيناس', 'حسام', 'ديانا', 'بشير', 'غادة', 'سامر', 'هالة', 'فهد',
      'نجلاء', 'وليد', 'سندس', 'عماد', 'رشا', 'طارق', 'هبة', 'زياد', 'سلوى', 'كرم'
    )
  END,
  CASE
    WHEN s.id = 1 THEN 'admin@seed.local'
    WHEN s.id BETWEEN 2 AND 51 THEN CONCAT('driver', s.id - 1, '@seed.local')
    ELSE CONCAT('rider', s.id - 51, '@seed.local')
  END,
  NULL,
  CASE
    WHEN s.id = 1 THEN 'admin'
    WHEN s.id BETWEEN 2 AND 51 THEN 'driver'
    ELSE 'rider'
  END,
  CONCAT('+9639', LPAD(@seed_base + s.id, 8, '0')),
  IF(s.id = 1, 1, 0),
  1,
  NOW() - INTERVAL s.id DAY,
  NOW() - INTERVAL s.id HOUR
FROM seq s;

-- -----------------------------------------------------------------------------
-- users_appadmin — links to seeded admin row
-- -----------------------------------------------------------------------------
INSERT INTO users_appadmin (user_id)
VALUES (@seed_base + 1);

-- -----------------------------------------------------------------------------
-- users_driver — 50 rows (avoid fixed PKs clashing with existing drivers)
-- -----------------------------------------------------------------------------
SET @drv_base := (SELECT IFNULL(MAX(id), 0) FROM users_driver);

INSERT INTO users_driver (
  id, user_id, car_model, car_color, car_number
)
SELECT
  @drv_base + (u.id - (@seed_base + 1)),
  u.id,
  ELT(1 + (u.id % 5), 'Toyota Corolla', 'Honda Civic', 'Hyundai Elantra', 'Kia Rio', 'Nissan Sunny'),
  ELT(1 + (u.id % 7), 'White', 'Black', 'Silver', 'Red', 'Blue', 'Gray', 'Green'),
  CONCAT('SY ', LPAD(u.id - (@seed_base + 1), 5, '0'))
FROM users_mainuser u
WHERE u.id BETWEEN @seed_base + 2 AND @seed_base + 51
ORDER BY u.id;

-- -----------------------------------------------------------------------------
-- users_rider — 150 rows
-- -----------------------------------------------------------------------------
SET @rdr_base := (SELECT IFNULL(MAX(id), 0) FROM users_rider);

INSERT INTO users_rider (
  id, user_id, current_location
)
SELECT
  @rdr_base + (u.id - (@seed_base + 51)),
  u.id,
  ELT(
    1 + (u.id % 22),
    'دمشق', 'حلب', 'حمص', 'حماة', 'اللاذقية', 'طرطوس', 'إدلب', 'الرقة', 'دير الزور',
    'درعا', 'السويداء', 'القامشلي', 'منبج', 'دوما', 'جبلة', 'بانياس', 'تدمر', 'الحسكة',
    'داريا', 'معرة النعمان', 'البوكمال', 'الثورة'
  )
FROM users_mainuser u
WHERE u.id BETWEEN @seed_base + 52 AND @seed_base + 201
ORDER BY u.id;

-- -----------------------------------------------------------------------------
-- rides_ride — 300 rides; driver_id points at this seed’s driver PK range
-- -----------------------------------------------------------------------------
SET @ride_base := (SELECT IFNULL(MAX(id), 0) FROM rides_ride);

INSERT INTO rides_ride (
  id, departure_time, departure_date, location, destination,
  driver_id, cost, capacity, status, created_at
)
WITH RECURSIVE seq AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1 FROM seq WHERE n < 300
)
SELECT
  @ride_base + n,
  SEC_TO_TIME(25200 + (n % 8) * 2700),
  CURDATE() + INTERVAL (n % 30) DAY,
  ELT(
    1 + (n % 22),
    'دمشق', 'حلب', 'حمص', 'حماة', 'اللاذقية', 'طرطوس', 'إدلب', 'الرقة', 'دير الزور',
    'درعا', 'السويداء', 'القامشلي', 'منبج', 'دوما', 'جبلة', 'بانياس', 'تدمر', 'الحسكة',
    'داريا', 'معرة النعمان', 'البوكمال', 'الثورة'
  ),
  ELT(
    1 + ((n * 5) % 22),
    'حلب', 'دمشق', 'طرطوس', 'حمص', 'اللاذقية', 'حماة', 'إدلب', 'دير الزور', 'الرقة',
    'درعا', 'السويداء', 'القامشلي', 'منبج', 'دوما', 'جبلة', 'بانياس', 'تدمر', 'الحسكة',
    'داريا', 'معرة النعمان', 'البوكمال', 'الثورة'
  ),
  @drv_base + 1 + ((n - 1) % 50),
  ROUND(8.50 + (n % 40) + (n % 7) * 0.25, 2),
  3 + (n % 4),
  ELT(1 + (n % 9), 'active', 'active', 'active', 'completed', 'completed', 'cancelled', 'active', 'active', 'active'),
  NOW() - INTERVAL n HOUR
FROM seq;

-- -----------------------------------------------------------------------------
-- rides_reservation — 1200 rows
-- -----------------------------------------------------------------------------
INSERT INTO rides_reservation (ride_id, rider_id, status, payment, pickup_location, created_at)
WITH RECURSIVE rseq AS (
  SELECT @ride_base + 1 AS ride_id
  UNION ALL
  SELECT ride_id + 1 FROM rseq WHERE ride_id < @ride_base + 300
),
slots AS (
  SELECT 0 AS s UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3
)
SELECT
  r.ride_id,
  @rdr_base + 1 + ((r.ride_id * 10 + s.s) % 150),
  ELT(1 + (r.ride_id + s.s) % 3, 'pending', 'accepted', 'rejected'),
  IF((r.ride_id + s.s) % 2 = 0, 'paid', 'unpaid'),
  ELT(
    1 + ((r.ride_id + s.s) % 22),
    'دمشق', 'حلب', 'حمص', 'حماة', 'اللاذقية', 'طرطوس', 'إدلب', 'الرقة', 'دير الزور',
    'درعا', 'السويداء', 'القامشلي', 'منبج', 'دوما', 'جبلة', 'بانياس', 'تدمر', 'الحسكة',
    'داريا', 'معرة النعمان', 'البوكمال', 'الثورة'
  ),
  NOW() - INTERVAL (r.ride_id + s.s) HOUR
FROM rseq r
CROSS JOIN slots s;

COMMIT;

SET UNIQUE_CHECKS = 1;
SET FOREIGN_KEY_CHECKS = 1;
SET autocommit = 1;
