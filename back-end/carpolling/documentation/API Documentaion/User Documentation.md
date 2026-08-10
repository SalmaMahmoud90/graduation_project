## 1. جدول حقول البيانات والمعاني (Fields Dictionary)

| اسم الحقل (Field)  | نوع البيانات | إجباري؟ | الوصف والشروط                                      |
| ------------------ | ------------ | ------- | -------------------------------------------------- |
| `name`             | String       | نعم     | اسم المستخدم، والحد الأقصى 15 حرفًا حسب الـ Model. |
| `phone`            | String       | اختياري | رقم هاتف المستخدم، ويجب أن يكون فريدًا عند إدخاله. |
| `profile_picture`  | File/Image   | اختياري | صورة الملف الشخصي للمستخدم.                        |
| `car_model`        | String       | اختياري | موديل سيارة السائق.                                |
| `car_color`        | String       | اختياري | لون سيارة السائق.                                  |
| `car_number`       | String       | اختياري | رقم لوحة السيارة.                                  |
| `car_image`        | File/Image   | اختياري | صورة سيارة السائق.                                 |
| `current_location` | String       | اختياري | الموقع الحالي للراكب.                              |
| `created_at`       | DateTime     | تلقائي  | تاريخ إنشاء حساب المستخدم.                         |
| `updated_at`       | DateTime     | تلقائي  | تاريخ آخر تعديل على بيانات المستخدم.               |


___
### 2 . القيم الثابتة والتعدادات (Enums & Fixed Values)

### `UserType` — نوع الحساب

القيم المدعومة في النظام:

|القيمة|المعنى|
|---|---|
|`driver`|حساب سائق|
|`rider`|حساب راكب|
|`admin`|حساب مدير النظام|

> **ملاحظة مهمة:** حاليًا الـ API يسمح بإرسال `admin` في التسجيل، ولكن الـ Serializer يتحقق من أن البريد وكلمة المرور يطابقان القيم الموجودة في `ADMIN_EMAIL` و `ADMIN_PASSWORD` داخل `settings.py`.

 
### 3.جدول مسارات الـ API وطريقة الاستخدام (Endpoints Reference)

### Base URL

```
http://127.0.0.1:8000/api/users
```

|Endpoint|Method|يتطلب Token؟|الوصف|
|---|---|---|---|
|`/view_profile/`|`GET`|نعم|عرض الملف الشخصي|
|`/update_driver_profile/`|`PATCH`|نعم|تعديل ملف السائق|
|`/update_rider_profile/`|`PATCH`|نعم|تعديل ملف الراكب|

### 4. عرض الملف الشخصي

## `GET /view_profile/`

### Headers

```
Authorization: Bearer <access_token>
```

### Driver Response

**200 OK**

```
{
    "user": {
        "name": "Ahmad",
        "created_at": "2026-08-07T10:30:00Z",
        "phone": "0991234567",
        "profile_picture": "/media/profiles/2026/08/07/profile.jpg"
    },
    "car_model": "Toyota Corolla",
    "car_number": "123456",
    "car_color": "White",
    "car_image": "/media/car_images/car.jpg"
}
```

### Rider Response

**200 OK**

```
{
    "user": {
        "name": "Sara",
        "created_at": "2026-08-07T10:30:00Z",
        "phone": "0991234567",
        "profile_picture": "/media/profiles/2026/08/07/profile.jpg"
    },
    "current_location": "Latakia"
}
```

---

# 16. تعديل ملف السائق

## `PATCH /update_driver_profile/`

### Headers

```
Authorization: Bearer <access_token>
Content-Type: multipart/form-data
```

### Request

```
{
    "name": "Ahmad Ali",
    "phone": "0991234567",
    "car_model": "Toyota Corolla",
    "car_number": "123456",
    "car_color": "White"
}
```

### Response

**200 OK**

```
{
    "user": {
        "name": "Ahmad Ali",
        "created_at": "2026-08-07T10:30:00Z",
        "phone": "0991234567",
        "profile_picture": null
    },
    "car_model": "Toyota Corolla",
    "car_number": "123456",
    "car_color": "White",
    "car_image": null
}
```

هذا الـ endpoint متاح فقط للمستخدم الذي:

```
user_type = driver
```

---

# 17. تعديل ملف الراكب

## `PATCH /update_rider_profile/`

### Headers

```
Authorization: Bearer <access_token>
Content-Type: multipart/form-data
```

### Request

```
{
    "name": "Sara Ali",
    "phone": "0991234567",
    "current_location": "Latakia"
}
```

### Response

**200 OK**

```
{
    "user": {
        "name": "Sara Ali",
        "created_at": "2026-08-07T10:30:00Z",
        "phone": "0991234567",
        "profile_picture": null
    },
    "current_location": "Latakia"
}
```

هذا الـ endpoint متاح فقط للمستخدم الذي:

```
user_type = rider
```

---
# 19. الهيدرز الشاملة (Headers)
## Protected APIs

هذه تحتاج OAuth Access Token:

```
GET /view_profile/
PATCH /update_driver_profile/
PATCH /update_rider_profile/
```

# 22. User Profile Structure

العلاقة بين الـ Models:

```
                    MainUser
                       │
          ┌────────────┼────────────┐
          │            │            │
          ▼            ▼            ▼
       Driver        Rider       AppAdmin
          │            │
          ▼            ▼
      Car Info    Current Location
```

## MainUser

```
MainUser
 ├── email
 ├── name
 ├── phone
 ├── profile_picture
 ├── user_type
 ├── is_staff
 ├── is_active
 ├── created_at
 └── updated_at