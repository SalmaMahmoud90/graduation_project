  
## 1. نظرة عامة على نظام الإشعارات

  

تم تنفيذ نظام الإشعارات باستخدام **Firebase Cloud Messaging (FCM)** لإرسال الإشعارات الفورية إلى أجهزة المستخدمين.

  

يعتمد النظام على تسجيل **FCM Device Token** الخاص بجهاز المستخدم وربطه بحسابه في قاعدة البيانات. بعد ذلك يتم استخدام هذا الـ Token لإرسال الإشعارات إلى أجهزة المستخدمين عند حدوث أحداث معينة داخل النظام.

  

يستخدم النظام رسالة تحتوي على:

  

- `notification`: لعرض عنوان ونص الإشعار.

- `data`: لإرسال معلومات إضافية إلى تطبيق Flutter مثل `reservation_id` و`ride_id` و`type`.

  

### آلية عمل النظام

  

```text

المستخدم يفتح التطبيق

        ↓

Firebase يولد FCM Device Token

        ↓

Flutter يرسل Token إلى Backend

        ↓

POST /register-device/

        ↓

تخزين Token في DeviceToken

        ↓

حدوث حدث داخل النظام

        ↓

safe_send_notification()

        ↓

Firebase Cloud Messaging

        ↓

جهاز المستخدم

        ↓

ظهور الإشعار

```


---

# 2. نموذج DeviceToken

يُستخدم نموذج `DeviceToken` لتخزين رموز الأجهزة المرتبطة بالمستخدمين، والتي يتم استخدامها لإرسال إشعارات Firebase.

## جدول الحقول

|الحقل|نوع البيانات|إجباري؟|الوصف والشروط|
|---|---|---|---|
|`id`|Integer|تلقائي|المعرّف الفريد لسجل الجهاز.|
|`user`|ForeignKey|نعم|المستخدم المرتبط بالجهاز.|
|`token`|String|نعم|رمز FCM الفريد الخاص بالجهاز.|
|`created_at`|DateTime|تلقائي|تاريخ إنشاء سجل الجهاز.|
|`updated_at`|DateTime|تلقائي|تاريخ آخر تحديث لسجل الجهاز.|

### خصائص النموذج

يتم تعريف `token` على أنه فريد:

unique = true

وبالتالي لا يمكن تسجيل نفس Device Token أكثر من مرة في قاعدة البيانات.

كما يتم ترتيب السجلات حسب:

updated_at DESC

بحيث تظهر الأجهزة التي تم تحديثها مؤخراً أولاً.

---

# 3. تسجيل جهاز المستخدم

## `POST /register-device/`

يُستخدم هذا الـ endpoint لتسجيل **FCM Device Token** الخاص بجهاز المستخدم وربطه بحسابه.

يتم استدعاء هذا الـ endpoint من تطبيق Flutter بعد الحصول على Firebase Device Token.

### Headers

Authorization: Bearer <access_token>

Content-Type: application/json

### Request

{

    "token": "FCM_DEVICE_TOKEN"

}

### Response

**200 OK**

{

    "message": "Device token registered successfully.",

    "token_id": 1

}

### آلية تنفيذ العملية

عند إرسال Device Token:

FCM Token

    ↓

التحقق من صحة Token

    ↓

البحث عن Token في قاعدة البيانات

    ↓

إذا كان موجوداً → تحديث المستخدم المرتبط به

إذا لم يكن موجوداً → إنشاء سجل جديد

    ↓

إرجاع نجاح العملية
___

يتم تنفيذ العملية باستخدام:

update_or_create()

بحيث يتم تجنب إنشاء سجلات مكررة لنفس الجهاز.

### شروط الاستخدام

- يجب أن يكون المستخدم مصادقًا عليه.
- يجب إرسال `token`.
- يجب ألا تكون قيمة `token` فارغة.
- يتم ربط الجهاز بالمستخدم الحالي.
- يمكن للمستخدم امتلاك أكثر من Device Token في حال استخدام أكثر من جهاز.

### الأخطاء

**400 Bad Request**

في حال عدم إرسال Token:

{

    "token": [

        "Device token is required."

    ]

}

---

# 4. إرسال الإشعارات

يتم إرسال الإشعارات من Backend باستخدام Firebase Cloud Messaging.

تم إنشاء مجموعة من الدوال المسؤولة عن إرسال الإشعارات.

## `send_notification_to_token()`

تُستخدم لإرسال إشعار إلى Device Token محدد.

## `send_notification_to_user()`

تُستخدم لإرسال إشعار إلى جميع الأجهزة المسجلة للمستخدم.

## `send_notification_to_users()`

تُستخدم لإرسال نفس الإشعار إلى مجموعة من المستخدمين.

## `safe_send_notification()`

تُستخدم لإرسال الإشعار بطريقة آمنة بحيث لا يؤدي فشل Firebase في إرسال الإشعار إلى فشل العملية الأساسية في النظام.

مثال:

عملية الدفع

    ↓

نجاح الدفع

    ↓

إرسال الإشعار

    ↓

Firebase Error

    ↓

تسجيل الخطأ في Log

    ↓

عملية الدفع تبقى ناجحة

---

# 5. أنواع الإشعارات

يحتوي النظام على مجموعة من الإشعارات التي يتم إرسالها تلقائياً عند حدوث أحداث معينة.

|نوع الإشعار|`type`|المستلم|الحدث|
|---|---|---|---|
|نجاح الدفع|`payment_success`|Rider|نجاح عملية الدفع|
|حجز جديد|`new_reservation`|Driver|إنشاء حجز جديد|
|قبول الحجز|`reservation_accepted`|Rider|قبول السائق للحجز|
|رفض الحجز|`reservation_rejected`|Rider|رفض السائق للحجز|
|إلغاء الرحلة|`ride_cancelled`|Rider|إلغاء السائق للرحلة|
|استلام أرباح الرحلة|`payment_received`|Driver|إكمال الرحلة وإضافة الأرباح إلى محفظة السائق|

---

# 6. إشعار نجاح الدفع

## `payment_success`

يتم إرسال هذا الإشعار إلى الراكب بعد نجاح عملية الدفع.

### المستلم

Rider

### Title

Payment Successful

### Body

Payment for your ride from {location} to {destination} was completed successfully.

### Data

{

    "type": "payment_success",

    "reservation_id": "1",

    "ride_id": "10"

}

### وقت الإرسال

يتم إرسال الإشعار بعد نجاح إنشاء عملية الدفع والمعاملة المالية.

---

# 7. إشعار حجز جديد

## `new_reservation`

يتم إرسال هذا الإشعار إلى السائق عندما يقوم أحد الركاب بإنشاء حجز على إحدى رحلاته.

### المستلم

Driver

### Title

New Reservation

### Body

{rider_name} requested a reservation for your ride from {location} to {destination}.

### Data

{

    "type": "new_reservation",

    "reservation_id": "1",

    "ride_id": "10"

}

### وقت الإرسال

يتم إرسال الإشعار بعد إنشاء الحجز بنجاح.

---

# 8. إشعار قبول الحجز

## `reservation_accepted`

يتم إرسال هذا الإشعار إلى الراكب عندما يقوم السائق بقبول طلب الحجز.

### المستلم

Rider

### Title

Reservation Accepted

### Body

Your reservation for {location} to {destination} has been accepted.

### Data

{

    "type": "reservation_accepted",

    "reservation_id": "1",

    "ride_id": "10"

}

### وقت الإرسال

يتم إرسال الإشعار بعد تغيير حالة الحجز من:

pending

إلى:

accepted

---

# 9. إشعار رفض الحجز

## `reservation_rejected`

يتم إرسال هذا الإشعار إلى الراكب عندما يقوم السائق برفض طلب الحجز.

### المستلم

Rider

### Title

Reservation Rejected

### Body

Your reservation for {location} to {destination} has been rejected.

### Data

{

    "type": "reservation_rejected",

    "reservation_id": "1",

    "ride_id": "10"

}

### وقت الإرسال

يتم إرسال الإشعار بعد رفض الحجز.

وفي حال كان الحجز مدفوعاً، يتم تنفيذ عملية Refund قبل إرسال الإشعار.

Paid Reservation

       ↓

Refund

       ↓

Reservation = Rejected

       ↓

Notification

---

# 10. إشعار إلغاء الرحلة

## `ride_cancelled`

يتم إرسال هذا الإشعار إلى الركاب المرتبطين بالرحلة عندما يقوم السائق بإلغائها.

### المستلمون

Riders

يتم إرسال الإشعار إلى الركاب الذين تكون حجوزاتهم بحالة:

pending

accepted

### Title

Ride Cancelled

### Body

The ride from {location} to {destination} has been cancelled.

### Data

{

    "type": "ride_cancelled",

    "ride_id": "10",

    "reservation_id": "1"

}

### وقت الإرسال

يتم إرسال الإشعار عند قيام السائق بإلغاء الرحلة.

بعد ذلك يتم تحويل حجوزات الركاب من:

pending

accepted

إلى:

cancelled

---

# 11. إشعار استلام أرباح الرحلة

## `payment_received`

يتم إرسال هذا الإشعار إلى السائق بعد إكمال الرحلة وإضافة إجمالي المبالغ المدفوعة إلى محفظته.

### المستلم

Driver

### Title

Payment Received

### Body

The payment for your ride from {location} to {destination} has been added to your wallet.

### Data

{

    "type": "payment_received",

    "ride_id": "10",

    "amount": "150000.00"

}

### آلية التنفيذ

يتم إرسال الإشعار بعد نجاح العملية المالية:

Complete Ride

      ↓

جلب الحجوزات المدفوعة

      ↓

حساب إجمالي الأرباح

      ↓

إضافة المبلغ إلى Wallet السائق

      ↓

إنشاء Transaction من نوع EARNING

      ↓

تغيير Ride إلى COMPLETED

      ↓

إرسال Payment Received Notification

### مثال

إذا كان:

Ride.cost = 50000

وعدد الحجوزات المدفوعة:

3

فإن:

Total Earnings = 50000 × 3

               = 150000

ويتم إرسال:

{

    "type": "payment_received",

    "ride_id": "10",

    "amount": "150000.00"

}

إلى السائق.

---

# 12. ملخص دورة الإشعارات

                    Notification System

                           │

          ┌────────────────┴────────────────┐

          │                                 │

     Device Token                      System Event

          │                                 │

          ↓                                 ↓

  /register-device/                Business Operation

          │                                 │

          ↓                                 ↓

    DeviceToken DB                  safe_send_notification()

                                            │

                                            ↓

                                  Firebase Cloud Messaging

                                            │

                                            ↓

                                     User's Device

---

# 13. الأحداث التي تؤدي إلى إرسال الإشعارات

|العملية|المستخدم المتأثر|الإشعار|
|---|---|---|
|إنشاء حجز|Driver|`new_reservation`|
|نجاح الدفع|Rider|`payment_success`|
|قبول الحجز|Rider|`reservation_accepted`|
|رفض الحجز|Rider|`reservation_rejected`|
|إلغاء الرحلة|Rider|`ride_cancelled`|
|إكمال الرحلة|Driver|`payment_received`|

---

# 14. الصلاحيات العامة

جميع عمليات تسجيل الأجهزة محمية وتتطلب:

Authorization: Bearer <access_token>

ويجب أن يكون المستخدم:

Authenticated

ويتم ربط Device Token بالمستخدم الذي أرسل الطلب.

أما إرسال الإشعارات فلا يتم بشكل مباشر من المستخدم، وإنما يتم تلقائياً من Backend عند حدوث العمليات المحددة في النظام.

---

# 15. ملاحظات مهمة

- يتم تخزين أكثر من Device Token للمستخدم في حال استخدامه أكثر من جهاز.
- يتم استخدام Firebase Cloud Messaging لإرسال الإشعارات.
- يتم إرسال الإشعارات إلى جميع الأجهزة المرتبطة بالمستخدم.
- فشل إرسال الإشعار لا يؤدي إلى فشل العملية الأساسية بسبب استخدام `safe_send_notification()`.
- يتم تمرير `reservation_id` و`ride_id` ضمن `data` عند الحاجة، مما يسمح لتطبيق Flutter بمعرفة العملية المرتبطة بالإشعار.
- يتم تسجيل Device Token تلقائياً من تطبيق Flutter بعد الحصول عليه من Firebase.
- يجب أن تكون قيم `data` المرسلة إلى Firebase من نوع `String`، لذلك يتم تحويل المعرفات والمبالغ إلى نصوص عند إرسالها.
- يستخدم النظام رسالة FCM تحتوي على `notification` و`data`، بحيث يمكن لـ FCM عرض الإشعار، بينما يستطيع تطبيق العميل استخدام بيانات `data` لمعرفة نوع الحدث والعناصر المرتبطة به.

  

ملاحظة صغيرة: **بالنسخة النهائية عندك، `payment_received` لازم ما توثقيه كـ API مستقل**؛ هو Notification Event ناتج عن `complete_ride`. وهذا التنظيم اللي فوق هو الأنسب.