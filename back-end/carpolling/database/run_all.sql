-- ============================================================================
-- ملف: run_all.sql
-- الغرض: تشغيل السكربتات المُقسّمة بالترتيب الصحيح للاعتماديات.
--        بديل مطابق لـ data_3_full_expansion_3_revised.sql بعد تقسيمه.
--
-- الاستخدام:
--   mysql -u root -p carpool_db < run_all.sql
--   (يجب تشغيله من داخل مجلد database/ لأن مسارات SOURCE نسبية)
--
-- ترتيب التنفيذ (مهم — الاعتماديات):
--   1) 00_tables.sql  : جداول المراقبة (يعتمد عليها الباقي)
--   2) checks.sql     : قيود CHECK
--   3) indexes.sql    : الفهارس
--   4) views.sql      : الـ Views (يشير إليها permissions.sql)
--   5) triggers.sql   : المشغّلات (تكتب في جداول المراقبة)
--   6) events.sql     : الأحداث المجدولة
--   7) permissions.sql: الأدوار/الصلاحيات + الإجراء المخزّن
-- ============================================================================

USE `carpool_db`;

SOURCE 00_tables.sql;
SOURCE checks.sql;
SOURCE indexes.sql;
SOURCE views.sql;
SOURCE triggers.sql;
SOURCE events.sql;
SOURCE permissions.sql;
