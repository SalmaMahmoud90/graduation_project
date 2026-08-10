## Authentication API Documentation

## 1. جدول حقول البيانات والمعاني (Fields Dictionary)

| اسم الحقل (Field)  | نوع البيانات   | إجباري؟                  | الوصف والشروط                                                                                                                                       |
| ------------------ | -------------- | ------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| `email`            | String (Email) | **نعم**                  | البريد الإلكتروني للمستخدم، ويجب أن يكون بصيغة Email صحيحة وفريدًا في النظام.                                                                       |
| `password`         | String         | **نعم**                  | كلمة مرور المستخدم. يتم تخزينها باستخدام Django Password Hashing.                                                                                   |
| `confirm_password` | String         | **نعم**                  | تأكيد كلمة المرور، ويجب أن تتطابق مع `password` أثناء التسجيل.                                                                                      |
| `new_password`     | String         | **نعم**                  | كلمة المرور الجديدة أثناء إعادة تعيين كلمة المرور، والحد الأدنى 8 أحرف.                                                                             |
| `user_type`        | String (Enum)  | **نعم**                  | نوع الحساب: `driver` أو `rider` أو `admin`.                                                                                                         |
| `name`             | String         | نعم                      | اسم المستخدم، والحد الأقصى 15 حرفًا حسب الـ Model.                                                                                                  |
| `code`             | String         | **نعم** في عمليات التحقق | رمز تحقق مكوّن من 6 أرقام. يستخدم للتحقق من البريد أو إعادة تعيين كلمة المرور.                                                                      |
| `reset_token`      | String         | **تلقائي من النظام**     | Tokenعشوائي مؤقت يتم إنشاؤه بواسطة Backend لربط طلب إعادة تعيين كلمة المرور بالمستخدم، ويُعاد إلى Frontend ليتم إرساله تلقائيًا في الخطوات التالية. |
| `expires_at`       | DateTime       | تلقائي                   | وقت انتهاء صلاحية رمز التحقق، ويتم ضبطه تلقائيًا على 10 دقائق.                                                                                      |
| `is_verified`      | Boolean        | تلقائي                   | يحدد ما إذا كان رمز إعادة تعيين كلمة المرور قد تم التحقق منه بنجاح.                                                                                 |
| `access_token`     | String         | تلقائي                   | Access Token يتم إصداره بواسطة OAuth عند تسجيل الدخول بنجاح.                                                                                        |
| `refresh_token`    | String         | تلقائي                   | Refresh Token المرتبط بجلسة OAuth ويستخدم لتجديد Access Token.                                                                                      |
| `token_type`       | String         | تلقائي                   | نوع الـ Token الصادر من OAuth، وعادةً `Bearer`.                                                                                                     |
| `expires_in`       | Integer        | تلقائي                   | مدة صلاحية Access Token بالثواني حسب إعدادات OAuth.                                                                                                 |

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

---
# 3. جدول مسارات الـ API وطريقة الاستخدام (Endpoints Reference)

### Base URL

```
http://127.0.0.1:8000/api/users
```

|                           |         |              |                                               |
| ------------------------- | ------- | ------------ | --------------------------------------------- |
| Endpoint                  | Method  | يتطلب Token؟ | الوصف                                         |
| `/create/`                | `POST`  | لا           | إنشاء حساب جديد                               |
| `/verify_email/`          | `POST`  | لا           | التحقق من البريد الإلكتروني                   |
| `/resend-verification/`   | `POST`  | لا           | إعادة إرسال رمز التحقق للبريد                 |
| `/login/`                 | `POST`  | لا           | تسجيل الدخول والحصول على OAuth Tokens         |
| `/forgot_password/`       | `POST`  | لا           | إنشاء طلب إعادة تعيين وإرسال رمز التحقق       |
| `/resend_reset_code/`     | `POST`  | لا           | إعادة إرسال رمز إعادة تعيين كلمة المرور       |
| `/verify_reset_code/`     | `POST`  | لا           | التحقق من رمز إعادة تعيين كلمة المرور         |
| `/reset_password/`        | `POST`  | لا           | تعيين كلمة مرور جديدة                         |
| `/logout/`                | `POST`  | **نعم**      | تسجيل خروج المستخدم وإلغاء صلاحية OAuth Token |

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

### ملاحظة — انتقال البريد من Register إلى Verify Email

بعد نجاح إنشاء الحساب باستخدام:

```text
POST /create/
```

يعيد الـ API البريد الإلكتروني في الـ response:

```json
{
    "message": "Account created successfully. Please check your email for the verification code.",
    "email": "driver@example.com"
}
```

يحتفظ Flutter بهذا البريد الإلكتروني لاستخدامه في خطوة التحقق التالية.

في صفحة **Verify Email**، المستخدم يحتاج إلى إدخال **رمز التحقق فقط**.

عند إرسال رمز التحقق، يقوم Flutter بإرسال البريد الإلكتروني المحفوظ تلقائيًا مع الرمز:

```json
{
    "email": "driver@example.com",
    "code": "123456"
}
```

لذلك:

- **المستخدم:** يدخل `code` فقط.
    
- **Flutter:** يرسل `email + code`.
    
- **Backend:** يستخدم `email` لتحديد المستخدم والتحقق من `code`.
    

ولا يحتاج المستخدم إلى إعادة كتابة البريد الإلكتروني في صفحة التحقق.
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
## 8. OAuth Token Management

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

# 9. نسيت كلمة المرور

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
# 10. إعادة إرسال رمز إعادة تعيين كلمة المرور

## `POST /resend_reset_code/`

يستخدم هذا الـ endpoint عندما يضغط المستخدم على:

```
Resend Code
```

في صفحة التحقق من رمز إعادة تعيين كلمة المرور.

### Request

لا يحتاج المستخدم إلى إدخال البريد الإلكتروني مرة أخرى.

يقوم Flutter بإرسال `reset_token` الذي حصل عليه من:

```
POST /forgot_password/
```

أو من طلب إعادة الإرسال السابق.

```
{
    "reset_token": "random-secure-reset-token"
}
```
### ماذا يفعل Backend؟

عند استدعاء الـ endpoint:

1. يبحث عن طلب إعادة تعيين كلمة المرور باستخدام `reset_token`.
2. يتحقق من أن طلب إعادة التعيين لم تنتهِ صلاحيته.
3. ينشئ **رمز تحقق جديدًا مكونًا من 6 أرقام**.
4. يمدد صلاحية طلب إعادة التعيين لمدة 10 دقائق.
5. يعيد `is_verified` إلى `false`.
6. يحافظ على **نفس** `**reset_token**`.
7. يرسل رمز التحقق الجديد إلى البريد الإلكتروني المرتبط بطلب إعادة التعيين.

### Response — Success

**200 OK**

```
{
    "message": "A new password reset code has been sent successfully."
}
```

### مهم جدًا

عند إعادة إرسال الرمز:

```
Old Code      → Invalid
New Code → Valid

Reset Token → SAME
```

أي أن:

> **Resend Reset Code لا ينشئ Reset Token جديدًا.**

الـ `reset_token` يبقى نفسه طوال طلب إعادة تعيين كلمة المرور الحالي.

الذي يتغير فقط هو:

```
code
expires_at
is_verified
```

بحيث تصبح:

```
Old Code
   ↓
Invalid

New Code
   ↓
Valid

Same Reset Token
   ↓
Still Valid
```

لذلك يجب على Flutter الاحتفاظ بنفس `reset_token` وعدم استبداله.
### إذا كان Reset Token غير صحيح

**404 Not Found**

```
{
    "error": "Invalid reset request."
}
```
### ملاحظة مهمة

إذا انتهت صلاحية `reset_token`، يجب على المستخدم العودة إلى:

```
Forgot Password
```

وإدخال البريد الإلكتروني من جديد، ثم استدعاء:

```
POST /forgot_password/
```

لإنشاء **Reset Token جديد** وطلب Reset جديد.

___

# 11. التحقق من رمز إعادة تعيين كلمة المرور

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


---

# 12. إعادة تعيين كلمة المرور

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

# 13. Password Reset Workflow

الـ Flow الكامل لإعادة تعيين كلمة المرور:
                  FORGOT PASSWORD
                        │
                        ▼
              Enter Email
                        │
                        ▼
          POST /forgot_password/
                        │
                        ▼
              Generate Code
                        │
                        ▼
          Generate Reset Token
                        │
                        ▼
             Send Code by Email
                        │
                        ▼
              Verify Code Page
                        │
               ┌────────┴────────┐
               │                 │
          Enter Code        Resend Code
               │                 │
               │                 ▼
               │       POST /resend_reset_code/
               │                 │
               │          Same Reset Token
               │                 │
               │          New Code
               │                 │
               │                 ▼
               │          Send New Code
               │                 │
               └────────────► Verify Code
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
                      Delete Reset Record
                                  │
                                  ▼
                       Password Reset Done
---

# 14. تجربة المستخدم الفعلية

## 1. Forgot Password

```
Email:
[ driver@example.com ]

        ↓
```

## 2. Verify Code

```
We sent a code to:
driver@example.com

Code:
[ _ _ _ _ _ _ ]

        ↓

Didn't receive the code?

[ Resend Code ]
```

عند الضغط على `Resend Code`:

```
Flutter
   ↓
POST /resend_reset_code/
   ↓
Backend generates new Code
   ↓
Email sent
   ↓
Flutter replaces old Reset Token
```

ثم المستخدم يدخل الـ Code الجديد.

## 3. Create New Password

```
New Password:
[ ******** ]

Confirm Password:
[ ******** ]

        ↓
```

## 4. Success

```
Password Reset Successfully
```




# 18. تسجيل الخروج

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

# 19. الهيدرز الشاملة (Headers)

## Public APIs

لا تحتاج إلى Access Token:

```
POST /create/
POST /verify_email/
POST /resend-verification/
POST /login/
POST /forgot_password/
POST /resend_reset_code/
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

POST /logout/
```

Header:

```
Authorization: Bearer <access_token>
```

ومع JSON:

```
Content-Type: application/json
```

---



# 20. Authentication Endpoints Summary

|                   |                              |                                                              |
| ----------------- | ---------------------------- | ------------------------------------------------------------ |
| المرحلة           | Endpoint                     | البيانات التي يدخلها المستخدم                                |
| Register          | `POST /create/`              | Email + Password + Confirm Password + User Type              |
| Verify Email      | `POST /verify_email/`        | Email + Code                                                 |
| Resend Email Code | `POST /resend-verification/` | Email                                                        |
| Login             | `POST /login/`               | Email + Password                                             |
| Forgot Password   | `POST /forgot_password/`     | **Email**                                                    |
| Resend Reset Code | `POST /resend_reset_code/`   | **لا شيء يدخله المستخدم؛ Flutter يرسل Reset Token تلقائيًا** |
| Verify Reset Code | `POST /verify_reset_code/`   | **Code فقط من المستخدم** + Reset Token تلقائيًا              |
| Reset Password    | `POST /reset_password/`      | **New Password + Confirm Password** + Reset Token تلقائيًا   |
| Logout            | `POST /logout/`              | لا شيء، Token بالـ Header                                    |
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
# 21. Authentication Workflow الكامل

## Registration & Login

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

---

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
               VERIFY CODE PAGE
                       │
              ┌────────┴────────┐
              │                 │
          Enter Code       Resend Code
              │                 │
              │                 ▼
              │       POST /resend_reset_code/
              │                 │
              │        New Code + New Token
              │                 │
              └────────────► Verify Code
                                │
                                ▼
                    POST /verify_reset_code/
                                │
                                ▼
                       is_verified=true
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
 ├── password
 ├── name
 ├── user_type
 ├── is_staff
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


```

بهذا الشكل أصبحت وثائق الـ Authentication متوافقة مع الـ APIs الحالية، وتشمل:

**Register, Email Verification, Resend Email Verification, Login, Forgot Password, Resend Reset Code, Verify Reset Code, Reset Password, Logout, Profile**
