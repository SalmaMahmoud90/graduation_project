# ملخص عناصر قاعدة البيانات `carpool_db` (النسخة المُعدّلة المطابقة للـ Backend)

إليك ملخص شامل ومُنسّق لكافة العناصر والأعمال التي تمّ تطبيقها على قاعدة البيانات
`carpool_db`، مُقسّمة ومجمّعة حسب كل فئة ووظيفتها البرمجية. هذه النسخة مُطابقة لكود
الـ Backend (Django) بعد إزالة التعارضات معه.

> **أبرز ما جرى تعديله لإزالة التعارض مع الـ Backend:** مُنحت صلاحيات
> `app_readwrite` كل ما يحتاجه التطبيق فعليًا (`UPDATE` على المحفظة وطلبات
> الإيداع، وقراءة الـ Views وجدول الملخص اليومي)؛ صار الحدث
> `expire_pending_reservations` يضع الحالة `rejected` بدل `expired` بناءً على
> انتهاء وقت انطلاق الرحلة؛ وحُذف الحدث `escalate_stale_reports` والمشغّلات التي
> قد ترمي خطأً على مسار التطبيق (`before_reservation_insert/update`،
> `before_report_insert_duplicate_check`) وكل عناصر التجزئة (hash).

---

## بنية الملفات بعد التقسيم

قُسّم الملف الأصلي `data_3_full_expansion_3_revised.sql` إلى ملفات مُركّزة حسب نوع
الكائن، ويمكن تنفيذها دفعةً واحدة عبر `run_all.sql` بالترتيب الصحيح للاعتماديات.

| الملف | المحتوى | يجب تنفيذه |
| --- | --- | --- |
| `00_tables.sql` | جداول طبقة المراقبة (`audit_log`، `activity_history`، `daily_platform_summary`، `audit_log_archive`) | أولًا (يعتمد عليه الباقي) |
| `checks.sql` | قيود `CHECK` لمنع القيم غير الصالحة | بعد الجداول |
| `indexes.sql` | الفهارس المركّبة/المساعدة + إزالة قيد مكرر | بعد الجداول |
| `views.sql` | كل الـ Views (تقارير/لوحة تحكم) | قبل الصلاحيات |
| `triggers.sql` | كل المشغّلات (تحقق + تدقيق) | بعد الجداول |
| `events.sql` | الأحداث المجدولة + تفعيل `event_scheduler` | بعد الجداول |
| `permissions.sql` | الأدوار والصلاحيات (RBAC) + الإجراء المخزّن | بعد الـ Views |
| `run_all.sql` | يشغّل كل ما سبق بالترتيب الصحيح | — |

**طريقة التشغيل:** من داخل مجلد `database/`:
```bash
mysql -u root -p carpool_db < run_all.sql
```

---

## ١. مشغّلات القواعد والمشغّلات الشرطية (Triggers) — `triggers.sql`

### • التحقق وقواعد العمل (Business Validation)
- **`before_ride_insert_validation`** و **`before_ride_update_validation`**: يمنعان
  إدخال أو تعديل سعة الرحلة أو تكلفتها بقيمٍ سالبة.
- **`before_ride_delete`**: يمنع حذف أي رحلة تمتلك حجوزات قيد الانتظار أو معتمدة
  (`pending`/`accepted`). يبقى للحماية إذ لا يوجد API للحذف يمرّ عبره.
- **`before_driver_insert_carnumber`**: يمنع إدخال لوحة سيارة فارغة للسائقين.

### • الأمان والحماية المالية (Security & Financial Integrity)
- **`before_wallet_update_no_negative`**: يمنع انخفاض رصيد المحفظة المالية عن الصفر.
- **`prevent_transaction_amount_update`**: يمنع تعديل قيمة المعاملة المالية بعد
  إنشائها لضمان ثبات السجلات.
- **`prevent_audit_log_delete`**: يمنع حذف أي سجل من جدول المراقبة (`audit_log`)
  لضمان عدم التلاعب بالسجلات.
- **`before_passwordreset_prevent_reuse`**: يمنع إعادة استخدام رمز إعادة تعيين كلمة
  السر بعد التحقق منه.

### • التتبّع والتدقيق (History & Auditing)
- **`after_ride_insert`** / **`after_ride_update`** / **`after_ride_delete`**:
  تسجّل عمليات الإنشاء والتعديل والحذف للرحلات في جدول التدقيق `audit_log` وجدول
  النشاطات `activity_history`.
- **`after_reservation_insert`** / **`after_reservation_update`** /
  **`after_reservation_delete`**: تسجّل كافة التغييرات والحركات الخاصة بالحجوزات في
  `audit_log`.
- **`after_mainuser_status_change`**: يسجّل تغييرات حالة تفعيل أو تعطيل حسابات
  المستخدمين أمنيًا.
- **`after_transaction_insert_audit`** و **`after_wallet_update`**: يسجّلان أي
  تغيير برصيد المحفظة والمعاملات المالية الجديدة في جدول التدقيق.

> **مشغّلات أُزيلت عمدًا ولا يُعاد إنشاؤها** (يبقى `DROP` لإزالة أي نسخة قديمة):
> `before_reservation_insert`، `before_reservation_update`،
> `before_ride_insert_date_check`، `before_report_insert_duplicate_check`،
> `before_emailverification_hash`، `before_passwordreset_hash` — لأنها قد ترمي
> خطأً على مسار الـ Backend أو لأن التجزئة تُعالَج بالكامل في التطبيق.

---

## ٢. العروض والمشاهد البرمجية (Views) — `views.sql`

### • التحليلات التشغيلية وتقارير الرحلات
- **`view_driver_trips_count`**: تُظهر عدد الرحلات الكلي لكل سائق مع بريده الإلكتروني.
- **`view_most_active_riders`**: تُظهر الركاب الأكثر نشاطًا وإجمالي حجوزاتهم.
- **`view_popular_destinations`**: تُظهر الوجهات الأكثر تكرارًا وطلبًا.
- **`view_popular_pickup_locations`**: تُظهر نقاط الانطلاق والالتقاط الأكثر استخدامًا
  من قبل الطلاب.
- **`view_ride_occupancy_rate`**: تحسب نسبة إشغال الحجوزات المقبولة مقارنةً بالسعة
  الكلية لكل رحلة.

### • المستخدمون والأمان والحسابات
- **`view_user_role_summary`**: ملخص لإحصائيات أعداد المستخدمين النشطين وغير النشطين
  حسب أدوارهم.
- **`view_inactive_users`**: تعرض قائمة الحسابات الخاملة (التي لم تسجّل دخول منذ أكثر
  من ٩٠ يومًا).
- **`view_active_sessions_count`**: تعرض عدد الجلسات النشطة حاليًا في النظام.
- **`view_most_reported_users`**: تُظهر المستخدمين الأكثر بلاغًا لترتيبهم حسب شدة
  الشكاوى.
- **`view_location_data_footprint`** و **`view_last_known_location`**: تُظهران آخر
  موقع جغرافي معروف للمستخدم ومساحة البيانات الجغرافية المخزّنة له.

### • المالية والمراقبة الإدارية
- **`view_wallet_summary`**: تُظهر إجمالي الإيداعات والمبالغ المصروفة ورصيد كل محفظة.
- **`view_suspicious_deposits`**: تكشف طلبات الإيداع المشبوهة (أكثر من ٣ طلبات لنفس
  المستخدم خلال ساعة).
- **`view_audit_activity_by_day`**: ملخص يومي لعدد أحداث المراقبة والعمليات المسجّلة.
- **`view_admin_dashboard_summary`**: لوحة تحكم تجميعية شاملة للإدارة تُظهر الرحلات
  والمستخدمين والبلاغات والإيرادات.

---

## ٣. المهام التلقائية المجدولة (Events) — `events.sql`

### • الصيانة والأتمتة التشغيلية
- **`daily_summary_job`**: يجمع وينشئ ملخصًا يوميًا للإيرادات الكلية والرحلات
  والحجوزات.
- **`auto_complete_rides`**: يحوّل حالة الرحلات إلى "مكتملة" تلقائيًا بعد مرور ٣
  ساعات على موعدها.
- **`expire_pending_reservations`**: يرفض (`rejected`) الحجوزات المعلّقة التي انتهى
  وقت انطلاق رحلتها (`departure`).

### • التنظيف الدوري للحفظ والحماية
- **`cleanup_expired_sessions`**: يحذف الجلسات المنتهية الصلاحية دوريًا.
- **`cleanup_expired_tokens`** و **`cleanup_social_auth_temp`**: ينظّفان رموز الوصول
  والتسجيل المؤقتة.
- **`cleanup_old_location_points`**: يحذف نقاط الموقع التفصيلية الأقدم من ٣٠ يومًا
  لحماية الخصوصية.
- **`cleanup_expired_verification_codes`**: يحذف رموز التحقق وإعادة التعيين المنتهية.

### • الأرشفة والتدقيق التلقائي
- **`archive_old_audit_logs`**: ينقل سجلات التتبع والتدقيق الأقدم من سنة إلى جدول
  أرشيف خاص (`audit_log_archive`).
- **`weekly_wallet_reconciliation`**: يفحص أسبوعيًا المطابقة بين رصيد المحفظة
  والمعاملات المسجّلة ويسجّل الأخطاء.
- **`monthly_integrity_audit`**: فحص شهري ينبّه أمنيًا في حال وجود أي رصيد سالب
  بالمحافظ.

> **حدث أُزيل نهائيًا:** `escalate_stale_reports` (كان يكتب `status='needs_review'`
> وهي قيمة غير موجودة بموديل `Report`).

---

## ٤. القيود والمصادقات وإجراءات المخزنة (Procedures & Constraints)

### • قيود السلامة (Check Constraints) — `checks.sql`
- **قيود منع القيم السالبة** لأسعار وسعة الرحلات والمعاملات المالية الإيجابية:
  `chk_ride_cost`، `chk_ride_capacity`، `chk_transaction_amount_positive`،
  `chk_deposit_amount_positive`.
- **قيود نطاق الإحداثيات الجغرافية** لضمان صحّتها: `chk_current_lat_range`،
  `chk_current_lng_range`، `chk_point_lat_range`، `chk_point_lng_range`.

### • الإجراء المخزّن للصلاحيات والمالية (RBAC & Stored Procedure) — `permissions.sql`
- **`sp_adjust_wallet_balance`**: إجراء مخزّن اختياري لتعديل رصيد المحفظة بأمان، مع
  تطبيق التحقق من كفاية الرصيد قبل عملية الخصم (متاح كبديل أكثر أمانًا للتعديل
  المباشر).
- **نظام أدوار الوصول (Roles):** إنشاء `app_readwrite` و`app_readonly` و`admin_full`
  بتوزيع صلاحيات دقيق على مستوى الجداول — مع منح `app_readwrite` صلاحية `UPDATE` على
  المحفظة وطلبات الإيداع والجلسات بما يطابق حاجة الـ Backend الفعلية، وقراءة الـ
  Views وجدول الملخص اليومي فقط. طبقة المراقبة (`audit_log`/`activity_history`) تبقى
  محمية من أي وصول مباشر لأن الـ Triggers تكتب فيها بصلاحيات مُنشئها (DEFINER).

---

## ٥. الفهارس والجداول المساعدة

### • الفهارس (Indexes) — `indexes.sql`
- فهارس مركّبة لتسريع الاستعلامات: `idx_driver_status` على الرحلات،
  و`idx_rider_status` و`idx_ride_status` على الحجوزات.
- فهارس على جداول المراقبة: `idx_audit_table_time`، `idx_activity_created_at`.
- إزالة القيد المكرر `unique_user_ride_reservation` إن وُجد.

### • جداول طبقة المراقبة (Tables) — `00_tables.sql`
- **`audit_log`**: سجل تدقيق غير قابل للحذف لكل العمليات الحسّاسة.
- **`activity_history`**: سجل النشاطات العامّة للمنصّة.
- **`daily_platform_summary`**: ملخص يومي (رحلات/حجوزات/إيرادات).
- **`audit_log_archive`**: أرشيف سجلات التدقيق القديمة.

---

## ملاحظات تنفيذية

- كل الملفات **idempotent** (تستخدم `DROP IF EXISTS` / فحص ديناميكي /
  `CREATE OR REPLACE`)، فيمكن إعادة تشغيلها بأمان.
- نفّذ على بيئة **Staging** أولًا. ملف `permissions.sql` يحتاج حساب صلاحيات إدارية
  (`CREATE USER`/`GRANT`/`CREATE ROLE`)، و`events.sql` يحتاج صلاحية تفعيل
  `event_scheduler` (`SET PERSIST`).
