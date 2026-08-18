### 1. جدول حقول البيانات والمعاني (Fields Dictionary)

### `Wallet`

|Field|Type|Required?|Description|
|---|---|---|---|
|`user`|ForeignKey|تلقائي|المستخدم المرتبط بالمحفظة، ويتم إنشاء محفظة تلقائيًا عند إنشاء المستخدم.|
|`balance`|Decimal|تلقائي|الرصيد الحالي للمستخدم داخل المحفظة، والقيمة الافتراضية `0`.|

### `Transaction`

|Field|Type|Required?|Description|
|---|---|---|---|
|`id`|Integer|تلقائي|المعرّف الفريد للمعاملة.|
|`wallet`|ForeignKey|نعم|المحفظة المرتبطة بالمعاملة.|
|`reservation`|ForeignKey|اختياري|الحجز المرتبط بالمعاملة.|
|`deposit_request`|ForeignKey|اختياري|طلب الإيداع المرتبط بالمعاملة.|
|`amount`|Decimal|نعم|قيمة المبلغ المالي للمعاملة.|
|`transaction_type`|String|نعم|نوع المعاملة المالية.|
|`created_at`|DateTime|تلقائي|تاريخ ووقت إنشاء المعاملة.|

### `DepositRequest`

|Field|Type|Required?|Description|
|---|---|---|---|
|`id`|Integer|تلقائي|المعرّف الفريد لطلب الإيداع.|
|`user`|ForeignKey|تلقائي|المستخدم الذي أنشأ طلب الإيداع.|
|`amount`|Decimal|نعم|المبلغ المطلوب إضافته إلى المحفظة، ويجب أن يكون أكبر من الصفر.|
|`payment_method`|String|نعم|طريقة الدفع المستخدمة للإيداع.|
|`transaction_reference`|String|نعم|الرقم المرجعي لعملية التحويل.|
|`status`|String|تلقائي|حالة طلب الإيداع.|
|`created_at`|DateTime|تلقائي|تاريخ ووقت إنشاء الطلب.|

---

# 2. القيم الثابتة والتعدادات (Enums & Fixed Values)

### `TransactionType`

|القيمة|المعنى|
|---|---|
|`deposit`|إضافة رصيد إلى المحفظة بعد الموافقة على طلب الإيداع.|
|`payment`|خصم قيمة الحجز من محفظة الراكب عند قبول السائق للحجز.|
|`earning`|الأرباح التي يحصل عليها السائق بعد إكمال الرحلة.|

### `PaymentMethod`

|القيمة|المعنى|
|---|---|
|`syriatel_cash`|الإيداع عن طريق Syriatel Cash.|
|`sham_cash`|الإيداع عن طريق Sham Cash.|

### `DepositRequest.Status`

|القيمة|المعنى|
|---|---|
|`pending`|طلب الإيداع بانتظار المعالجة.|
|`approved`|تمت الموافقة على طلب الإيداع.|
|`rejected`|تم رفض طلب الإيداع.|

### `Reservation.PaymentStatus`

|القيمة|المعنى|
|---|---|
|`unpaid`|الحجز لم يتم دفع قيمته بعد.|
|`paid`|تم دفع قيمة الحجز.|

---

# 3. جدول مسارات الـ API وطريقة الاستخدام

### Base URL

http://127.0.0.1:8000/api/payments/

|Endpoint|Method|Token؟|الوصف|
|---|---|---|---|
|`/view_balance/`|`GET`|نعم|عرض رصيد المحفظة|
|`/deposit_request/`|`POST`|نعم|إنشاء طلب إيداع|
|`/view_deposit_requests/`|`GET`|نعم|عرض طلبات الإيداع الخاصة بالراكب|
|`/view_transactions/`|`GET`|نعم|عرض سجل معاملات المستخدم|


---

# 4. عرض رصيد المحفظة

## `GET /view_balance/`

يُستخدم هذا الـ endpoint لعرض الرصيد الحالي للمستخدم.

### Headers

Authorization: Bearer <access_token>

### Response

**200 OK**

{

    "balance": "100000.00"

}

### ملاحظات

- يتم جلب المحفظة المرتبطة بالمستخدم الحالي.
- يتم إنشاء المحفظة تلقائيًا عند إنشاء المستخدم.
- الرصيد الافتراضي للمحفظة هو `0`.

---

# 5. إنشاء طلب إيداع

## `POST /deposit_request/`

يُستخدم من قبل الراكب لإنشاء طلب لإضافة رصيد إلى محفظته.

### Headers

Authorization: Bearer <access_token>

Content-Type: application/json

### Request

{

    "amount": "100000.00",

    "payment_method": "syriatel_cash",

    "transaction_reference": "123456789"

}

### شروط الاستخدام

- يجب أن يكون المستخدم من نوع `rider`.
- يجب أن يكون `amount` أكبر من `0`.
- يتم إنشاء الطلب بحالة `pending`.

---

# 6. عرض طلبات الإيداع

## `GET /view_deposit_requests/`

يعرض طلبات الإيداع الخاصة بالراكب الحالي.

### Response

**200 OK**

{

    "deposit_requests": [

        {

            "id": 1,

            "payment_method": "syriatel_cash",

            "transaction_reference": "123456789",

            "amount": "100000.00",

            "status": "pending",

            "created_at": "2026-08-17T10:30:00Z"

        }

    ]

}

### شروط الاستخدام

- يجب أن يكون المستخدم من نوع `rider`.
- يتم عرض الطلبات الخاصة بالمستخدم الحالي فقط.

---

# 7. عرض سجل المعاملات

## `GET /view_transactions/`

يعرض جميع المعاملات المالية المرتبطة بمحفظة المستخدم الحالي.

### Response

**200 OK**

{

    "transactions": [

        {

            "id": 1,

            "transaction_type": "deposit",

            "created_at": "2026-08-17T09:00:00Z"

        },

        {

            "id": 2,

            "transaction_type": "payment",

            "created_at": "2026-08-17T10:00:00Z"

        },

        {

            "id": 3,

            "transaction_type": "earning",

            "created_at": "2026-08-17T11:00:00Z"

        }

    ]

}

### أنواع المعاملات

deposit

payment

earning

> الـ API الحالي يعرض `id` و`transaction_type` و`created_at` فقط، ولا يعرض `amount`.

---

# 8. الدفع عند قبول الحجز

لم يعد هناك API منفصل للدفع.

يتم تنفيذ الدفع **تلقائيًا ضمن API قبول الحجز الخاص بالسائق**.

## `POST /reservations/<reservation_id>/accept/`

يُستخدم من قبل السائق لقبول حجز أحد الركاب.

عند قبول الحجز، يقوم النظام تلقائيًا بخصم قيمة الحجز من محفظة الراكب.

### آلية التنفيذ

Rider creates reservation

        ↓

Reservation = PENDING

        ↓

Driver accepts reservation

        ↓

التحقق من ملكية السائق للرحلة

        ↓

التحقق من حالة الحجز

        ↓

التحقق من رصيد الراكب

        ↓

Rider Wallet - Ride.cost

        ↓

Create Transaction = PAYMENT

        ↓

Reservation.payment = PAID

        ↓

Reservation.status = ACCEPTED

### الشروط

- يجب أن يكون المستخدم `driver`.
- يجب أن يكون الحجز تابعًا لرحلة السائق.
- يجب أن تكون حالة الحجز `pending`.
- يجب أن يكون رصيد الراكب كافيًا.
- يتم خصم قيمة `ride.cost` من محفظة الراكب.
- يتم إنشاء `Transaction` من النوع `payment`.
- تصبح حالة الدفع `paid`.
- تصبح حالة الحجز `accepted`.

### مثال

رصيد الراكب:

100000

سعر المقعد:

30000

عند قبول السائق للحجز:

100000 - 30000 = 70000

ويتم إنشاء:

transaction_type = payment

amount = 30000

وتصبح:

reservation.status = accepted

reservation.payment = paid

### في حال عدم كفاية الرصيد

لا يتم قبول الحجز ولا يتم خصم أي مبلغ.

{

    "error": "Insufficient balance."

}

---

# 9. رفض الحجز

## `POST /reservations/<reservation_id>/reject/`

يُستخدم من قبل السائق لرفض حجز لم يتم قبوله.

عند رفض الحجز **لا يتم تنفيذ أي عملية مالية**.

### آلية التنفيذ

Reservation = PENDING

        ↓

Driver rejects reservation

        ↓

Reservation.status = REJECTED


---

# 10. إكمال الرحلة وأرباح السائق

بعد انتهاء الرحلة يقوم السائق باستخدام API إكمال الرحلة.

## `POST /complete_ride/<ride_id>/`

عند إكمال الرحلة:

1. يتم جلب الحجوزات المدفوعة.
2. يتم حساب إجمالي المبلغ المدفوع.
3. تتم إضافة المبلغ إلى محفظة السائق.
4. يتم إنشاء `Transaction` من النوع `earning`.
5. تصبح الرحلة `completed`.

### مثال

Ride.cost = 50000

عدد الحجوزات المدفوعة:

3

إجمالي الأرباح:

50000 × 3 = 150000

يتم:

Driver Wallet + 150000

ثم:

Transaction = EARNING

amount = 150000

---

# 11. دورة العملية المالية الجديدة

النظام الحالي يعمل وفق التسلسل التالي:

Rider creates reservation

        ↓

Reservation = PENDING

        ↓

Driver accepts reservation

        ↓

Check Rider Wallet

        ↓

Wallet Rider - Ride.cost

        ↓

Transaction = PAYMENT

        ↓

Reservation.payment = PAID

        ↓

Reservation.status = ACCEPTED

        ↓

Ride is completed

        ↓

Driver Wallet + paid reservation amounts

        ↓

Transaction = EARNING

أما في حال رفض السائق للحجز:

Rider creates reservation

        ↓

Reservation = PENDING

        ↓

Driver rejects reservation

        ↓

Reservation = REJECTED

**ولا توجد أي عملية مالية عند الرفض.**

---

# 12. نظام المحفظة

يتم إنشاء محفظة تلقائيًا لكل مستخدم جديد باستخدام Django Signal.

MainUser created

       ↓

post_save signal

       ↓

Wallet created

       ↓

balance = 0

وتستخدم المحفظة في العمليات التالية:

|العملية|تأثيرها على الرصيد|
|---|---|
|`DEPOSIT`|زيادة الرصيد|
|`PAYMENT`|إنقاص الرصيد|
|`EARNING`|زيادة الرصيد|

---
