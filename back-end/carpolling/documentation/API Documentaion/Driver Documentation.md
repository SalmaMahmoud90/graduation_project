# Driver APIs Documentation

## 1. جدول حقول البيانات والمعاني (Fields Dictionary)

|اسم الحقل (Field)|نوع البيانات|إجباري؟|الوصف والشروط|
|---|---|---|---|
|`id`|Integer|تلقائي|المعرّف الفريد للرحلة.|
|`location`|String|نعم عند الإنشاء|مكان انطلاق الرحلة.|
|`destination`|String|نعم عند الإنشاء|وجهة الرحلة، ويجب أن تختلف عن `location`.|
|`departure_time`|Time|نعم|وقت انطلاق الرحلة.|
|`departure_date`|Date|نعم|تاريخ انطلاق الرحلة.|
|`expected_duration`|String|اختياري|المدة المتوقعة للرحلة.|
|`cost`|Decimal|نعم|تكلفة الرحلة.|
|`capacity`|Integer|نعم|السعة الكلية للركاب.|
|`available_seats`|Integer|تلقائي|عدد المقاعد المتاحة، ويُحسب من السعة مطروحًا منها الحجوزات بحالتي `pending` و`accepted`.|
|`status`|String|تلقائي|حالة الرحلة.|
|`car_image`|File/Image|تلقائي|صورة سيارة السائق، وتظهر عند عرض رحلات السائق.|
|`driver_name`|String|تلقائي|اسم السائق، ويظهر ضمن تفاصيل الرحلة.|

---

## 2. القيم الثابتة والتعدادات (Enums & Fixed Values)

### `RideStatus` — حالة الرحلة

|القيمة|المعنى|
|---|---|
|`active`|الرحلة فعّالة|
|`completed`|الرحلة مكتملة|
|`cancelled`|الرحلة ملغاة|

---

# 3. جدول مسارات الـ API وطريقة الاستخدام (Endpoints Reference)

### Base URL

```
http://127.0.0.1:8000/api/rides/
```

|   |   |   |   |
|---|---|---|---|
|Endpoint|Method|يتطلب Token؟|الوصف|
|`/create/`|`POST`|نعم|إنشاء رحلة جديدة|
|`/<ride_id>/update/`|`PATCH`|نعم|تعديل رحلة|
|`/<ride_id>/cancel/`|`DELETE`|نعم|إلغاء رحلة|
|`/reservations/<reservation_id>/accept/`|`POST`|نعم|قبول حجز|
|`/reservations/<reservation_id>/reject/`|`POST`|نعم|رفض حجز|
|`/complete_ride/<ride_id>/`|`POST`|نعم|إكمال رحلة|
|`/ride_details/<ride_id>/`|`GET`|نعم|عرض تفاصيل رحلة|
|`/my_rides/`|`GET`|نعم|عرض الرحلات الفعالة الخاصة بالسائق|

---

# 4. إنشاء رحلة

## `POST /create/`

يُستخدم هذا الـ endpoint لإنشاء رحلة جديدة بواسطة السائق.

### Headers

```text
Authorization: Bearer <access_token>
Content-Type: application/json
```

### Request

```json
{
    "location": "Latakia",
    "destination": "Tartous",
    "departure_time": "08:00:00",
    "departure_date": "2026-08-15",
    "expected_duration": "1 hour",
    "cost": "50000.00",
    "capacity": 4
}
```

### Response

**201 Created**

```json
{
    "id": 1,
    "location": "Latakia",
    "destination": "Tartous",
    "departure_time": "08:00:00",
    "departure_date": "2026-08-15",
    "expected_duration": "1 hour",
    "cost": "50000.00",
    "capacity": 4
}
```

### شروط الاستخدام

- يجب أن يكون المستخدم من نوع `driver`.
    
- لا يمكن إنشاء رحلة إذا كان `location` يساوي `destination`.
    
- لا يمكن للسائق إنشاء رحلة أخرى بنفس:
    
    - `location`
        
    - `destination`
        
    - `departure_date`
        
    - `departure_time`
        

### الأخطاء

**403 Forbidden**

```json
{
    "error": "Only drivers can create rides"
}
```

**400 Bad Request**

```json
{
    "destination": "Destination must be different from location."
}
```

أو:

```json
{
    "ride": "You already have a ride with the same information and departure time."
}
```

---

# 5. تعديل رحلة

## `PATCH /<ride_id>/update/`

يُستخدم لتعديل بيانات رحلة يملكها السائق.

### Headers

```text
Authorization: Bearer <access_token>
Content-Type: application/json
```

### Request

يمكن إرسال الحقول المطلوب تعديلها فقط:

```json
{
    "location": "Latakia",
    "destination": "Jableh",
    "departure_time": "09:00:00",
    "departure_date": "2026-08-15",
    "expected_duration": "45 minutes",
    "cost": "40000.00",
    "capacity": 4
}
```

### Response

**200 OK**

```json
{
    "id": 1,
    "location": "Latakia",
    "destination": "Jableh",
    "departure_time": "09:00:00",
    "departure_date": "2026-08-15",
    "expected_duration": "45 minutes",
    "cost": "40000.00",
    "capacity": 4
}
```

### شروط الاستخدام

- يجب أن يكون المستخدم `driver`.
    
- يجب أن تكون الرحلة مملوكة للسائق الحالي.
    
- يجب أن تكون حالة الرحلة `active`.
    
- لا يمكن تعديل الرحلة إذا كان لديها أي حجوزات.
    

### الأخطاء

**403 Forbidden**

```json
{
    "error": "Only drivers can update rides"
}
```

**404 Not Found**

```json
{
    "error": "Ride not found"
}
```

**400 Bad Request**

```json
{
    "error": "Only active rides can be updated"
}
```

أو:

```json
{
    "error": "Cannot update a ride that has reservations"
}
```

---

# 6. إلغاء رحلة

## `DELETE /<ride_id>/cancel/`

يُستخدم لإلغاء رحلة يملكها السائق.

### Headers

```text
Authorization: Bearer <access_token>
```

### Response

**200 OK**

```json
{
    "message": "Ride cancelled successfully"
}
```

### شروط الاستخدام

- يجب أن يكون المستخدم `driver`.
    
- يجب أن تكون الرحلة مملوكة للسائق الحالي.
    
- يجب أن تكون الرحلة بحالة `active`.
    

عند إلغاء الرحلة، يتم تحويل جميع الحجوزات التي حالتها:

```text
pending
accepted
```

إلى:

```text
cancelled
```

### الأخطاء

**403 Forbidden**

```json
{
    "error": "Only drivers can cancel rides"
}
```

**404 Not Found**

```json
{
    "error": "Ride not found"
}
```

**400 Bad Request**

```json
{
    "error": "Only active rides can be cancelled"
}
```

---

# 7. قبول حجز

## `POST /reservations/<reservation_id>/accept/`

يُستخدم من قبل السائق لقبول طلب حجز على إحدى رحلاته.

### Headers

```text
Authorization: Bearer <access_token>
```

### Response

**200 OK**

```json
{
    "message": "Reservation accepted successfully"
}
```

### شروط الاستخدام

- يجب أن يكون المستخدم `driver`.
    
- يجب أن يكون الحجز تابعًا لإحدى رحلات السائق.
    
- يجب أن تكون حالة الحجز `pending`.
    
- عند نجاح العملية تصبح حالة الحجز:
    

```text
accepted
```

### الأخطاء

**403 Forbidden**

```json
{
    "error": "Only drivers can accept reservations"
}
```

أو:

```json
{
    "error": "You can only accept reservations for your rides"
}
```

**404 Not Found**

```json
{
    "error": "Reservation not found"
}
```

**400 Bad Request**

```json
{
    "error": "Only pending reservations can be accepted"
}
```

---

# 8. رفض حجز

## `POST /reservations/<reservation_id>/reject/`

يُستخدم من قبل السائق لرفض طلب حجز على إحدى رحلاته.

### Headers

```text
Authorization: Bearer <access_token>
```

### Response

**200 OK**

```json
{
    "message": "Reservation rejected successfully"
}
```

### شروط الاستخدام

- يجب أن يكون المستخدم `driver`.
    
- يجب أن يكون الحجز تابعًا لإحدى رحلات السائق.
    
- يجب أن تكون حالة الحجز `pending`.
    
- عند نجاح العملية تصبح حالة الحجز:
    

```text
rejected
```

### الأخطاء

**403 Forbidden**

```json
{
    "error": "Only drivers can reject reservations"
}
```

أو:

```json
{
    "error": "You can only reject reservations for your rides"
}
```

**404 Not Found**

```json
{
    "error": "Reservation not found"
}
```

**400 Bad Request**

```json
{
    "error": "Reservation cannot be rejected"
}
```


---

# 9. عرض رحلات السائق

## `GET /my_rides/`

يُستخدم لعرض الرحلات الفعّالة الخاصة بالسائق الحالي.

### Headers

```text
Authorization: Bearer <access_token>
```

### Response

**200 OK**

```json
{
    "rides": [
        {
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
            "car_image": "/media/car_images/car.jpg"
        }
    ]
}
```

### البيانات المعروضة

- معلومات الرحلة.
    
- السعة الكلية.
    
- عدد المقاعد المتاحة.
    
- حالة الرحلة.
    
- صورة سيارة السائق.
    

### ملاحظة

يعرض الـ endpoint فقط الرحلات التي حالتها:

```text
active
```

### الأخطاء

**403 Forbidden**

```json
{
    "error": "Only drivers can access this endpoint"
}
```

**404 Not Found**

```json
{
    "error": "Driver profile not found"
}
```

---

# 10. عرض تفاصيل رحلة

## `GET /ride_details/<ride_id>/`

يُستخدم لعرض تفاصيل رحلة محددة.

### Headers

```text
Authorization: Bearer <access_token>
```

### Response

**200 OK**

```json
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
```

### شروط الاستخدام

هناك حالتان:

#### السائق صاحب الرحلة

يمكنه رؤية تفاصيل رحلته **بغض النظر عن حالة الرحلة**.

أي يمكنه رؤية الرحلة إذا كانت:

```text
active
completed
cancelled
```

#### المستخدم الآخر

إذا لم يكن المستخدم هو سائق الرحلة، فلا يمكنه رؤية الرحلة إلا إذا كانت:

```text
active
```

### الأخطاء

**404 Not Found**

```json
{
    "error": "Ride not found"
}
```

---
## 11. إكمال رحلة
## `POST /complete_ride/<ride_id>/`

يُستخدم هذا الـ endpoint من قبل السائق لإنهاء الرحلة وتحويل إجمالي مبالغ الحجوزات المدفوعة إلى محفظة السائق.

### Headers

```
Authorization: Bearer <access_token>
```

### Request

لا يحتاج هذا الـ endpoint إلى Request Body.

### آلية تنفيذ العملية

عند إكمال الرحلة، يتم تنفيذ العمليات التالية بشكل ذري (Atomic Transaction):

```
Ride = ACTIVE
        ↓
التحقق من السائق وملكية الرحلة
        ↓
جلب الحجوزات المدفوعة
        ↓
حساب إجمالي الأرباح
        ↓
إضافة المبلغ إلى Wallet السائق
        ↓
إنشاء Transaction من نوع EARNING
        ↓
تغيير حالة الرحلة إلى COMPLETED
```

### حساب الأرباح

بما أن الحقل `cost` في `Ride` يمثل **سعر المقعد الواحد**، يتم حساب إجمالي أرباح السائق بناءً على عدد الحجوزات التي تم دفع قيمتها.

مثال:

```
سعر المقعد = 50000

الحجوزات المدفوعة = 3

إجمالي الأرباح = 50000 × 3
               = 150000
```

ويتم إضافة مبلغ `150000` إلى محفظة السائق.

### الحجوزات التي تدخل في حساب الأرباح

يتم احتساب الحجوزات التي تكون حالة الدفع الخاصة بها:

```
paid
```

أما الحجوزات غير المدفوعة فلا تدخل ضمن إجمالي الأرباح.

### Response

**200 OK**

```
{
    "message": "Ride completed successfully",
    "total_earnings": "150000.00",
    "driver_balance": "250000.00"
}
```

حيث:

- `message`: رسالة نجاح إكمال الرحلة.
- `total_earnings`: إجمالي المبلغ الذي حصل عليه السائق من الحجوزات المدفوعة في الرحلة.
- `driver_balance`: الرصيد الجديد في محفظة السائق بعد إضافة الأرباح.

### شروط الاستخدام

- يجب أن يكون المستخدم مصادقًا عليه.
- يجب أن يكون المستخدم من نوع `driver`.
- يجب أن تكون الرحلة موجودة.
- يجب أن تكون الرحلة مملوكة للسائق الحالي.
- يجب أن تكون حالة الرحلة الحالية:

```
active
```

- يتم احتساب أرباح الحجوزات التي تم دفع قيمتها فقط.
- يتم إنشاء Transaction من النوع:

```
earning
```

- يتم إضافة إجمالي الأرباح إلى Wallet السائق.
- عند نجاح العملية تصبح حالة الرحلة:

```
completed
```

### مثال على العملية المالية

قبل إكمال الرحلة:

```
Driver Wallet = 100000
```

وسعر المقعد:

```
Ride.cost = 50000
```

ويوجد 3 حجوزات مدفوعة:

```
Reservation 1 → PAID → 50000
Reservation 2 → PAID → 50000
Reservation 3 → PAID → 50000
```

إجمالي الأرباح:

```
150000
```

بعد إكمال الرحلة:

```
Driver Wallet = 250000
```

ويتم إنشاء معاملة:

```
transaction_type = earning
amount = 150000
```

### الأخطاء

**403 Forbidden**

إذا كان المستخدم ليس سائقًا:

```
{
    "error": "Only drivers can complete rides"
}
```

أو إذا حاول السائق إكمال رحلة لا يملكها:

```
{
    "error": "You are not the driver of this ride"
}
```

**404 Not Found**

إذا لم تكن الرحلة موجودة:

```
{
    "error": "Ride not found"
}
```

**400 Bad Request**

إذا كانت الرحلة ليست بحالة `active`:

```
{
    "error": "Only active rides can be completed"
}
```

### ملاحظة

يتم تنفيذ إضافة الأرباح إلى محفظة السائق وإنشاء معاملة `EARNING` وتغيير حالة الرحلة إلى `COMPLETED` ضمن عملية واحدة باستخدام `transaction.atomic`.

وبذلك، في حال حدوث خطأ أثناء العملية، يتم التراجع عن جميع التغييرات المالية وتغيير حالة الرحلة.

بعد إكمال الرحلة تصبح حالتها:

```
completed
```

وبالتالي لا يمكن إكمالها مرة أخرى، كما لا يمكن تنفيذ العمليات المخصصة للرحلات الفعالة عليها مثل التعديل أو الإلغاء.

___
# 12. الصلاحيات العامة (Permissions)

جميع APIs الخاصة بالسائق هي APIs محمية وتتطلب:

```text
Authorization: Bearer <access_token>
```

ويجب أن يكون المستخدم مصادقًا عليه وأن يكون حسابه فعالًا.

بالإضافة إلى ذلك، يتم التحقق من نوع المستخدم داخل كل API:

```text
user_type = driver
```

ولا يمكن لسائق تعديل أو إكمال رحلة أو قبول أو رفض بيانات تخص مستخدمًا أو رحلة لا يملكها.