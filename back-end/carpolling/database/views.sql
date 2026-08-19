-- ============================================================================
-- ملف: views.sql
-- الغرض: كل الـ Views (تقارير/لوحة تحكم/ملخّصات).
--        مُستخرَج من data_3_full_expansion_3_revised.sql.
-- ملاحظة: تُنشأ بـ CREATE OR REPLACE فهي idempotent.
-- ============================================================================

USE `carpool_db`;

-- ----------------------------------------------------------------------------
-- الرحلات والحجوزات والمستخدمون (الـ Views الأربعة الأصلية)
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW `view_driver_trips_count` AS
SELECT d.`id` AS driver_id, u.`email` AS driver_email, COUNT(r.`id`) AS total_rides
FROM `users_driver` d
JOIN `users_mainuser` u ON d.`user_id` = u.`id`
LEFT JOIN `rides_ride` r ON d.`id` = r.`driver_id`
GROUP BY d.`id`, u.`email`;

CREATE OR REPLACE VIEW `view_most_active_riders` AS
SELECT ru.`id` AS rider_id, mu.`email` AS rider_email, COUNT(res.`id`) AS total_reservations
FROM `users_rider` ru
JOIN `users_mainuser` mu ON ru.`user_id` = mu.`id`
LEFT JOIN `rides_reservation` res ON ru.`id` = res.`rider_id`
GROUP BY ru.`id`, mu.`email`;

CREATE OR REPLACE VIEW `view_popular_destinations` AS
SELECT `destination` AS destination_city, COUNT(*) AS total_trips_to_destination
FROM `rides_ride`
GROUP BY `destination`;

CREATE OR REPLACE VIEW `view_popular_pickup_locations` AS
SELECT `pickup_location` AS student_pickup_point, COUNT(*) AS total_requests
FROM `rides_reservation`
WHERE `pickup_location` IS NOT NULL
GROUP BY `pickup_location`;

-- ----------------------------------------------------------------------------
-- جداول المستخدمين
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW `view_user_role_summary` AS
SELECT
    COALESCE(`user_type`, 'unspecified') AS user_type,
    SUM(CASE WHEN `is_active` = 1 THEN 1 ELSE 0 END) AS active_count,
    SUM(CASE WHEN `is_active` = 0 THEN 1 ELSE 0 END) AS inactive_count,
    COUNT(*) AS total_count
FROM `users_mainuser`
GROUP BY COALESCE(`user_type`, 'unspecified');

CREATE OR REPLACE VIEW `view_inactive_users` AS
SELECT `id`, `email`, `user_type`, `last_login`, `created_at`
FROM `users_mainuser`
WHERE `last_login` IS NULL
   OR `last_login` < (NOW() - INTERVAL 90 DAY);

-- ----------------------------------------------------------------------------
-- الرحلات والحجوزات: معدّل الإشغال
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW `view_ride_occupancy_rate` AS
SELECT
    r.`id` AS ride_id,
    r.`capacity`,
    COUNT(res.`id`) AS accepted_reservations,
    ROUND(COUNT(res.`id`) / NULLIF(r.`capacity`, 0) * 100, 1) AS occupancy_percent
FROM `rides_ride` r
LEFT JOIN `rides_reservation` res
    ON res.`ride_id` = r.`id` AND res.`status` = 'accepted'
GROUP BY r.`id`, r.`capacity`;

-- ----------------------------------------------------------------------------
-- طبقة المراقبة
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW `view_audit_activity_by_day` AS
SELECT DATE(`action_time`) AS log_date, `table_name`, COUNT(*) AS events_count
FROM `audit_log`
GROUP BY DATE(`action_time`), `table_name`;

-- ----------------------------------------------------------------------------
-- المصادقة والجلسات
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW `view_active_sessions_count` AS
SELECT COUNT(*) AS active_sessions FROM `django_session` WHERE `expire_date` > NOW();

-- ----------------------------------------------------------------------------
-- وحدة الدفع
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW `view_wallet_summary` AS
SELECT
    w.`id` AS wallet_id,
    w.`user_id`,
    w.`balance`,
    COALESCE(SUM(CASE WHEN t.`transaction_type` = 'deposit' THEN t.`amount` ELSE 0 END), 0) AS total_deposits,
    COALESCE(SUM(CASE WHEN t.`transaction_type` <> 'deposit' THEN t.`amount` ELSE 0 END), 0) AS total_spent
FROM `payments_wallet` w
LEFT JOIN `payments_transaction` t ON t.`wallet_id` = w.`id`
GROUP BY w.`id`, w.`user_id`, w.`balance`;

-- كشف الأنماط المشبوهة: أكثر من 3 طلبات إيداع لنفس المستخدم خلال ساعة واحدة
CREATE OR REPLACE VIEW `view_suspicious_deposits` AS
SELECT
    `user_id`,
    DATE_FORMAT(`created_at`, '%Y-%m-%d %H:00') AS hour_bucket,
    COUNT(*) AS deposit_requests_count
FROM `payments_depositrequest`
GROUP BY `user_id`, DATE_FORMAT(`created_at`, '%Y-%m-%d %H:00')
HAVING COUNT(*) > 3;

-- ----------------------------------------------------------------------------
-- وحدة البلاغات
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW `view_most_reported_users` AS
SELECT `reported_user_id`, COUNT(*) AS reports_count
FROM `reports_report`
GROUP BY `reported_user_id`
ORDER BY reports_count DESC;

-- ----------------------------------------------------------------------------
-- الموقع الجغرافي
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW `view_last_known_location` AS
SELECT `user_id`, `latitude`, `longitude`, `updated_at`
FROM `locations_currentlocation`;

CREATE OR REPLACE VIEW `view_location_data_footprint` AS
SELECT `user_id`, COUNT(*) AS stored_points, MIN(`recorded_at`) AS earliest, MAX(`recorded_at`) AS latest
FROM `locations_locationpoint`
GROUP BY `user_id`;

-- ----------------------------------------------------------------------------
-- View شاملة للوحة تحكم إدارية
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW `view_admin_dashboard_summary` AS
SELECT
    (SELECT COUNT(*) FROM `users_mainuser` WHERE `is_active` = 1) AS active_users,
    (SELECT COUNT(*) FROM `rides_ride` WHERE `status` = 'active') AS active_rides,
    (SELECT COUNT(*) FROM `reports_report` WHERE `status` = 'pending') AS open_reports,
    (SELECT COALESCE(SUM(`balance`), 0) FROM `payments_wallet`) AS total_wallet_balance,
    (SELECT COALESCE(SUM(`total_revenue`), 0) FROM `daily_platform_summary`
        WHERE `summary_date` >= CURDATE() - INTERVAL 30 DAY) AS revenue_last_30_days;
