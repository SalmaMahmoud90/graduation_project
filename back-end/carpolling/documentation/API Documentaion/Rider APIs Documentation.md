### 1. جدول حقول البيانات والمعاني (Fields Dictionary):

| اسم الحقل (Field)   | نوع البيانات | إجباري؟             | الوصف والشروط                                                                            |
| ------------------- | ------------ | ------------------- | ---------------------------------------------------------------------------------------- |
| `id`                | Integer      | تلقائي              | المعرّف الفريد للحجز أو الرحلة.                                                          |
| `location`          | String       | نعم                 | مكان انطلاق الرحلة.                                                                      |
| `destination`       | String       | نعم                 | وجهة الرحلة.                                                                             |
| `departure_time`    | Time         | تلقائي              | وقت انطلاق الرحلة.                                                                       |
| `departure_date`    | Date         | تلقائي              | تاريخ انطلاق الرحلة.                                                                     |
| `expected_duration` | String       | اختياري             | المدة المتوقعة للرحلة.                                                                   |
| `cost`              | Decimal      | تلقائي              | تكلفة الرحلة.                                                                            |
| `capacity`          | Integer      | تلقائي              | السعة الكلية للرحلة.                                                                     |
| `available_seats`   | Integer      | تلقائي              | عدد المقاعد المتاحة، ويُحسب من السعة مطروحًا منها الحجوزات بحالتي `pending` و`accepted`. |
| `status`            | String       | تلقائي              | حالة الرحلة.                                                                             |
| `driver_name`       | String       | تلقائي              | اسم السائق المرتبط بالرحلة.                                                              |
| `car_image`         | File/Image   | تلقائي              | صورة سيارة السائق.                                                                       |
| `rider_name`        | String       | تلقائي              | اسم الراكب صاحب الحجز.                                                                   |
| `payment`           | String       | تلقائي              | حالة دفع الحجز.                                                                          |
| `pickup_location`   | String       | نعم عند إنشاء الحجز | مكان صعود الراكب.                                                                        |
| `created_at`        | DateTime     | تلقائي              | تاريخ ووقت إنشاء الحجز.                                                                  |
___
# 2. القيم الثابتة والتعدادات (Enums & Fixed Values)

## `RideStatus` — حالة الرحلة

|القيمة|المعنى|
|---|---|
|`active`|الرحلة فعّالة|
|`completed`|الرحلة مكتملة|
|`cancelled`|الرحلة ملغاة|

## `ReservationStatus` — حالة الحجز

|القيمة|المعنى|
|---|---|
|`pending`|الحجز بانتظار موافقة السائق|
|`accepted`|الحجز مقبول|
|`rejected`|الحجز مرفوض|
|`cancelled`|الحجز ملغى|

## `PaymentStatus` — حالة الدفع

|القيمة|المعنى|
|---|---|
|`unpaid`|لم يتم الدفع|
|`paid`|تم الدفع|

---

# 3. جدول مسارات الـ API وطريقة الاستخدام (Endpoints Reference)

### Base URL

http://127.0.0.1:8000/api/rides/

|Endpoint|Method|يتطلب Token؟|الوصف|
|---|---|---|---|
|`/reservations/create/`|`POST`|نعم|إنشاء حجز جديد على رحلة|
|`/reservations/<reservation_id>/cancel/`|`POST`|نعم|إلغاء حجز سابق|
|`/search/`|`GET`|نعم|البحث عن الرحلات المتاحة|
|`/my_reservations/`|`GET`|نعم|عرض حجوزات الراكب الحالي|
|`/ride_details/<ride_id>/`|`GET`|نعم|عرض تفاصيل رحلة محددة|

---

# 4. إنشاء حجز

## `POST /reservations/create/`

يُستخدم هذا الـ endpoint من قبل الراكب لإنشاء حجز على رحلة متاحة.

### Headers

Authorization: Bearer <access_token>

Content-Type: application/json

### Request

{

    "ride": 1,

    "pickup_location": "Latakia University"

}

### Response

**201 Created**

{

    "id": 1,

    "ride": 1,

    "status": "pending",

    "created_at": "2026-08-16T10:30:00Z",

    "pickup_location": "Latakia University"

}


### شروط الاستخدام

- يجب أن يكون المستخدم من نوع `rider`.
- يجب أن تكون الرحلة تحتوي على مقعد متاح.
- لا يمكن للراكب حجز الرحلة نفسها أكثر من مرة.
- لا يمكن للراكب حجز رحلة هو سائقها.

### الأخطاء

**403 Forbidden**

{

    "error": "Only riders can create reservations."

}

**400 Bad Request**

{

    "non_field_errors": [

        "No available seats left on this ride."

    ]

}

أو:

{

    "non_field_errors": [

        "You have already reserved a seat on this ride."

    ]

}

أو:

{

    "non_field_errors": [

        "You cannot reserve your own ride."

    ]

}

---

# 5. إلغاء حجز

## `POST /reservations/<reservation_id>/cancel/`

يُستخدم لإلغاء حجز يملكه الراكب الحالي.

### Headers

Authorization: Bearer <access_token>

### Example

POST /reservations/1/cancel/

### Response

**200 OK**

{

    "message": "Reservation canceled successfully"

}

### شروط الاستخدام

- يجب أن يكون المستخدم من نوع `rider`.
- يجب أن يكون الحجز تابعًا للراكب الحالي.
- لا يمكن إلغاء الحجز إذا كانت حالته:
    - `rejected`
    - `cancelled`
- عند نجاح العملية تتحول حالة الحجز إلى:

cancelled

### الأخطاء

**403 Forbidden**

{

    "error": "Only riders can canceled reservations"

}

أو:

{

    "error": "You can only canceled your reservations"

}

**404 Not Found**

{

    "error": "Reservation not found"

}

**400 Bad Request**

{

    "error": "This reservation cannot be canceled"

}

---

# 6. البحث عن الرحلات

## `GET /search/`

يُستخدم للبحث عن الرحلات الفعّالة التي تطابق مكان الانطلاق والوجهة المحددين.

### Headers

Authorization: Bearer <access_token>

### Query Parameters

|Parameter|النوع|إجباري؟|الوصف|
|---|---|---|---|
|`location`|String|نعم|مكان انطلاق الرحلة|
|`destination`|String|نعم|وجهة الرحلة|

### Example

GET /search/?location=Latakia&destination=Tartous

### Response

**200 OK**

{

    "rides": [

        {

            "id": 1,

            "location": "Latakia",

            "destination": "Tartous",

            "departure_time": "08:00:00",

            "cost": "50000.00",

            "capacity": 4,

            "available_seats": 2,

            "status": "active",

            "driver_info": {

                "driver_name": "Ahmad",

                "car_image": "/media/car_images/car.jpg"

            }

        }

    ]

}

### شروط الاستخدام

يتم عرض الرحلات التي:

- مكان انطلاقها يطابق `location`.
- وجهتها تطابق `destination`.
- حالتها `active`.
- تحتوي على مقعد واحد على الأقل.

البحث يستخدم:

icontains

لذلك لا يشترط أن تكون قيمة البحث مطابقة تمامًا للنص المخزن.

### الأخطاء

**400 Bad Request**

إذا لم يتم إرسال `location` أو `destination`:

{

    "error": "Please provide both location and destination."

}

---

# 7. عرض حجوزات الراكب

## `GET /my_reservations/`

يُستخدم لعرض جميع الحجوزات الخاصة بالراكب الحالي.

### Headers

Authorization: Bearer <access_token>

### Response

**200 OK**

{

    "reservations": [

        {

            "id": 1,

            "rider_name": "Ahmad",

            "status": "accepted",

            "payment": "paid",

            "ride_location": "Latakia",

            "ride_destination": "Tartous",

            "created_at": "2026-08-16T10:30:00Z",

            "pickup_location": "Latakia University"

        }

    ]

}

### البيانات المعروضة

يتم عرض:

- رقم الحجز.
- اسم الراكب.
- حالة الحجز.
- حالة الدفع.
- مكان انطلاق الرحلة.
- وجهة الرحلة.
- تاريخ إنشاء الحجز.
- مكان صعود الراكب.

### شروط الاستخدام

- يجب أن يكون المستخدم من نوع `rider`.
- يتم جلب الحجوزات الخاصة بالراكب الحالي فقط.
- يتم ترتيب الحجوزات تنازليًا حسب `id`.

### الأخطاء

**404 Not Found**

إذا لم يتم العثور على ملف الراكب:

{

    "error": "Rider profile not found"

}

**400 Bad Request**

إذا لم يكن المستخدم من نوع `rider`:

{

    "error": "Invalid user type"

}

---

# 8. عرض تفاصيل رحلة

## `GET /ride_details/<ride_id>/`

يُستخدم لعرض تفاصيل رحلة محددة.

### Headers

Authorization: Bearer <access_token>

### Example

GET /ride_details/1/

### Response

**200 OK**

{

    "ride": {

        "id": 1,

        "location": "Latakia",

        "destination": "Tartous",

        "departure_time": "08:00:00",

        "departure_date": "2026-08-15",

        "expected_duration": "1 hour",

        "cost": "50000.00",

        "capacity": 4,

        "available_seats": 2,

        "status": "active",

        "driver_info": {

            "driver_name": "Ahmad",

            "car_image": "/media/car_images/car.jpg"

        }

    }

}

### شروط الاستخدام

هناك حالتان:

#### الراكب / المستخدم العادي

يمكنه رؤية تفاصيل الرحلة فقط إذا كانت الرحلة:

active

إذا كانت الرحلة `completed` أو `cancelled` فلن تظهر له.

#### سائق الرحلة

إذا كان المستخدم هو سائق الرحلة نفسها، فيمكنه رؤية تفاصيل رحلته حتى لو كانت حالتها:

active

completed

cancelled

### الأخطاء

**404 Not Found**

إذا لم تكن الرحلة موجودة:

{

    "error": "Ride not found"

}

أو إذا كانت الرحلة غير `active` والمستخدم ليس سائقها:

{

    "error": "Ride not found"

}

---

# 9. صلاحيات الراكب (Rider Permissions)

جميع APIs الخاصة بالراكب محمية وتتطلب:

Authorization: Bearer <access_token>

ويجب أن يكون المستخدم مصادقًا عليه وحسابه فعالًا.

بالإضافة إلى ذلك، يتم التحقق من نوع المستخدم داخل الـ APIs التي تتطلب صلاحية الراكب:

user_type = rider

ولا يستطيع الراكب:

- إنشاء حجز إذا لم يكن لديه مقعد متاح.
- إنشاء أكثر من حجز لنفس الرحلة.
- حجز الرحلة التي يقودها بنفسه.
- إلغاء حجز يخص راكبًا آخر.
- إلغاء حجز مرفوض أو ملغى.
- مشاهدة رحلة غير فعّالة إذا لم يكن هو سائقها.
