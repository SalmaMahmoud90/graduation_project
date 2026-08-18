## 1. جدول حقول البيانات والمعاني (Fields Dictionary)

### `Wallet`

|اسم الحقل|نوع البيانات|إجباري؟|الوصف والشروط|
|---|---|---|---|
|`user`|ForeignKey|تلقائي|المستخدم المرتبط بالمحفظة، ويتم إنشاء محفظة تلقائيًا عند إنشاء المستخدم.|
|`balance`|Decimal|تلقائي|الرصيد الحالي للمستخدم داخل المحفظة، والقيمة الافتراضية `0`.|

### `Transaction`

|اسم الحقل|نوع البيانات|إجباري؟|الوصف والشروط|
|---|---|---|---|
|`id`|Integer|تلقائي|المعرّف الفريد للمعاملة.|
|`wallet`|ForeignKey|نعم|المحفظة المرتبطة بالمعاملة.|
|`reservation`|ForeignKey|اختياري|الحجز المرتبط بالمعاملة، ويستخدم مع عمليات الدفع والاسترداد.|
|`deposit_request`|ForeignKey|اختياري|طلب الإيداع المرتبط بالمعاملة، ويستخدم عند إضافة رصيد للمحفظة.|
|`amount`|Decimal|نعم|قيمة المبلغ المالي للمعاملة.|
|`transaction_type`|String|نعم|نوع المعاملة.|
|`created_at`|DateTime|تلقائي|تاريخ ووقت إنشاء المعاملة.|

### `DepositRequest`

|اسم الحقل|نوع البيانات|إجباري؟|الوصف والشروط|
|---|---|---|---|
|`id`|Integer|تلقائي|المعرّف الفريد لطلب الإيداع.|
|`user`|ForeignKey|تلقائي|المستخدم الذي أنشأ طلب الإيداع.|
|`amount`|Decimal|نعم|المبلغ المطلوب إضافته إلى المحفظة، ويجب أن يكون أكبر من الصفر.|
|`payment_method`|String|نعم|طريقة الدفع المستخدمة للإيداع.|
|`transaction_reference`|String|نعم|الرقم المرجعي لعملية التحويل.|
|`status`|String|تلقائي|حالة طلب الإيداع.|
|`created_at`|DateTime|تلقائي|تاريخ ووقت إنشاء طلب الإيداع.|

---

# 2. القيم الثابتة والتعدادات (Enums & Fixed Values)

### `TransactionType` — نوع المعاملة

|القيمة|المعنى|
|---|---|
|`deposit`|إضافة رصيد إلى المحفظة.|
|`payment`|دفع قيمة حجز من محفظة الراكب.|
|`earning`|المبلغ الذي يحصل عليه السائق بعد إكمال الرحلة.|
|`refund`|إعادة مبلغ إلى الراكب عند رفض الحجز المدفوع.|

### `PaymentMethod` — طريقة الإيداع

|القيمة|المعنى|
|---|---|
|`syriatel_cash`|الدفع عن طريق Syriatel Cash.|
|`sham_cash`|الدفع عن طريق Sham Cash.|

### `DepositRequest.Status` — حالة طلب الإيداع

|القيمة|المعنى|
|---|---|
|`pending`|طلب الإيداع بانتظار المعالجة.|
|`approved`|تمت الموافقة على طلب الإيداع.|
|`rejected`|تم رفض طلب الإيداع.|

### `Reservation.PaymentStatus` المستخدم في عملية الدفع

|القيمة|المعنى|
|---|---|
|`unpaid`|الحجز لم يتم دفعه بعد.|
|`paid`|تم دفع قيمة الحجز.|

---

# 3. جدول مسارات الـ API وطريقة الاستخدام (Endpoints Reference)

### Base URL

http://127.0.0.1:8000/api/payments/

|Endpoint|Method|يتطلب Token؟|الوصف|
|---|---|---|---|
|`/view_balance/`|`GET`|نعم|عرض رصيد المحفظة|
|`/deposit_request/`|`POST`|نعم|إنشاء طلب إيداع|
|`/view_deposit_requests/`|`GET`|نعم|عرض طلبات الإيداع الخاصة بالراكب|
|`/view_transactions/`|`GET`|نعم|عرض سجل معاملات المستخدم|
|`/pay/`|`POST`|نعم|دفع قيمة حجز|

---

# 4. عرض رصيد المحفظة

## `GET /view_balance/`

يُستخدم هذا الـ endpoint لعرض الرصيد الحالي للمستخدم داخل المحفظة.

### Headers

Authorization: Bearer <access_token>

### Request

لا يحتاج إلى Request Body.

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

يُستخدم هذا الـ endpoint من قبل الراكب لإنشاء طلب لإضافة رصيد إلى محفظته.

### Headers

Authorization: Bearer <access_token>

Content-Type: application/json

### Request

{

    "amount": "100000.00",

    "payment_method": "syriatel_cash",

    "transaction_reference": "123456789"

}

### الحقول

- `amount`: المبلغ المطلوب إضافته.
- `payment_method`: طريقة الدفع.
- `transaction_reference`: الرقم المرجعي لعملية التحويل.

### Response

**201 Created**

{

    "id": 1,

    "amount": "100000.00",

    "payment_method": "syriatel_cash",

    "transaction_reference": "123456789"

}

### شروط الاستخدام

- يجب أن يكون المستخدم من نوع `rider`.
- يجب أن يكون `amount` أكبر من `0`.
- يتم إنشاء الطلب بحالة:

pending

### الأخطاء

**403 Forbidden**

إذا لم يكن المستخدم راكبًا:

{

    "error": "Only riders can deposit request"

}

**400 Bad Request**

إذا كان المبلغ يساوي أو يقل عن الصفر:

{

    "amount": [

        "Amount must be greater than zero."

    ]

}

---

# 6. عرض طلبات الإيداع

## `GET /view_deposit_requests/`

يُستخدم لعرض طلبات الإيداع الخاصة بالراكب الحالي.

### Headers

Authorization: Bearer <access_token>

### Request

لا يحتاج إلى Request Body.

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
- يتم عرض طلبات الإيداع الخاصة بالمستخدم الحالي فقط.

### الأخطاء

**400 Bad Request**

إذا لم يكن المستخدم من نوع `rider`:

{

    "error": "Invalid user type"

}

---

# 7. عرض سجل المعاملات

## `GET /view_transactions/`

يُستخدم لعرض جميع المعاملات المالية المرتبطة بمحفظة المستخدم الحالي.

### Headers

Authorization: Bearer <access_token>

### Request

لا يحتاج إلى Request Body.

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

            "transaction_type": "refund",

            "created_at": "2026-08-17T11:00:00Z"

        }

    ]

}

### أنواع المعاملات الممكنة

deposit

payment

earning

refund

### ملاحظة

الـ API الحالي يعرض:

id

transaction_type

created_at

فقط، ولا يعرض `amount` حاليًا.

---

# 8. دفع قيمة الحجز

## `POST /pay/`

يُستخدم هذا الـ endpoint من قبل الراكب لدفع قيمة حجز موجود مسبقًا.

يتم خصم قيمة المقعد من محفظة الراكب وإنشاء معاملة من النوع `payment`.

### Headers

Authorization: Bearer <access_token>

Content-Type: application/json

### Request

{

    "reservation": 15

}

حيث `15` هو معرّف الحجز الذي يريد الراكب دفع قيمته.

### Response

**200 OK**

{

    "message": "Payment completed successfully.",

    "transaction_id": 25,

    "remaining_balance": "50000.00"

}

### آلية تنفيذ الدفع

عند إرسال طلب الدفع:

Reservation

     ↓

التحقق من ملكية الحجز

     ↓

التحقق من حالة الحجز

     ↓

التحقق من حالة الدفع

     ↓

التحقق من رصيد Wallet

     ↓

خصم Ride.cost

     ↓

إنشاء Transaction من نوع PAYMENT

     ↓

تغيير PaymentStatus إلى PAID

### شروط الاستخدام

- يجب أن يكون المستخدم من نوع `rider`.
- يجب أن يكون الحجز تابعًا للراكب الحالي.
- يجب أن تكون حالة الحجز:

pending

- يجب أن تكون حالة الدفع:

unpaid

- يجب أن يكون رصيد المحفظة كافيًا لتغطية تكلفة المقعد.
- يتم خصم قيمة `ride.cost` من محفظة الراكب.

### مثال

إذا كان:

Wallet balance = 100000

Ride cost = 30000

بعد الدفع:

Wallet balance = 70000

ويتم إنشاء:

Transaction

transaction_type = payment

amount = 30000

وتصبح حالة الدفع للحجز:

paid

### الأخطاء

**403 Forbidden**

إذا لم يكن المستخدم راكبًا:

{

    "error": "Only riders can pay for reservations."

}

**400 Bad Request**

إذا لم يكن الحجز تابعًا للمستخدم:

{

    "non_field_errors": [

        "This isn't your reservation."

    ]

}

إذا لم يكن الحجز بحالة `pending`:

{

    "non_field_errors": [

        "Only pending reservations can be paid."

    ]

}

إذا كان الحجز مدفوعًا مسبقًا:

{

    "non_field_errors": [

        "This reservation has already been paid."

    ]

}

إذا كان الرصيد غير كافٍ:

{

    "non_field_errors": [

        "Insufficient balance."

    ]

}

---

# 9. دورة العملية المالية (Payment Flow)

يتم التعامل مع قيمة الحجز وفق التسلسل التالي:

Rider creates reservation

        ↓

Reservation = PENDING

        ↓

Rider pays

        ↓

Wallet - Ride.cost

        ↓

Transaction = PAYMENT

        ↓

Reservation.payment = PAID

        ↓

Driver accepts reservation

        ↓

Ride becomes ACTIVE

        ↓

Ride becomes COMPLETED

        ↓

Driver Wallet + paid reservation amounts

        ↓

Transaction = EARNING

وفي حال رفض السائق لحجز **مدفوع مسبقًا**:

Reservation = PAID

        ↓

Driver rejects reservation

        ↓

Rider Wallet + Ride.cost

        ↓

Transaction = REFUND

        ↓

Reservation = REJECTED

وبذلك يتم الاحتفاظ بسجل كامل للعمليات المالية دون الحاجة إلى تعديل `Reservation.payment` عند تنفيذ عملية الـ Refund.

---

# 10. نظام المحفظة (Wallet System)

يتم إنشاء `Wallet` تلقائيًا لكل مستخدم جديد باستخدام Django Signal.

عند إنشاء مستخدم جديد:

MainUser created

       ↓

post_save signal

       ↓

Wallet created

       ↓

balance = 0

ويتم استخدام المحفظة في العمليات التالية:

|العملية|تأثيرها على الرصيد|
|---|---|
|`DEPOSIT`|زيادة الرصيد|
|`PAYMENT`|إنقاص الرصيد|
|`REFUND`|زيادة الرصيد|
|`EARNING`|زيادة الرصيد|

### ملاحظة مهمة

تتم حماية عمليات تعديل الرصيد باستخدام:

select_for_update()

مع:

transaction.atomic

وذلك لمنع حدوث تعارض عند تنفيذ عمليات مالية متزامنة على نفس المحفظة.