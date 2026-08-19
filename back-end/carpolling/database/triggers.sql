-- ============================================================================
-- ملف: triggers.sql
-- الغرض: كل الـ Triggers (تحقق + تدقيق/audit).
--        مُستخرَج من data_3_full_expansion_3_revised.sql.
-- ملاحظة: يعتمد على جداول المراقبة (audit_log / activity_history) — نفّذ
--         00_tables.sql أولًا.
-- تنبيه: بعض المشغّلات القديمة تُحذف عمدًا ولا يُعاد إنشاؤها (راجع التعليقات).
-- ============================================================================

USE `carpool_db`;

-- ----------------------------------------------------------------------------
-- حذف الـ Triggers القديمة تمهيدًا لإعادة إنشاء الصحيح منها فقط.
--   before_reservation_insert / before_reservation_update لا يُعاد إنشاؤهما
--   (أُزيلا لأنهما قد يرميان خطأً على مسار الـ Backend). يبقى DROP لضمان الإزالة.
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
-- إعادة إنشاء الـ Triggers للرحلات والحجوزات (بدون مشغّلات التحقق من سعة الحجز
-- التي كانت قد ترمي خطأً على الـ Backend). تبقى مشغّلات التحقق من الرحلة والتدقيق.
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
-- جداول المستخدمين
-- ----------------------------------------------------------------------------
DROP TRIGGER IF EXISTS `after_mainuser_status_change`;
DROP TRIGGER IF EXISTS `before_driver_insert_carnumber`;

DELIMITER $$

CREATE TRIGGER `after_mainuser_status_change`
AFTER UPDATE ON `users_mainuser`
FOR EACH ROW
BEGINCREATE ROLE 'app_readwrite', 'app_readonly', 'admin_full';

    IF NEW.is_active <> OLD.is_active THEN
        INSERT INTO `audit_log` (`action_name`, `table_name`, `old_value`, `new_value`, `executed_by`)
        VALUES ('STATUS_CHANGE', 'users_mainuser',
            JSON_OBJECT('id', OLD.id, 'is_active', OLD.is_active),
            JSON_OBJECT('id', NEW.id, 'is_active', NEW.is_active),
            CURRENT_USER());
    END IF;
END$$

DELIMITER ;

-- ----------------------------------------------------------------------------
-- الرحلات والحجوزات: إزالة مشغّل قديم (لا يُعاد إنشاؤه)
-- ----------------------------------------------------------------------------
DROP TRIGGER IF EXISTS `before_ride_insert_date_check`;

-- ----------------------------------------------------------------------------
-- طبقة المراقبة نفسها: جعل audit_log غير قابل للحذف
-- ----------------------------------------------------------------------------
DROP TRIGGER IF EXISTS `prevent_audit_log_delete`;
DELIMITER $$
CREATE TRIGGER `prevent_audit_log_delete`
BEFORE DELETE ON `audit_log`
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'audit_log records cannot be deleted (immutable audit trail)';
END$$
DELIMITER ;

-- ----------------------------------------------------------------------------
-- وحدة الدفع
-- ----------------------------------------------------------------------------
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

-- ----------------------------------------------------------------------------
-- وحدة البلاغات: إزالة مشغّل قديم (لا يُعاد إنشاؤه)
--   before_report_insert_duplicate_check أُزيل (كان قد يرمي خطأً على مسار
--   إنشاء البلاغ ويسبب 500). يبقى DROP لإزالة أي نسخة قديمة.
-- ----------------------------------------------------------------------------
DROP TRIGGER IF EXISTS `before_report_insert_duplicate_check`;

-- ----------------------------------------------------------------------------
-- رموز التحقق
--   أُزيلت كل عناصر الـ hash (before_emailverification_hash /
--   before_passwordreset_hash) لأن التشفير/التجزئة يُعالَج بالكامل على الـ Backend.
-- ----------------------------------------------------------------------------
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
