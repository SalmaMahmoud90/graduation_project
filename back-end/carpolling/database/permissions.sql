-- ============================================================================
-- ملف: permissions.sql
-- الغرض: الأدوار والصلاحيات (Role-Based Access) + الإجراء المخزّن الاختياري
--        لتعديل رصيد المحفظة بأمان.
--        مُستخرَج من data_3_full_expansion_3_revised.sql.
-- ملاحظة: نفّذ هذا الملف بحساب له صلاحية CREATE USER/GRANT/CREATE ROLE، وبعد
--         إنشاء الـ Views (views.sql) لأن الـ GRANT يشير إليها.
-- ============================================================================

USE `carpool_db`;

-- ----------------------------------------------------------------------------
-- 3.1 صلاحيات منفصلة على مستوى قاعدة البيانات (Role-Based Access)
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
