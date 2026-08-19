-- ============================================================================
-- ملف: 00_tables.sql
-- الغرض: الجداول المساعدة (طبقة المراقبة) التي يعتمد عليها بقية السكربتات.
--        مُستخرَج من data_3_full_expansion_3_revised.sql.
-- ملاحظة: يجب تنفيذ هذا الملف أولًا لأن الـ Triggers والـ Views والـ Events
--         تعتمد على هذه الجداول (audit_log / activity_history / ...).
-- ============================================================================

USE `carpool_db`;

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

-- [أرشفة] جدول أرشيف سجلات التدقيق (يستخدمه الحدث archive_old_audit_logs)
CREATE TABLE IF NOT EXISTS `audit_log_archive` LIKE `audit_log`;
