## Authentication API Documentation

## 1. جدول حقول البيانات والمعاني (Fields Dictionary)

| اسم الحقل (Field)  | نوع البيانات   | إجباري؟                                 | الوصف والشروط                                                                                                                                       |
| ------------------ | -------------- | --------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| `email`            | String (Email) | **نعم**                                 | البريد الإلكتروني للمستخدم، ويجب أن يكون بصيغة Email صحيحة وفريدًا في النظام.                                                                       |
| `password`         | String         | **نعم**                                 | كلمة مرور المستخدم. يتم تخزينها باستخدام Django Password Hashing.                                                                                   |
| `confirm_password` | String         | **نعم**                                 | تأكيد كلمة المرور، ويجب أن تتطابق مع `password` أثناء التسجيل.                                                                                      |
| `new_password`     | String         | **نعم**                                 | كلمة المرور الجديدة أثناء إعادة تعيين كلمة المرور، والحد الأدنى 8 أحرف.                                                                             |
| `user_type`        | String (Enum)  | **نعم**                                 | نوع الحساب: `driver` أو `rider` أو `admin`.                                                                                                         |
| `name`             | String         | نعم                                     | اسم المستخدم، والحد الأقصى 15 حرفًا حسب الـ Model.                                                                                                  |
| `phone`            | String         | اختياري                                 | رقم هاتف المستخدم، ويجب أن يكون فريدًا عند إدخاله.                                                                                                  |
| `profile_picture`  | File/Image     | اختياري                                 | صورة الملف الشخصي للمستخدم.                                                                                                                         |
| `code`             | String         | **نعم** في عمليات التحقق                | رمز تحقق مكوّن من 6 أرقام. يستخدم للتحقق من البريد أو إعادة تعيين كلمة المرور.                                                                      |
| `reset_token`      | String         | **تلقائي من النظام**                    | Tokenعشوائي مؤقت يتم إنشاؤه بواسطة Backend لربط طلب إعادة تعيين كلمة المرور بالمستخدم، ويُعاد إلى Frontend ليتم إرساله تلقائيًا في الخطوات التالية. |
| `expires_at`       | DateTime       | تلقائي                                  | وقت انتهاء صلاحية رمز التحقق، ويتم ضبطه تلقائيًا على 10 دقائق.                                                                                      |
| `is_verified`      | Boolean        | تلقائي                                  | يحدد ما إذا كان رمز إعادة تعيين كلمة المرور قد تم التحقق منه بنجاح.                                                                                 |
| `is_active`        | Boolean        | تلقائي، ويتم تغييرها من النظام/الإدارة. | يحدد ما إذا كان الحساب فعالًا أو محظورًا.                                                                                                           |
| `car_model`        | String         | اختياري                                 | موديل سيارة السائق.                                                                                                                                 |
| `car_color`        | String         | اختياري                                 | لون سيارة السائق.                                                                                                                                   |
| `car_number`       | String         | اختياري                                 | رقم لوحة السيارة.                                                                                                                                   |
| `car_image`        | File/Image     | اختياري                                 | صورة سيارة السائق.                                                                                                                                  |
| `current_location` | String         | اختياري                                 | الموقع الحالي للراكب.                                                                                                                               |
| `access_token`     | String         | تلقائي                                  | Access Token يتم إصداره بواسطة OAuth عند تسجيل الدخول بنجاح.                                                                                        |
| `refresh_token`    | String         | تلقائي                                  | Refresh Token المرتبط بجلسة OAuth ويستخدم لتجديد Access Token.                                                                                      |
| `token_type`       | String         | تلقائي                                  | نوع الـ Token الصادر من OAuth، وعادةً `Bearer`.                                                                                                     |
| `expires_in`       | Integer        | تلقائي                                  | مدة صلاحية Access Token بالثواني حسب إعدادات OAuth.                                                                                                 |

---
# 2. القيم الثابتة والتعدادات (Enums & Fixed Values)

### `UserType` — نوع الحساب

القيم المدعومة في النظام:

|القيمة|المعنى|
|---|---|
|`driver`|حساب سائق|
|`rider`|حساب راكب|
|`admin`|حساب مدير النظام|

> **ملاحظة مهمة:** حاليًا الـ API يسمح بإرسال `admin` في التسجيل، ولكن الـ Serializer يتحقق من أن البريد وكلمة المرور يطابقان القيم الموجودة في `ADMIN_EMAIL` و `ADMIN_PASSWORD` داخل `settings.py`.


### `VerificationCode`

- يتكون من 6 أرقام ويتم توليده تلقائيًا بواسطة Backend.
- مدة صلاحيته **10 دقائق**.
- عند إعادة الإرسال يتم إنشاء Code جديد وإلغاء صلاحية القديم.

## Password Reset Status

جدول `PasswordResetCode` يحتوي على:

```
is_verified
```

|   |   |
|---|---|
|القيمة|المعنى|
|`false`|رمز إعادة تعيين كلمة المرور لم يتم التحقق منه بعد.|
|`true`|رمز إعادة تعيين كلمة المرور تم التحقق منه، ويمكن تعيين كلمة مرور جديدة.|

بعد نجاح إعادة تعيين كلمة المرور يتم حذف سجل `PasswordResetCode`.

### Account Status

النظام يستخدم حاليًا الحقل:

```
is_active
```

|القيمة|المعنى|
|---|---|
|`true`|الحساب فعال|
|`false`|الحساب محظور / غير فعال|

أما حالة التحقق من البريد  الحساب يعتبر غير موثق إذا كان له سجل في جدول `EmailVerification`، ويتم اعتباره موثقًا بعد حذف سجل التحقق بنجاح.

---# 3. جدول مسارات الـ API وطريقة الاستخدام (Endpoints Reference)

Base URL:

```
http://127.0.0.1:8000/api/users
```

|                           |         |              |                                                    |
| ------------------------- | ------- | ------------ | -------------------------------------------------- |
| Endpoint                  | Method  | يتطلب Token؟ | الوصف                                              |
| `/create/`                | `POST`  | لا           | إنشاء حساب جديد                                    |
| `/verify_email/`          | `POST`  | لا           | التحقق من البريد الإلكتروني                        |
| `/resend-verification/`   | `POST`  | لا           | إعادة إرسال رمز التحقق                             |
| `/login/`                 | `POST`  | لا           | تسجيل الدخول والحصول على OAuth Tokens              |
| `/forgot_password/`       | `POST`  | لا           | إرسال رمز إعادة تعيين كلمة المرور                  |
| `/verify_reset_code/`     | `POST`  | لا           | التحقق من رمز إعادة تعيين كلمة المرور              |
| `/reset_password/`        | `POST`  | لا           | تعيين كلمة مرور جديدة                              |
| `/view_profile/`          | `GET`   | **نعم**      | عرض الملف الشخصي                                   |
| `/update_driver_profile/` | `PATCH` | **نعم**      | تعديل ملف السائق                                   |
| `/update_rider_profile/`  | `PATCH` | **نعم**      | تعديل ملف الراكب                                   |
| `/logout/`                | `POST`  | **نعم**      | تسجيل خروج المستخدم وإلغاء صلاحية الـ OAuth Token. |

---

# 4. نماذج JSON جاهزة للنسخ والاستخدام (Full JSON Payloads)

## أ. إنشاء حساب جديد

### `POST /create/`

### Request

#### Driver

```
{
    "email": "driver@example.com",
    "name": "example",
    "password": "StrongPassword123!",
    "confirm_password": "StrongPassword123!",
    "user_type": "driver"
}
```

#### Rider

```
{
    "email": "rider@example.com",
    "name": "example",
    "password": "StrongPassword123!",
    "confirm_password": "StrongPassword123!",
    "user_type": "rider"
}
```

#### Admin

```
{
    "email": "admin@hopon.com",
    "name": "admin",
    "password": "12345",
    "confirm_password": "12345",
    "user_type": "admin"
}
```

### Response — Driver/Rider

**201 Created**

```
{
    "message": "Account created successfully. Please check your email for the verification code.",
    "email": "driver@example.com"
}
```

### Response — Admin

**201 Created**

```
{
    "message": "Admin account created successfully.",
    "user": {
        "email": "admin@hopon.com",
        "name": admin,
        "user_type": "admin"
    }
}
```

### ملاحظة

عند إنشاء `driver` يتم إنشاء Driver Profile تلقائيًا:

```
MainUser
   │
   └── Driver
```

وعند إنشاء `rider`:

```
MainUser
   │
   └── Rider
```

وعند إنشاء `admin`:

```
MainUser
   │
   └── AppAdmin
```

---

# 5. التحقق من البريد الإلكتروني

## `POST /verify_email/`

هذا الـ endpoint يستخدم بعد التسجيل للحسابات العادية.

### Request

```
{
    "email": "driver@example.com",
    "code": "123456"
}
```

### Response — Success

**200 OK**

```
{
    "message": "Email verified successfully."
}
```
عند نجاح التحقق يتم حذف سجل `EmailVerification`.

### حالات الخطأ

#### رمز غير صحيح

**400 Bad Request**

```
{
    "error": "Invalid verification code."
}
```

#### الرمز منتهي الصلاحية

**400 Bad Request**

```
{
    "error": "Verification code expired."
}
```

#### لا يوجد طلب تحقق

**404 Not Found**

```
{
    "error": "Verification request not found."
}
```

---

# 6. إعادة إرسال رمز التحقق

## `POST /resend-verification/`

### Request

```
{
    "email": "driver@example.com"
}
```

### Response

**200 OK**

```
{
    "message": "A new verification code has been sent to your email."
}
```

### إذا كان المستخدم غير موجود

**404 Not Found**

```
{
    "error": "User not found."
}
```

### إذا كان البريد موثقًا مسبقًا

**400 Bad Request**

```
{
    "error": "Email is already verified."
}
```

---

# 7. تسجيل الدخول

## `POST /login/`

### Request

```
{
    "email": "driver@example.com",
    "password": "StrongPassword123!"
}
```

### Response — Success

الـ Login يستدعي OAuth Token Endpoint، لذلك الـ response الفعلي يعتمد أيضًا على إعدادات OAuth.

مثال:

```
{
    "access_token": "ACCESS_TOKEN",
    "refresh_token": "REFRESH_TOKEN",
    "token_type": "Bearer",
    "expires_in": 36000,
    "user": {
        "email": "driver@example.com",
        "name": "Ahmad",
        "user_type": "driver"
    }
}
```

### إذا لم يتم التحقق من البريد

**403 Forbidden**

```
{
    "error": "Please verify your email first."
}
```

### إذا كان الحساب محظورًا

**403 Forbidden**

```
{
    "error": "Your account has been blocked."
}
```



التدفق الحالي هو:

```
Register
   ↓
Send Email Verification Code
   ↓
Verify Email
   ↓
Login
   ↓
OAuth Access + Refresh Tokens
```

---
## OAuth Token Management

### Access Token
يستخدم للوصول إلى Protected APIs:

Authorization: Bearer <access_token>

تحدد مدة صلاحيته بواسطة expires_in.

### Refresh Token
يتم إصداره مع Access Token حسب إعدادات OAuth2.

عند انتهاء Access Token، يمكن استخدام Refresh Token
للحصول على Access Token جديد من OAuth2 Token Endpoint.

لا يوجد Endpoint مخصص للـ Refresh Token ضمن User API.

مثال:

grant_type=refresh_token
refresh_token=<REFRESH_TOKEN>

# 8. نسيت كلمة المرور

## `POST /forgot_password/`

يستخدم هذا الـ endpoint عندما يضغط المستخدم على:

```
Forgot Password
```

ويظهر له حقل البريد الإلكتروني.

### Request

```
{
    "email": "driver@example.com"
}
```

يقوم الـ Backend بـ:

1. البحث عن المستخدم باستخدام البريد الإلكتروني.
2. حذف أي Password Reset Request قديم.
3. إنشاء Code جديد مكون من 6 أرقام.
4. إنشاء `reset_token` عشوائي.
5. ضبط مدة الصلاحية على 10 دقائق.
6. إرسال Code إلى البريد الإلكتروني.
7. إعادة `email` و `reset_token` للـ Frontend.

### Response

**200 OK**

```
{
    "message": "Password reset code sent successfully.",
    "email": "driver@example.com",
    "reset_token": "random-secure-reset-token"
}
```

### ملاحظة مهمة

المستخدم يدخل البريد **مرة واحدة فقط** في صفحة Forgot Password.

بعد الانتقال إلى صفحة Verify Code، لا يحتاج المستخدم إلى إدخال البريد مرة أخرى.

الـ Frontend يحتفظ بـ:

```
reset_token
```

ويرسله تلقائيًا مع Code.

### إذا كان المستخدم غير موجود

**404 Not Found**

```
{
    "error": "User not found."
}
```

---

# 9. التحقق من رمز إعادة تعيين كلمة المرور

## `POST /verify_reset_code/`

هذه هي الصفحة الثانية في Password Reset Flow.

### ما يدخله المستخدم

المستخدم يدخل **الكود فقط**:

```
[ 1 2 3 4 5 6 ]
```

### ما يرسله Frontend

الـ Frontend يرسل `reset_token` تلقائيًا مع الكود:

```
{
    "reset_token": "random-secure-reset-token",
    "code": "123456"
}
```

> `reset_token` ليس شيئًا يكتبه المستخدم، وإنما يتم إرساله تلقائيًا من التطبيق.

### Response — Success

**200 OK**

```
{
    "message": "Verification code verified successfully."
}
```

عند نجاح التحقق:

```
is_verified = true
```

في جدول `PasswordResetCode`.

### Reset Token غير صحيح

**404 Not Found**

```
{
    "error": "Invalid reset request."
}
```

### Code منتهي الصلاحية

**400 Bad Request**

```
{
    "error": "Verification code expired."
}
```

### Code غير صحيح

**400 Bad Request**

```
{
    "error": "Invalid verification code."
}
```

### Verification Flow

```
Forgot Password
      ↓
Email + Reset Token
      ↓
Send Code
      ↓
Verify Code Page
      ↓
User enters Code only
      ↓
Flutter sends Code + Reset Token
      ↓
Backend verifies Code
      ↓
is_verified = true
```

---

# 10. إعادة تعيين كلمة المرور

## `POST /reset_password/`

يستخدم هذا الـ endpoint بعد نجاح التحقق من Code.

### Request

```
{
    "reset_token": "random-secure-reset-token",
    "new_password": "NewStrongPassword123!",
    "confirm_password": "NewStrongPassword123!"
}
```

المستخدم في هذه الصفحة يدخل:

```
New Password
Confirm Password
```

والـ Frontend يرسل `reset_token` تلقائيًا.

### Response — Success

**200 OK**

```
{
    "message": "Password reset successfully."
}
```

عند نجاح العملية:

1. يتم الحصول على المستخدم المرتبط بالـ `reset_token`.
2. يتم تعيين كلمة المرور الجديدة باستخدام Django `set_password()`.
3. يتم حفظ المستخدم.
4. يتم حذف سجل `PasswordResetCode`.

### كلمة المرور غير متطابقة

**400 Bad Request**

```
{
    "confirm_password": [
        "Passwords do not match."
    ]
}
```

### Reset Token غير صحيح

**404 Not Found**

```
{
    "error": "Invalid reset request."
}
```

### انتهت صلاحية طلب Reset

**400 Bad Request**

```
{
    "error": "Reset request expired."
}
```

### لم يتم التحقق من Code

**400 Bad Request**

```
{
    "error": "Please verify the reset code first."
}
```

---

# 11. Password Reset Workflow

الـ Flow الكامل لإعادة تعيين كلمة المرور:

```
                 Forgot Password
                       │
                       ▼
                 Enter Email
                       │
                       ▼
          POST /forgot_password/
                       │
                       ▼
              Generate OTP Code
                       │
                       ▼
             Generate Reset Token
                       │
                       ▼
                Send Code Email
                       │
                       ▼
              Verify Code Page
                       │
                       ▼
              User enters Code
                       │
                       ▼
     Flutter sends Code + Reset Token
                       │
                       ▼
        POST /verify_reset_code/
                       │
                       ▼
             is_verified = true
                       │
                       ▼
             New Password Page
                       │
                       ▼
       POST /reset_password/
                       │
                       ▼
              Set New Password
                       │
                       ▼
              Delete Reset Code
                       │
                       ▼
            Password Reset Done
```

### تجربة المستخدم الفعلية

```
1. Forgot Password

Email:
[ driver@example.com ]

        ↓

2. Verify Code

We sent a code to:
driver@example.com

Code:
[ _ _ _ _ _ _ ]

        ↓

3. Create New Password

New Password:
[ ******** ]

Confirm Password:
[ ******** ]

        ↓

Password Reset Successfully
```

---

# 12. عرض الملف الشخصي

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

# 13. تعديل ملف السائق

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
    "email": "ahmad@example.com",
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

# 14. تعديل ملف الراكب

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
    "email": "sara@example.com",
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

# 15. تسجيل الخروج

## `POST /logout/`

### Headers

```
Authorization: Bearer <access_token>
```

### Response

**200 OK**

```
{
    "detail": "Successfully logged out."
}
```
---

# 16. الهيدرز الشاملة (Headers)

## Public APIs

لا تحتاج إلى Access Token:

```
POST /create/
POST /verify_email/
POST /resend-verification/
POST /login/
POST /forgot_password/
POST /verify_reset_code/
POST /reset_password/
```

Header:

```
Content-Type: application/json
```

---

## Protected APIs

هذه تحتاج OAuth Access Token:

```
GET /view_profile/
PATCH /update_driver_profile/
PATCH /update_rider_profile/
POST /logout/
```

Header:

```
Authorization: Bearer <access_token>
```

ومع JSON:

```
Content-Type: multipart/form-data
```

---

# 17. Authentication Endpoints Summary

|                   |                              |                                                 |
| ----------------- | ---------------------------- | ----------------------------------------------- |
| المرحلة           | Endpoint                     | البيانات التي يدخلها المستخدم                   |
| Register          | `POST /create/`              | Email + Password + Confirm Password + User Type |
| Verify Email      | `POST /verify_email/`        | Email + Code                                    |
| Resend Email Code | `POST /resend-verification/` | Email                                           |
| Login             | `POST /login/`               | Email + Password                                |
| Forgot Password   | `POST /forgot_password/`     | **Email**                                       |
| Verify Reset Code | `POST /verify_reset_code/`   | **Code فقط**                                    |
| Reset Password    | `POST /reset_password/`      | **New Password + Confirm Password**             |
| Logout            | `POST /logout/`              | لا شيء، Token بالـ Header                       |

### ملاحظة مهمة على Verify Reset Code

من ناحية **واجهة المستخدم**:

```
المستخدم يدخل:
Code فقط
```

لكن من ناحية **Request الذي يرسله Flutter**:

```
{
    "reset_token": "....",
    "code": "123456"
}
```

لأن `reset_token` يتم تمريره تلقائيًا من التطبيق وليس من المستخدم.

---
# 18. Authentication Workflow الكامل

```
                         REGISTER
                            │
                            ▼
                    POST /create/
                            │
              ┌─────────────┴─────────────┐
              │                           │
           Driver/Rider                  Admin
              │                           │
              ▼                           ▼
       Email Verification            Account Created
              │
              ▼
      POST /verify_email/
              │
              ▼
          Email Verified
              │
              ▼
          POST /login/
              │
              ▼
      OAuth Access Token
      OAuth Refresh Token
              │
              ▼
         Authenticated
```

## Password Reset

```
                 FORGOT PASSWORD
                       │
                       ▼
             POST /forgot_password/
                       │
                       ▼
                Enter Email
                       │
                       ▼
             Send 6-digit Code
                       │
                       ▼
             Generate Reset Token
                       │
                       ▼
               VERIFY CODE
                       │
                       ▼
          User enters Code only
                       │
                       ▼
      Flutter sends Code + Reset Token
                       │
                       ▼
          POST /verify_reset_code/
                       │
                       ▼
             is_verified = true
                       │
                       ▼
             RESET PASSWORD
                       │
                       ▼
          POST /reset_password/
                       │
                       ▼
              New Password
                       │
                       ▼
            Password Changed
                       │
                       ▼
             Delete Reset Record
```

---

# 19. User Profile Structure

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
 ├── password
 ├── name
 ├── phone
 ├── profile_picture
 ├── user_type
 ├── is_staff
 ├── is_active
 ├── created_at
 └── updated_at
```

## EmailVerification

```
EmailVerification
 ├── user
 ├── code
 └── expires_at
```

## PasswordResetCode

```
PasswordResetCode
 ├── user
 ├── reset_token
 ├── code
 ├── expires_at
 └── is_verified
```

---

# 20. Authentication Data Flow

```
MainUser
   │
   ├── Email Verification
   │      └── EmailVerification
   │             ├── code
   │             └── expires_at
   │
   └── Password Reset
          └── PasswordResetCode
                 ├── reset_token
                 ├── code
                 ├── expires_at
                 └── is_verified
```

بهذا الشكل أصبح توثيق الـ Authentication متطابقًا مع الـ APIs الموجودة حاليًا في المشروع، بما فيها **Register, Email Verification, Login, Forgot Password, Verify Reset Code, Reset Password, Logout, Profile**.