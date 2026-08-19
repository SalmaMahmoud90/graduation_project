-- ============================================================================
-- ملف: events.sql
-- الغرض: تفعيل event_scheduler وكل الأحداث المجدولة (صيانة/أتمتة/أرشفة).
--        مُستخرَج من data_3_full_expansion_3_revised.sql.
-- ملاحظة: يعتمد على الجداول (00_tables.sql). SET PERSIST يتطلب صلاحية
--         SUPER/SYSTEM_VARIABLES_ADMIN.
-- ============================================================================

USE `carpool_db`;

-- تفعيل event_scheduler بشكل دائم
SET PERSIST event_scheduler = ON;

-- ----------------------------------------------------------------------------
-- ملخّص يومي للمنصّة
-- ----------------------------------------------------------------------------
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

-- ----------------------------------------------------------------------------
-- الرحلات والحجوزات: أتمتة الحالة
-- ----------------------------------------------------------------------------
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
      AND TIMESTAMP(`departure_date`, `departure_time`) < (NOW() - INTERVAL 36 HOUR);
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

-- ----------------------------------------------------------------------------
-- طبقة المراقبة: أرشفة سجلات التدقيق الأقدم من سنة
-- ----------------------------------------------------------------------------
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

-- ----------------------------------------------------------------------------
-- المصادقة والجلسات: صيانة أمنية دورية
-- ----------------------------------------------------------------------------
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

-- ----------------------------------------------------------------------------
-- وحدة الدفع: مطابقة أسبوعية بين مجموع المعاملات ورصيد كل محفظة
-- ----------------------------------------------------------------------------
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

-- ----------------------------------------------------------------------------
-- وحدة البلاغات: إزالة حدث قديم (لا يُعاد إنشاؤه)
--   escalate_stale_reports أُزيل نهائيًا (كان يكتب status='needs_review'
--   وهي قيمة غير موجودة بموديل Report).
-- ----------------------------------------------------------------------------
DROP EVENT IF EXISTS `escalate_stale_reports`;

-- ----------------------------------------------------------------------------
-- الموقع الجغرافي: حذف نقاط الموقع التفصيلية الأقدم من 30 يوم
-- ----------------------------------------------------------------------------
DROP EVENT IF EXISTS `cleanup_old_location_points`;
DELIMITER $$
CREATE EVENT `cleanup_old_location_points`
ON SCHEDULE EVERY 1 DAY
DO
    DELETE FROM `locations_locationpoint` WHERE `recorded_at` < (NOW() - INTERVAL 30 DAY)$$
DELIMITER ;

-- ----------------------------------------------------------------------------
-- رموز التحقق: حذف الرموز منتهية الصلاحية كل ساعة
-- ----------------------------------------------------------------------------
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

-- ----------------------------------------------------------------------------
-- تدقيق دوري: فحص شهري للتأكد من عدم وجود أرصدة سالبة
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
