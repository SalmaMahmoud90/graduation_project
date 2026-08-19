-- ============================================================================
-- ملف: checks.sql
-- الغرض: قيود CHECK لمنع القيم غير الصالحة (سالبة/خارج النطاق).
--        مُستخرَج من data_3_full_expansion_3_revised.sql.
-- ملاحظة: كل قيد يُفحَص ديناميكيًا (idempotent) قبل إضافته.
-- ============================================================================

USE `carpool_db`;

-- ----------------------------------------------------------------------------
-- الرحلات: منع السعة/التكلفة السالبة
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
-- وحدة الدفع: منع المبالغ غير الموجبة
-- ----------------------------------------------------------------------------
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

-- ----------------------------------------------------------------------------
-- الموقع الجغرافي: منع الإحداثيات خارج النطاق
-- ----------------------------------------------------------------------------
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
