-- ============================================================================
-- ملف: indexes.sql
-- الغرض: إنشاء الفهارس المركّبة/المساعدة، وإزالة القيد المكرر.
--        مُستخرَج من data_3_full_expansion_3_revised.sql.
-- ملاحظة: كل فهرس يُفحَص ديناميكيًا (idempotent) قبل إنشائه.
-- ============================================================================

USE `carpool_db`;

-- ----------------------------------------------------------------------------
-- الفهارس المركّبة الثلاثة الأصلية (رحلات/حجوزات)
-- ----------------------------------------------------------------------------
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

-- ----------------------------------------------------------------------------
-- إزالة القيد المكرر unique_user_ride_reservation (إن وُجد)
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
-- فهارس ناقصة على جداول المراقبة
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
