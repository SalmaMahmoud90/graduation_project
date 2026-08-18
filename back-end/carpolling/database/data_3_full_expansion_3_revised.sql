-- ============================================================================
-- ملف: data_3_full_expansion_3_revised.sql
-- الغرض: نسخة مُعدّلة من data_3_full_expansion_3.sql بعد مطابقتها مع كود
--        الـ Backend (Django) لإزالة التعارضات.
--
-- التعديلات مقارنةً بالملف الأصلي:
--   1) [صلاحيات] مُنحت app_readwrite كل ما يحتاجه الـ Backend فعليًا:
--        - UPDATE على payments_wallet (التطبيق يعدّل الرصيد مباشرةً عبر F()).
--        - UPDATE على payments_depositrequest (قبول/رفض طلب الإيداع).
--        - SELECT على daily_platform_summary وكل الـ Views (لوحة التحكم).
--   2) [حجوزات] expire_pending_reservations: بدل status='expired' (قيمة غير
--        موجودة بموديل Django) صار يضع status='rejected' للحجوزات المعلّقة
--        التي انتهى وقت انطلاق رحلتها (departure_date/time < NOW()).
--   3) [بلاغات] حُذف الحدث escalate_stale_reports نهائيًا (كان يكتب
--        status='needs_review' وهي قيمة غير موجودة بموديل Report).
--   4) [Triggers] حُذفت المشغّلات التي قد ترمي خطأً على مسارات الـ Backend
--        وتسبب 500: before_reservation_insert, before_reservation_update,
--        before_report_insert_duplicate_check. (before_ride_delete يبقى لعدم
--        وجود API للحذف يمرّ عبره.)
--   5) [تشفير] حُذفت كل عناصر الـ hash (أعمدة code_hash + المشغّلات
--        before_emailverification_hash / before_passwordreset_hash) لأن هذا
--        يُعالَج بالكامل على الـ Backend.
--   6) قيود CHECK بقيت كما هي جميعًا دون حذف.
--
-- ملاحظات تنفيذية:
--   - الملف idempotent (DROP IF EXISTS / فحص ديناميكي / CREATE OR REPLACE).
--   - نفّذه على Staging أولًا. القسم 3 (الأدوار) يحتاج حساب صلاحيات إدارية.
-- ============================================================================

USE `carpool_db`;


-- ############################################################################
-- # القسم 1: تصحيح ما تم تنفيذه سابقًا
-- ############################################################################

-- الجداول الثلاثة الأساسية لطبقة المراقبة
CREATE TABLE IF NOT EXISTS `audit_log` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `action_name` VARCHAR(50) NOT NULL,
    `table_name` VARCHAR(100) NOT NULL,
    `old_value` JSON DEFAULT NULL,
    `new_value` JSON DEFAULT NULL,
    `action_time` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `executed_by` VARCHAR(150) DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `activity_history` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `event_type` VARCHAR(100) NOT NULL,
    `description` TEXT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `daily_platform_summary` (
    `summary_date` DATE NOT NULL,
    `total_rides_created` INT DEFAULT 0,
    `total_reservations_made` INT DEFAULT 0,
    `total_revenue` DECIMAL(10,2) DEFAULT 0.00,
    PRIMARY KEY (`summary_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- الفهارس المركّبة الثلاثة الأصلية (فحص idempotent قبل الإنشاء)
SET @idx_exists := (
    SELECT COUNT(1) FROM information_schema.statistics
    WHERE table_schema = DATABASE() AND table_name = 'rides_ride' AND index_name = 'idx_driver_status'
);
SET @sql := IF(@idx_exists = 0,
    'CREATE INDEX `idx_driver_status` ON `rides_ride` (`driver_id`, `status`)',
    'SELECT "idx_driver_status موجود مسبقًا" AS info');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @idx_exists := (
    SELECT COUNT(1) FROM information_schema.statistics
    WHERE table_schema = DATABASE() AND table_name = 'rides_reservation' AND index_name = 'idx_rider_status'
);
SET @sql := IF(@idx_exists = 0,
    'CREATE INDEX `idx_rider_status` ON `rides_reservation` (`rider_id`, `status`)',
    'SELECT "idx_rider_status موجود مسبقًا" AS info');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @idx_exists := (
    SELECT COUNT(1) FROM information_schema.statistics
    WHERE table_schema = DATABASE() AND table_name = 'rides_reservation' AND index_name = 'idx_ride_status'
);
SET @sql := IF(@idx_exists = 0,
    'CREATE INDEX `idx_ride_status` ON `rides_reservation` (`ride_id`, `status`)',
    'SELECT "idx_ride_status موجود مسبقًا" AS info');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- الـ Views الأربعة الأصلية من data 2.sql
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
-- 1.1 حذف الـ Triggers القديمة تمهيدًا لإعادة إنشاء الصحيح منها فقط.
--     ملاحظة: before_reservation_insert / before_reservation_update لا يُعاد
--     إنشاؤهما (أُزيلا لأنهما قد يرميان خطأً على مسار الـ Backend). يبقى
--     DROP لهما هنا لضمان إزالة أي نسخة قديمة.
-- ----------------------------------------------------------------------------
DROP TRIGGER IF EXISTS `before_ride_insert_validation`;
DROP TRIGGER IF EXISTS `before_ride_update_validation`;
DROP TRIGGER IF EXISTS `before_reservation_insert`;
DROP TRIGGER IF EXISTS `before_reservation_update`;
DROP TRIGGER IF EXISTS `before_ride_delete`;
DROP TRIGGER IF EXISTS `after_ride_insert`;
DROP TRIGGER IF EXISTS `after_ride_update`;
DROP TRIGGER IF EXISTS `after_ride_delete`;
DROP TRIGGER IF EXISTS `after_reservation_insert`;
DROP TRIGGER IF EXISTS `after_reservation_update`;
DROP TRIGGER IF EXISTS `after_reservation_delete`;

-- ----------------------------------------------------------------------------
-- 1.2 إزالة القيد المكرر unique_user_ride_reservation (إن وُجد)
-- ----------------------------------------------------------------------------
SET @idx_exists := (
    SELECT COUNT(1) FROM information_schema.statistics
    WHERE table_schema = DATABASE()
      AND table_name = 'rides_reservation'
      AND index_name = 'unique_user_ride_reservation'
);
SET @sql := IF(@idx_exists > 0,
    'ALTER TABLE `rides_reservation` DROP INDEX `unique_user_ride_reservation`',
    'SELECT "unique_user_ride_reservation غير موجود، تم التخطي" AS info');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- ----------------------------------------------------------------------------
-- 1.3 فهارس ناقصة على جداول المراقبة (idempotent)
-- ----------------------------------------------------------------------------
SET @idx_exists := (
    SELECT COUNT(1) FROM information_schema.statistics
    WHERE table_schema = DATABASE() AND table_name = 'audit_log' AND index_name = 'idx_audit_table_time'
);
SET @sql := IF(@idx_exists = 0,
    'CREATE INDEX `idx_audit_table_time` ON `audit_log` (`table_name`, `action_time`)',
    'SELECT "idx_audit_table_time موجود مسبقًا" AS info');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @idx_exists := (
    SELECT COUNT(1) FROM information_schema.statistics
    WHERE table_schema = DATABASE() AND table_name = 'activity_history' AND index_name = 'idx_activity_created_at'
);
SET @sql := IF(@idx_exists = 0,
    'CREATE INDEX `idx_activity_created_at` ON `activity_history` (`created_at`)',
    'SELECT "idx_activity_created_at موجود مسبقًا" AS info');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ----------------------------------------------------------------------------
-- 1.4 قيود CHECK لمنع القيم السالبة (تبقى كما هي)
-- ----------------------------------------------------------------------------
SET @chk_exists := (
    SELECT COUNT(1) FROM information_schema.check_constraints
    WHERE constraint_schema = DATABASE() AND constraint_name = 'chk_ride_capacity'
);
SET @sql := IF(@chk_exists = 0,
    'ALTER TABLE `rides_ride` ADD CONSTRAINT `chk_ride_capacity` CHECK (`capacity` >= 0)',
    'SELECT "chk_ride_capacity موجود مسبقًا" AS info');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @chk_exists := (
    SELECT COUNT(1) FROM information_schema.check_constraints
    WHERE constraint_schema = DATABASE() AND constraint_name = 'chk_ride_cost'
);
SET @sql := IF(@chk_exists = 0,
    'ALTER TABLE `rides_ride` ADD CONSTRAINT `chk_ride_cost` CHECK (`cost` >= 0)',
    'SELECT "chk_ride_cost موجود مسبقًا" AS info');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ----------------------------------------------------------------------------
-- 1.5 إعادة إنشاء الـ Triggers (بدون مشغّلات التحقق من سعة الحجز التي كانت
--     قد ترمي خطأً على الـ Backend). تبقى مشغّلات التحقق من الرحلة والتدقيق.
-- ----------------------------------------------------------------------------
DELIMITER $$

CREATE TRIGGER `before_ride_insert_validation`
BEFORE INSERT ON `rides_ride`
FOR EACH ROW
BEGIN
    IF NEW.capacity < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Capacity cannot be negative';
    END IF;
    IF NEW.cost < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cost cannot be negative';
    END IF;
END$$

CREATE TRIGGER `before_ride_update_validation`
BEFORE UPDATE ON `rides_ride`
FOR EACH ROW
BEGIN
    IF NEW.capacity < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Capacity cannot be negative';
    END IF;
    IF NEW.cost < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cost cannot be negative';
    END IF;
END$$

CREATE TRIGGER `before_ride_delete`
BEFORE DELETE ON `rides_ride`
FOR EACH ROW
BEGIN
    DECLARE reservation_count INT;
    SELECT COUNT(*) INTO reservation_count FROM `rides_reservation`
    WHERE `ride_id` = OLD.`id` AND `status` IN ('pending', 'accepted');
    IF reservation_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete: This ride has active reservations associated with it.';
    END IF;
END$$

CREATE TRIGGER `after_ride_insert`
AFTER INSERT ON `rides_ride`
FOR EACH ROW
BEGIN
    INSERT INTO `activity_history` (`event_type`, `description`)
    VALUES ('RIDE_CREATED', CONCAT('Driver ID ', NEW.driver_id, ' created a new ride to ', NEW.destination));

    INSERT INTO `audit_log` (`action_name`, `table_name`, `old_value`, `new_value`, `executed_by`)
    VALUES ('INSERT', 'rides_ride', NULL, JSON_OBJECT('id', NEW.id, 'cost', NEW.cost, 'status', NEW.status), CURRENT_USER());
END$$

CREATE TRIGGER `after_ride_update`
AFTER UPDATE ON `rides_ride`
FOR EACH ROW
BEGIN
    INSERT INTO `audit_log` (`action_name`, `table_name`, `old_value`, `new_value`, `executed_by`)
    VALUES ('UPDATE', 'rides_ride',
        JSON_OBJECT('id', OLD.id, 'cost', OLD.cost, 'status', OLD.status),
        JSON_OBJECT('id', NEW.id, 'cost', NEW.cost, 'status', NEW.status),
        CURRENT_USER());
END$$

CREATE TRIGGER `after_ride_delete`
AFTER DELETE ON `rides_ride`
FOR EACH ROW
BEGIN
    INSERT INTO `audit_log` (`action_name`, `table_name`, `old_value`, `new_value`, `executed_by`)
    VALUES ('DELETE', 'rides_ride', JSON_OBJECT('id', OLD.id, 'cost', OLD.cost, 'status', OLD.status), NULL, CURRENT_USER());
END$$

-- تتبّع كامل لجدول الحجوزات (تدقيق فقط، بدون أي منطق يرمي خطأً)
CREATE TRIGGER `after_reservation_insert`
AFTER INSERT ON `rides_reservation`
FOR EACH ROW
BEGIN
    INSERT INTO `audit_log` (`action_name`, `table_name`, `old_value`, `new_value`, `executed_by`)
    VALUES ('INSERT', 'rides_reservation', NULL,
        JSON_OBJECT('id', NEW.id, 'ride_id', NEW.ride_id, 'rider_id', NEW.rider_id, 'status', NEW.status),
        CURRENT_USER());
END$$

CREATE TRIGGER `after_reservation_update`
AFTER UPDATE ON `rides_reservation`
FOR EACH ROW
BEGIN
    INSERT INTO `audit_log` (`action_name`, `table_name`, `old_value`, `new_value`, `executed_by`)
    VALUES ('UPDATE', 'rides_reservation',
        JSON_OBJECT('id', OLD.id, 'status', OLD.status, 'payment', OLD.payment),
        JSON_OBJECT('id', NEW.id, 'status', NEW.status, 'payment', NEW.payment),
        CURRENT_USER());
END$$

CREATE TRIGGER `after_reservation_delete`
AFTER DELETE ON `rides_reservation`
FOR EACH ROW
BEGIN
    INSERT INTO `audit_log` (`action_name`, `table_name`, `old_value`, `new_value`, `executed_by`)
    VALUES ('DELETE', 'rides_reservation',
        JSON_OBJECT('id', OLD.id, 'ride_id', OLD.ride_id, 'rider_id', OLD.rider_id, 'status', OLD.status),
        NULL, CURRENT_USER());
END$$

DELIMITER ;

-- ----------------------------------------------------------------------------
-- 1.6 تفعيل event_scheduler بشكل دائم + daily_summary_job
-- ----------------------------------------------------------------------------
SET PERSIST event_scheduler = ON;

DROP EVENT IF EXISTS `daily_summary_job`;

DELIMITER $$
CREATE EVENT `daily_summary_job`
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_DATE + INTERVAL 1 DAY
DO
BEGIN
    INSERT INTO `daily_platform_summary`
        (`summary_date`, `total_rides_created`, `total_reservations_made`, `total_revenue`)
    SELECT
        CURDATE() - INTERVAL 1 DAY,
        (SELECT COUNT(*) FROM `rides_ride`
            WHERE DATE(`created_at`) = CURDATE() - INTERVAL 1 DAY),
        (SELECT COUNT(*) FROM `rides_reservation`
            WHERE DATE(`created_at`) = CURDATE() - INTERVAL 1 DAY),
        (SELECT COALESCE(SUM(`cost`), 0.00) FROM `rides_ride`
            WHERE DATE(`created_at`) = CURDATE() - INTERVAL 1 DAY)
    ON DUPLICATE KEY UPDATE
        `total_rides_created` = VALUES(`total_rides_created`),
        `total_reservations_made` = VALUES(`total_reservations_made`),
        `total_revenue` = VALUES(`total_revenue`);
END$$
DELIMITER ;


-- ############################################################################
-- # القسم 2: التوسيع الشامل على كل الجداول
-- ############################################################################

-- ==============================================================
-- 2.1 جداول المستخدمين
-- ==============================================================

DROP TRIGGER IF EXISTS `after_mainuser_status_change`;
DROP TRIGGER IF EXISTS `before_driver_insert_carnumber`;

DELIMITER $$

CREATE TRIGGER `after_mainuser_status_change`
AFTER UPDATE ON `users_mainuser`
FOR EACH ROW
BEGIN
    IF NEW.is_active <> OLD.is_active THEN
        INSERT INTO `audit_log` (`action_name`, `table_name`, `old_value`, `new_value`, `executed_by`)
        VALUES ('STATUS_CHANGE', 'users_mainuser',
            JSON_OBJECT('id', OLD.id, 'is_active', OLD.is_active),
            JSON_OBJECT('id', NEW.id, 'is_active', NEW.is_active),
            CURRENT_USER());
    END IF;
END$$

CREATE TRIGGER `before_driver_insert_carnumber`
BEFORE INSERT ON `users_driver`
FOR EACH ROW
BEGIN
    IF NEW.car_number IS NOT NULL AND TRIM(NEW.car_number) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'car_number cannot be an empty string';
    END IF;
END$$

DELIMITER ;

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


-- ==============================================================
-- 2.2 الرحلات والحجوزات
-- ==============================================================

DROP TRIGGER IF EXISTS `before_ride_insert_date_check`;

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

-- [أتمتة] إكمال الرحلات القديمة تلقائيًا بعد انتهاء وقتها
DROP EVENT IF EXISTS `auto_complete_rides`;
DELIMITER $$
CREATE EVENT `auto_complete_rides`
ON SCHEDULE EVERY 1 HOUR
DO
BEGIN
    UPDATE `rides_ride`
    SET `status` = 'completed'
    WHERE `status` = 'active'
      AND TIMESTAMP(`departure_date`, `departure_time`) < (NOW() - INTERVAL 3 HOUR);
END$$
DELIMITER ;

-- [أتمتة] رفض الحجوزات المعلّقة التي انتهى وقت انطلاق رحلتها.
-- [تعديل] كانت تضع status='expired' (غير موجودة بموديل Django) فصارت 'rejected'،
-- وصار الفحص على وقت انطلاق الرحلة بدل مرور 6 ساعات على إنشاء الحجز.
DROP EVENT IF EXISTS `expire_pending_reservations`;
DELIMITER $$
CREATE EVENT `expire_pending_reservations`
ON SCHEDULE EVERY 1 HOUR
DO
BEGIN
    UPDATE `rides_reservation` res
    JOIN `rides_ride` r ON r.`id` = res.`ride_id`
    SET res.`status` = 'rejected'
    WHERE res.`status` = 'pending'
      AND TIMESTAMP(r.`departure_date`, r.`departure_time`) < NOW();
END$$
DELIMITER ;


-- ==============================================================
-- 2.3 طبقة المراقبة نفسها
-- ==============================================================

DROP TRIGGER IF EXISTS `prevent_audit_log_delete`;
DELIMITER $$
CREATE TRIGGER `prevent_audit_log_delete`
BEFORE DELETE ON `audit_log`
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'audit_log records cannot be deleted (immutable audit trail)';
END$$
DELIMITER ;

CREATE OR REPLACE VIEW `view_audit_activity_by_day` AS
SELECT DATE(`action_time`) AS log_date, `table_name`, COUNT(*) AS events_count
FROM `audit_log`
GROUP BY DATE(`action_time`), `table_name`;

-- [أرشفة] نقل سجلات التدقيق الأقدم من سنة إلى جدول أرشيف منفصل
CREATE TABLE IF NOT EXISTS `audit_log_archive` LIKE `audit_log`;

DROP EVENT IF EXISTS `archive_old_audit_logs`;
DELIMITER $$
CREATE EVENT `archive_old_audit_logs`
ON SCHEDULE EVERY 1 MONTH
STARTS CURRENT_DATE + INTERVAL 1 DAY
DO
BEGIN
    INSERT INTO `audit_log_archive`
    SELECT * FROM `audit_log` WHERE `action_time` < (NOW() - INTERVAL 1 YEAR);

    DELETE FROM `audit_log` WHERE `action_time` < (NOW() - INTERVAL 1 YEAR);
END$$
DELIMITER ;


-- ==============================================================
-- 2.4 المصادقة والجلسات: صيانة أمنية دورية
-- ==============================================================

DROP EVENT IF EXISTS `cleanup_expired_sessions`;
DELIMITER $$
CREATE EVENT `cleanup_expired_sessions`
ON SCHEDULE EVERY 1 HOUR
DO
    DELETE FROM `django_session` WHERE `expire_date` < NOW()$$
DELIMITER ;

DROP EVENT IF EXISTS `cleanup_expired_tokens`;
DELIMITER $$
CREATE EVENT `cleanup_expired_tokens`
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    DELETE FROM `oauth2_provider_accesstoken` WHERE `expires` < NOW();
    DELETE FROM `oauth2_provider_refreshtoken` WHERE `revoked` IS NOT NULL AND `revoked` < (NOW() - INTERVAL 30 DAY);
    DELETE FROM `oauth2_provider_grant` WHERE `expires` < NOW();
END$$
DELIMITER ;

DROP EVENT IF EXISTS `cleanup_social_auth_temp`;
DELIMITER $$
CREATE EVENT `cleanup_social_auth_temp`
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    DELETE FROM `social_auth_code` WHERE `timestamp` < (NOW() - INTERVAL 1 DAY);
    DELETE FROM `social_auth_nonce` WHERE `timestamp` < UNIX_TIMESTAMP(NOW() - INTERVAL 1 DAY);
    DELETE FROM `social_auth_partial` WHERE `timestamp` < (NOW() - INTERVAL 1 DAY);
END$$
DELIMITER ;

CREATE OR REPLACE VIEW `view_active_sessions_count` AS
SELECT COUNT(*) AS active_sessions FROM `django_session` WHERE `expire_date` > NOW();


-- ==============================================================
-- 2.5 وحدة الدفع
-- ==============================================================

SET @chk_exists := (
    SELECT COUNT(1) FROM information_schema.check_constraints
    WHERE constraint_schema = DATABASE() AND constraint_name = 'chk_transaction_amount_positive'
);
SET @sql := IF(@chk_exists = 0,
    'ALTER TABLE `payments_transaction` ADD CONSTRAINT `chk_transaction_amount_positive` CHECK (`amount` > 0)',
    'SELECT "chk_transaction_amount_positive موجود مسبقًا" AS info');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @chk_exists := (
    SELECT COUNT(1) FROM information_schema.check_constraints
    WHERE constraint_schema = DATABASE() AND constraint_name = 'chk_deposit_amount_positive'
);
SET @sql := IF(@chk_exists = 0,
    'ALTER TABLE `payments_depositrequest` ADD CONSTRAINT `chk_deposit_amount_positive` CHECK (`amount` > 0)',
    'SELECT "chk_deposit_amount_positive موجود مسبقًا" AS info');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

DROP TRIGGER IF EXISTS `before_wallet_update_no_negative`;
DROP TRIGGER IF EXISTS `prevent_transaction_amount_update`;
DROP TRIGGER IF EXISTS `after_wallet_update`;
DROP TRIGGER IF EXISTS `after_transaction_insert_audit`;

DELIMITER $$

-- منع أي عملية تُنزل رصيد المحفظة تحت الصفر
CREATE TRIGGER `before_wallet_update_no_negative`
BEFORE UPDATE ON `payments_wallet`
FOR EACH ROW
BEGIN
    IF NEW.balance < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Wallet balance cannot be negative';
    END IF;
END$$

-- جعل amount غير قابل للتعديل بعد إنشاء المعاملة
CREATE TRIGGER `prevent_transaction_amount_update`
BEFORE UPDATE ON `payments_transaction`
FOR EACH ROW
BEGIN
    IF NEW.amount <> OLD.amount THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaction amount cannot be modified after creation';
    END IF;
END$$

-- تسجيل أي تغيير برصيد المحفظة في audit_log
CREATE TRIGGER `after_wallet_update`
AFTER UPDATE ON `payments_wallet`
FOR EACH ROW
BEGIN
    IF NEW.balance <> OLD.balance THEN
        INSERT INTO `audit_log` (`action_name`, `table_name`, `old_value`, `new_value`, `executed_by`)
        VALUES ('UPDATE', 'payments_wallet',
            JSON_OBJECT('id', OLD.id, 'balance', OLD.balance),
            JSON_OBJECT('id', NEW.id, 'balance', NEW.balance),
            CURRENT_USER());
    END IF;
END$$

-- تسجيل كل معاملة مالية جديدة
CREATE TRIGGER `after_transaction_insert_audit`
AFTER INSERT ON `payments_transaction`
FOR EACH ROW
BEGIN
    INSERT INTO `audit_log` (`action_name`, `table_name`, `old_value`, `new_value`, `executed_by`)
    VALUES ('INSERT', 'payments_transaction', NULL,
        JSON_OBJECT('id', NEW.id, 'amount', NEW.amount, 'transaction_type', NEW.transaction_type, 'wallet_id', NEW.wallet_id),
        CURRENT_USER());
END$$

DELIMITER ;

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

-- [أتمتة] مطابقة أسبوعية بين مجموع المعاملات ورصيد كل محفظة
DROP EVENT IF EXISTS `weekly_wallet_reconciliation`;
DELIMITER $$
CREATE EVENT `weekly_wallet_reconciliation`
ON SCHEDULE EVERY 1 WEEK
DO
BEGIN
    INSERT INTO `audit_log` (`action_name`, `table_name`, `old_value`, `new_value`, `executed_by`)
    SELECT
        'RECONCILIATION_MISMATCH',
        'payments_wallet',
        NULL,
        JSON_OBJECT(
            'wallet_id', w.`id`,
            'current_balance', w.`balance`,
            'computed_balance',
                COALESCE(SUM(CASE WHEN t.`transaction_type` = 'deposit' THEN t.`amount` ELSE -t.`amount` END), 0)
        ),
        'system_event'
    FROM `payments_wallet` w
    LEFT JOIN `payments_transaction` t ON t.`wallet_id` = w.`id`
    GROUP BY w.`id`, w.`balance`
    HAVING w.`balance` <> COALESCE(SUM(CASE WHEN t.`transaction_type` = 'deposit' THEN t.`amount` ELSE -t.`amount` END), 0);
END$$
DELIMITER ;


-- ==============================================================
-- 2.6 وحدة البلاغات
-- ==============================================================
-- [حذف] before_report_insert_duplicate_check أُزيل (كان قد يرمي خطأً على
--       مسار إنشاء البلاغ ويسبب 500). يبقى DROP لإزالة أي نسخة قديمة.
DROP TRIGGER IF EXISTS `before_report_insert_duplicate_check`;

CREATE OR REPLACE VIEW `view_most_reported_users` AS
SELECT `reported_user_id`, COUNT(*) AS reports_count
FROM `reports_report`
GROUP BY `reported_user_id`
ORDER BY reports_count DESC;

-- [حذف] الحدث escalate_stale_reports أُزيل نهائيًا (كان يكتب
--       status='needs_review' وهي قيمة غير موجودة بموديل Report).
DROP EVENT IF EXISTS `escalate_stale_reports`;


-- ==============================================================
-- 2.7 الموقع الجغرافي
-- ==============================================================

SET @chk_exists := (
    SELECT COUNT(1) FROM information_schema.check_constraints
    WHERE constraint_schema = DATABASE() AND constraint_name = 'chk_current_lat_range'
);
SET @sql := IF(@chk_exists = 0,
    'ALTER TABLE `locations_currentlocation` ADD CONSTRAINT `chk_current_lat_range` CHECK (`latitude` BETWEEN -90 AND 90)',
    'SELECT "chk_current_lat_range موجود مسبقًا" AS info');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @chk_exists := (
    SELECT COUNT(1) FROM information_schema.check_constraints
    WHERE constraint_schema = DATABASE() AND constraint_name = 'chk_current_lng_range'
);
SET @sql := IF(@chk_exists = 0,
    'ALTER TABLE `locations_currentlocation` ADD CONSTRAINT `chk_current_lng_range` CHECK (`longitude` BETWEEN -180 AND 180)',
    'SELECT "chk_current_lng_range موجود مسبقًا" AS info');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @chk_exists := (
    SELECT COUNT(1) FROM information_schema.check_constraints
    WHERE constraint_schema = DATABASE() AND constraint_name = 'chk_point_lat_range'
);
SET @sql := IF(@chk_exists = 0,
    'ALTER TABLE `locations_locationpoint` ADD CONSTRAINT `chk_point_lat_range` CHECK (`latitude` BETWEEN -90 AND 90)',
    'SELECT "chk_point_lat_range موجود مسبقًا" AS info');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @chk_exists := (
    SELECT COUNT(1) FROM information_schema.check_constraints
    WHERE constraint_schema = DATABASE() AND constraint_name = 'chk_point_lng_range'
);
SET @sql := IF(@chk_exists = 0,
    'ALTER TABLE `locations_locationpoint` ADD CONSTRAINT `chk_point_lng_range` CHECK (`longitude` BETWEEN -180 AND 180)',
    'SELECT "chk_point_lng_range موجود مسبقًا" AS info');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

CREATE OR REPLACE VIEW `view_last_known_location` AS
SELECT `user_id`, `latitude`, `longitude`, `updated_at`
FROM `locations_currentlocation`;

-- [أرشفة/خصوصية] حذف نقاط الموقع التفصيلية الأقدم من 30 يوم
DROP EVENT IF EXISTS `cleanup_old_location_points`;
DELIMITER $$
CREATE EVENT `cleanup_old_location_points`
ON SCHEDULE EVERY 1 DAY
DO
    DELETE FROM `locations_locationpoint` WHERE `recorded_at` < (NOW() - INTERVAL 30 DAY)$$
DELIMITER ;

CREATE OR REPLACE VIEW `view_location_data_footprint` AS
SELECT `user_id`, COUNT(*) AS stored_points, MIN(`recorded_at`) AS earliest, MAX(`recorded_at`) AS latest
FROM `locations_locationpoint`
GROUP BY `user_id`;


-- ==============================================================
-- 2.8 رموز التحقق
-- ==============================================================
-- [حذف] أُزيلت كل عناصر الـ hash (أعمدة code_hash والمشغّلات
--       before_emailverification_hash / before_passwordreset_hash) لأن
--       التشفير/التجزئة يُعالَج بالكامل على الـ Backend.
DROP TRIGGER IF EXISTS `before_emailverification_hash`;
DROP TRIGGER IF EXISTS `before_passwordreset_hash`;
DROP TRIGGER IF EXISTS `before_passwordreset_prevent_reuse`;

DELIMITER $$

-- منع إعادة استخدام رمز إعادة تعيين تم التحقق منه مسبقًا
CREATE TRIGGER `before_passwordreset_prevent_reuse`
BEFORE UPDATE ON `users_passwordresetcode`
FOR EACH ROW
BEGIN
    IF OLD.is_verified = 1 AND NEW.is_verified = 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'This reset code has already been used';
    END IF;
END$$

DELIMITER ;

-- [أتمتة أمنية] حذف الرموز منتهية الصلاحية كل ساعة
DROP EVENT IF EXISTS `cleanup_expired_verification_codes`;
DELIMITER $$
CREATE EVENT `cleanup_expired_verification_codes`
ON SCHEDULE EVERY 1 HOUR
DO
BEGIN
    DELETE FROM `users_emailverification` WHERE `expires_at` < NOW();
    DELETE FROM `users_passwordresetcode` WHERE `expires_at` < NOW() OR `is_verified` = 1;
END$$
DELIMITER ;


-- ==============================================================
-- 2.9 View شاملة للوحة تحكم إدارية
-- ==============================================================

CREATE OR REPLACE VIEW `view_admin_dashboard_summary` AS
SELECT
    (SELECT COUNT(*) FROM `users_mainuser` WHERE `is_active` = 1) AS active_users,
    (SELECT COUNT(*) FROM `rides_ride` WHERE `status` = 'active') AS active_rides,
    (SELECT COUNT(*) FROM `reports_report` WHERE `status` = 'pending') AS open_reports,
    (SELECT COALESCE(SUM(`balance`), 0) FROM `payments_wallet`) AS total_wallet_balance,
    (SELECT COALESCE(SUM(`total_revenue`), 0) FROM `daily_platform_summary`
        WHERE `summary_date` >= CURDATE() - INTERVAL 30 DAY) AS revenue_last_30_days;


-- ############################################################################
-- # القسم 3: الحماية والصلاحيات
-- ############################################################################

-- ----------------------------------------------------------------------------
-- 3.1 صلاحيات منفصلة على مستوى قاعدة البيانات (Role-Based Access)
--     نفّذ هذا الجزء بحساب له صلاحية CREATE USER/GRANT/CREATE ROLE.
-- ----------------------------------------------------------------------------

DROP ROLE IF EXISTS 'app_readwrite', 'app_readonly', 'admin_full';
CREATE ROLE 'app_readwrite', 'app_readonly', 'admin_full';

-- ---- app_readonly: قراءة كاملة على القاعدة ----
GRANT SELECT ON `carpool_db`.* TO 'app_readonly';

-- ---- admin_full: وصول كامل ----
GRANT ALL PRIVILEGES ON `carpool_db`.* TO 'admin_full';

-- ---- app_readwrite: حساب التطبيق الفعلي — مضبوط جدول بجدول ----

-- الجداول التشغيلية العادية: قراءة وكتابة كاملة
GRANT SELECT, INSERT, UPDATE, DELETE ON `carpool_db`.`rides_ride`                TO 'app_readwrite';
GRANT SELECT, INSERT, UPDATE, DELETE ON `carpool_db`.`rides_reservation`         TO 'app_readwrite';
GRANT SELECT, INSERT, UPDATE, DELETE ON `carpool_db`.`users_mainuser`            TO 'app_readwrite';
GRANT SELECT, INSERT, UPDATE, DELETE ON `carpool_db`.`users_driver`              TO 'app_readwrite';
GRANT SELECT, INSERT, UPDATE, DELETE ON `carpool_db`.`users_rider`               TO 'app_readwrite';
GRANT SELECT, INSERT, UPDATE, DELETE ON `carpool_db`.`users_appadmin`            TO 'app_readwrite';
GRANT SELECT, INSERT, UPDATE, DELETE ON `carpool_db`.`reports_report`            TO 'app_readwrite';
GRANT SELECT, INSERT, UPDATE, DELETE ON `carpool_db`.`locations_currentlocation` TO 'app_readwrite';
GRANT SELECT, INSERT, UPDATE, DELETE ON `carpool_db`.`locations_locationpoint`   TO 'app_readwrite';
GRANT SELECT, INSERT, UPDATE, DELETE ON `carpool_db`.`users_emailverification`   TO 'app_readwrite';
GRANT SELECT, INSERT, UPDATE, DELETE ON `carpool_db`.`users_passwordresetcode`   TO 'app_readwrite';

-- ---- جداول Django/OAuth/social-auth الحرجة وقت التشغيل: CRUD كامل ----
GRANT SELECT, INSERT, UPDATE, DELETE ON `carpool_db`.`django_session`                  TO 'app_readwrite';
GRANT SELECT, INSERT, UPDATE, DELETE ON `carpool_db`.`oauth2_provider_accesstoken`     TO 'app_readwrite';
GRANT SELECT, INSERT, UPDATE, DELETE ON `carpool_db`.`oauth2_provider_refreshtoken`    TO 'app_readwrite';
GRANT SELECT, INSERT, UPDATE, DELETE ON `carpool_db`.`oauth2_provider_grant`           TO 'app_readwrite';
GRANT SELECT, INSERT, UPDATE, DELETE ON `carpool_db`.`oauth2_provider_idtoken`         TO 'app_readwrite';
GRANT SELECT, INSERT, UPDATE, DELETE ON `carpool_db`.`social_auth_usersocialauth`      TO 'app_readwrite';
GRANT SELECT, INSERT, UPDATE, DELETE ON `carpool_db`.`social_auth_association`         TO 'app_readwrite';
GRANT SELECT, INSERT, UPDATE, DELETE ON `carpool_db`.`social_auth_code`                TO 'app_readwrite';
GRANT SELECT, INSERT, UPDATE, DELETE ON `carpool_db`.`social_auth_nonce`               TO 'app_readwrite';
GRANT SELECT, INSERT, UPDATE, DELETE ON `carpool_db`.`social_auth_partial`             TO 'app_readwrite';
GRANT SELECT, INSERT, UPDATE, DELETE ON `carpool_db`.`users_mainuser_groups`           TO 'app_readwrite';
GRANT SELECT, INSERT, UPDATE, DELETE ON `carpool_db`.`users_mainuser_user_permissions` TO 'app_readwrite';

-- ---- جداول إعدادات ثابتة يديرها الأدمن/المايجريشن فقط: قراءة فقط ----
GRANT SELECT ON `carpool_db`.`auth_group`                  TO 'app_readwrite';
GRANT SELECT ON `carpool_db`.`auth_permission`             TO 'app_readwrite';
GRANT SELECT ON `carpool_db`.`auth_group_permissions`      TO 'app_readwrite';
GRANT SELECT ON `carpool_db`.`django_content_type`         TO 'app_readwrite';
GRANT SELECT ON `carpool_db`.`oauth2_provider_application` TO 'app_readwrite';

-- ---- وحدة الدفع ----
-- [تعديل] الـ Backend يعدّل رصيد المحفظة مباشرةً (F("balance") ± المبلغ) في
--         مسارات الدفع/الاسترجاع/أرباح السائق/قبول الإيداع، لذلك مُنح UPDATE
--         على payments_wallet. (sp_adjust_wallet_balance يبقى متاحًا كخيار
--         أكثر أمانًا إن رغبتم بتحويل تلك المسارات إليه لاحقًا.)
GRANT SELECT, INSERT, UPDATE ON `carpool_db`.`payments_wallet`         TO 'app_readwrite';
-- [تعديل] قبول/رفض طلب الإيداع يعدّل حقل status، لذلك أُضيف UPDATE.
GRANT SELECT, INSERT, UPDATE ON `carpool_db`.`payments_depositrequest` TO 'app_readwrite';
-- المعاملات: قراءة وإدخال فقط (لا يعدّلها الـ Backend أبدًا).
GRANT SELECT, INSERT         ON `carpool_db`.`payments_transaction`    TO 'app_readwrite';

-- ---- قراءة الـ Views وجدول الملخص اليومي (لوحة التحكم الإدارية) ----
-- الـ Views تعمل بصلاحية مُنشئها (DEFINER) لذا يكفي منح SELECT على كائن الـ
-- View نفسه، دون الحاجة لمنح وصول مباشر على audit_log/activity_history.
GRANT SELECT ON `carpool_db`.`daily_platform_summary`         TO 'app_readwrite';
GRANT SELECT ON `carpool_db`.`view_driver_trips_count`        TO 'app_readwrite';
GRANT SELECT ON `carpool_db`.`view_most_active_riders`        TO 'app_readwrite';
GRANT SELECT ON `carpool_db`.`view_popular_destinations`      TO 'app_readwrite';
GRANT SELECT ON `carpool_db`.`view_popular_pickup_locations`  TO 'app_readwrite';
GRANT SELECT ON `carpool_db`.`view_ride_occupancy_rate`       TO 'app_readwrite';
GRANT SELECT ON `carpool_db`.`view_user_role_summary`         TO 'app_readwrite';
GRANT SELECT ON `carpool_db`.`view_inactive_users`            TO 'app_readwrite';
GRANT SELECT ON `carpool_db`.`view_active_sessions_count`     TO 'app_readwrite';
GRANT SELECT ON `carpool_db`.`view_most_reported_users`       TO 'app_readwrite';
GRANT SELECT ON `carpool_db`.`view_location_data_footprint`   TO 'app_readwrite';
GRANT SELECT ON `carpool_db`.`view_last_known_location`       TO 'app_readwrite';
GRANT SELECT ON `carpool_db`.`view_wallet_summary`            TO 'app_readwrite';
GRANT SELECT ON `carpool_db`.`view_suspicious_deposits`       TO 'app_readwrite';
GRANT SELECT ON `carpool_db`.`view_audit_activity_by_day`     TO 'app_readwrite';
GRANT SELECT ON `carpool_db`.`view_admin_dashboard_summary`   TO 'app_readwrite';

-- طبقة المراقبة (audit_log / activity_history): بدون أي منح مباشر.
-- الـ Triggers تكتب فيها بصلاحيات مُنشئها (DEFINER)، وقراءتها من لوحة التحكم
-- تتم عبر الـ Views أعلاه، لذا يبقى الجدولان محميين من أي وصول مباشر.

FLUSH PRIVILEGES;

-- مثال لإنشاء حساب تطبيق فعلي وربطه بالدور:
-- CREATE USER IF NOT EXISTS 'carpool_app'@'%' IDENTIFIED BY 'REPLACE_WITH_STRONG_PASSWORD';
-- GRANT 'app_readwrite' TO 'carpool_app'@'%';
-- SET DEFAULT ROLE 'app_readwrite' TO 'carpool_app'@'%';


-- ----------------------------------------------------------------------------
-- 3.1.b إجراء مخزّن اختياري لتعديل رصيد المحفظة بأمان (منطق تحقق داخلي)
--        متاح كبديل أكثر أمانًا للتعديل المباشر إن رغبتم باعتماده لاحقًا.
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_adjust_wallet_balance`;
DELIMITER $$
CREATE DEFINER = CURRENT_USER
PROCEDURE `sp_adjust_wallet_balance` (
    IN p_wallet_id BIGINT,
    IN p_amount DECIMAL(10,2),
    IN p_direction ENUM('credit','debit')
)
SQL SECURITY DEFINER
BEGIN
    DECLARE v_current_balance DECIMAL(10,2);

    IF p_amount <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Amount must be positive';
    END IF;

    SELECT `balance` INTO v_current_balance
    FROM `payments_wallet` WHERE `id` = p_wallet_id FOR UPDATE;

    IF p_direction = 'debit' AND v_current_balance < p_amount THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient balance';
    END IF;

    UPDATE `payments_wallet`
    SET `balance` = `balance` + IF(p_direction = 'credit', p_amount, -p_amount)
    WHERE `id` = p_wallet_id;
END$$
DELIMITER ;

GRANT EXECUTE ON PROCEDURE `carpool_db`.`sp_adjust_wallet_balance` TO 'app_readwrite';


-- ----------------------------------------------------------------------------
-- 3.4 تدقيق دوري: فحص شهري للتأكد من عدم وجود أرصدة سالبة
-- ----------------------------------------------------------------------------
DROP EVENT IF EXISTS `monthly_integrity_audit`;
DELIMITER $$
CREATE EVENT `monthly_integrity_audit`
ON SCHEDULE EVERY 1 MONTH
DO
BEGIN
    INSERT INTO `audit_log` (`action_name`, `table_name`, `old_value`, `new_value`, `executed_by`)
    SELECT 'INTEGRITY_ALERT', 'payments_wallet', NULL,
        JSON_OBJECT('wallet_id', `id`, 'balance', `balance`), 'system_event'
    FROM `payments_wallet`
    WHERE `balance` < 0;
END$$
DELIMITER ;


-- ============================================================================
-- نهاية الملف
-- ============================================================================
