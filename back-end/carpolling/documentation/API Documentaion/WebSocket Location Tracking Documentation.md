

## 1. نظرة عامة

يُستخدم نظام الـ WebSocket لتوفير **تتبع الموقع الجغرافي المباشر للرحلة (Real-Time Location Tracking)**.

يسمح النظام للسائق والركاب المصرح لهم بالاتصال بقناة خاصة بالرحلة، وإرسال إحداثيات الموقع الجغرافي، بحيث يتم حفظها في قاعدة البيانات وإرسالها مباشرة إلى جميع المستخدمين المتصلين بنفس الرحلة.

يعتمد النظام على:

- Django Channels
    
- WebSocket
    
- OAuth2 Access Token للمصادقة
    
- `LocationConsumer` لمعالجة الاتصالات
    
- `CurrentLocation` لتخزين آخر موقع للمستخدم
    
- `LocationPoint` لتخزين سجل مواقع المستخدم أثناء الرحلة
    

---

# 2. WebSocket URL

### Endpoint

```text
wss://127.0.0.1:8000/ws/location/<ride_id>/?token=<access_token>
```

### مثال

```text
wss://127.0.0.1:8000/ws/location/1005/?token=<access_token>
```

حيث:

|Parameter|النوع|إجباري؟|الوصف|
|---|---|---|---|
|`ride_id`|Integer|نعم|المعرّف الفريد للرحلة|
|`token`|String|نعم|OAuth2 Access Token للمستخدم|

في بيئة الإنتاج يتم استخدام:

```text
wss://
```

بدل:

```text
ws://
```

لاستخدام اتصال WebSocket مشفّر عبر HTTPS.

---

# 3. المصادقة Authentication

يتم إرسال OAuth2 Access Token ضمن Query Parameters أثناء إنشاء اتصال WebSocket.

### الصيغة

```text
?token=<access_token>
```

مثال:

```text
ws://127.0.0.1:8000/ws/location/1005/?token=bYZRl8Hjs9dmHdGDWCCmscOoDlZsSj
```

يقوم `OAuthTokenMiddleware` باستخراج الـ Token والتحقق منه.

### آلية المصادقة

```text
WebSocket Connection
        ↓
قراءة token من Query String
        ↓
البحث عن AccessToken
        ↓
التحقق من وجود المستخدم
        ↓
التحقق من صلاحية Token
        ↓
تحديد المستخدم داخل scope["user"]
        ↓
السماح أو رفض الاتصال
```

إذا لم يتم إرسال Token أو كان Token غير صالح أو منتهي الصلاحية، يتم اعتبار المستخدم:

```text
AnonymousUser
```

ويتم إغلاق اتصال WebSocket.

---

# 4. صلاحيات الوصول إلى الرحلة

لا يُسمح لأي مستخدم بالاتصال بقناة تتبع الرحلة.

يتم التحقق من صلاحية المستخدم داخل:

```python
user_can_access_ride()
```

وتوجد ثلاث حالات للمستخدم:

### Driver

يسمح للسائق بالوصول فقط إلى الرحلة التي يملكها.

التحقق يتم من خلال:

```text
ride.driver.user_id == user.id
```

---

### Rider

يسمح للراكب بالوصول إلى الرحلة فقط إذا كان لديه حجز لهذه الرحلة وحالة الحجز:

```text
accepted
```

أي أن الراكب الذي يملك حجزًا بحالة:

```text
pending
```

أو:

```text
rejected
```

أو:

```text
cancelled
```

لا يستطيع الوصول إلى قناة تتبع الرحلة.

---

### Admin

يسمح للمستخدم الذي نوعه:

```text
admin
```

بالوصول إلى الرحلة.

---

# 5. إنشاء اتصال WebSocket

عند إنشاء الاتصال يتم تنفيذ الخطوات التالية:

```text
Client
   ↓
WebSocket Connect
   ↓
OAuthTokenMiddleware
   ↓
التحقق من Access Token
   ↓
التحقق من صلاحية المستخدم للرحلة
   ↓
إنشاء Ride Group
   ↓
Accept Connection
```

يتم إنشاء Group خاص بكل رحلة بالشكل:

```text
ride_<ride_id>
```

مثال:

```text
ride_1005
```

وبالتالي فإن جميع المستخدمين المتصلين بالرحلة رقم `1005` يكونون ضمن نفس المجموعة.

---

# 6. Connection

عند نجاح الاتصال يتم قبول WebSocket:

```text
Connection Accepted
```

أما في الحالات التالية فيتم رفض الاتصال وإغلاقه:

- المستخدم غير مصادق عليه.
    
- Access Token غير موجود.
    
- Access Token منتهي الصلاحية.
    
- Access Token غير صالح.
    
- الرحلة غير موجودة.
    
- المستخدم لا يملك صلاحية الوصول إلى الرحلة.
    

---

# 7. إرسال الموقع الجغرافي

بعد إنشاء الاتصال يستطيع العميل إرسال الموقع الحالي للمستخدم.

### Request

يتم إرسال JSON يحتوي على:

```json
{
    "latitude": 34.7324,
    "longitude": 36.7137
}
```

### الحقول

|الحقل|النوع|إجباري؟|الوصف|
|---|---|---|---|
|`latitude`|Decimal/Number|نعم|خط العرض|
|`longitude`|Decimal/Number|نعم|خط الطول|

---

# 8. التحقق من بيانات الموقع

يجب إرسال كل من:

```text
latitude
longitude
```

إذا كان أحد الحقلين غير موجود، يتم إرسال:

```json
{
    "error": "latitude and longitude are required."
}
```

ولا يتم حفظ الموقع أو إرساله إلى باقي المستخدمين.

---

# 9. حفظ الموقع

عند وصول إحداثيات صحيحة يتم تنفيذ عملية حفظ الموقع.

يتم حفظ البيانات في جدولين:

### CurrentLocation

يحتفظ بآخر موقع حالي للمستخدم.

إذا كان للمستخدم موقع موجود مسبقًا، يتم تحديثه.

```text
user
latitude
longitude
updated_at
```

### LocationPoint

يتم إنشاء سجل جديد لكل نقطة موقع يتم إرسالها.

```text
ride
user
latitude
longitude
recorded_at
```

وبالتالي:

```text
CurrentLocation
      ↓
آخر موقع حالي للمستخدم

LocationPoint
      ↓
سجل كامل لحركة المستخدم أثناء الرحلة
```

---

# 10. Location Update

بعد حفظ الموقع، يتم إرسال تحديث إلى جميع المستخدمين المتصلين بنفس الرحلة.

يتم استخدام Group:

```text
ride_<ride_id>
```

ويتم إرسال البيانات بالشكل:

```json
{
    "type": "location_update",
    "user_id": 15,
    "latitude": 34.7324,
    "longitude": 36.7137,
    "recorded_at": "2026-08-15T08:15:30+00:00"
}
```

### الحقول

|الحقل|النوع|الوصف|
|---|---|---|
|`type`|String|نوع الرسالة|
|`user_id`|Integer|معرّف المستخدم الذي أرسل الموقع|
|`latitude`|Float|خط العرض|
|`longitude`|Float|خط الطول|
|`recorded_at`|DateTime|وقت تسجيل الموقع|

---

# 11. استقبال Location Update

عند استقبال تحديث موقع من أحد المستخدمين، يقوم WebSocket بإرسال البيانات إلى جميع المستخدمين الموجودين في نفس Group.

مثال:

```json
{
    "type": "location_update",
    "user_id": 15,
    "latitude": 34.7324,
    "longitude": 36.7137,
    "recorded_at": "2026-08-15T08:15:30+00:00"
}
```

وبذلك يستطيع تطبيق Flutter تحديث موقع السائق أو الراكب على الخريطة بشكل مباشر.

---

# 12. Disconnect

عند انقطاع اتصال المستخدم يتم إزالة قناة الاتصال من Group الخاص بالرحلة.

مثال:

```text
ride_1005
```

ويتم تنفيذ:

```text
group_discard
```

لمنع بقاء الاتصال ضمن مجموعة الرحلة بعد انقطاعه.

---

# 13. WebSocket Message Flow

تتم عملية تتبع الموقع بالشكل التالي:

```text
Driver / Rider
      │
      │ latitude + longitude
      ↓
WebSocket
      │
      ↓
LocationConsumer
      │
      ├──→ CurrentLocation
      │      حفظ آخر موقع
      │
      ├──→ LocationPoint
      │      حفظ سجل الموقع
      │
      ↓
ride_<ride_id> Group
      │
      ├──────────────┐
      ↓              ↓
 Driver           Riders
      │              │
      └──────→ Location Update
```

---

# 14. حالات الخطأ

### مستخدم غير مصادق عليه

يتم إغلاق الاتصال مباشرة.

---

### المستخدم لا يملك صلاحية الوصول للرحلة

يتم إغلاق الاتصال.

---

### الرحلة غير موجودة

يتم رفض الاتصال.

---

### Token غير موجود

يتم اعتبار المستخدم `AnonymousUser` ويتم إغلاق الاتصال.

---

### Token منتهي الصلاحية

يتم اعتبار المستخدم غير مصادق عليه ويتم إغلاق الاتصال.

---

### إحداثيات ناقصة

يتم إرسال:

```json
{
    "error": "latitude and longitude are required."
}
```

---

# 15. WebSocket Routing

يتم تعريف مسار WebSocket بالشكل التالي:

```text
/wss/location/<ride_id>/
```

ويتم استخدام:

```text
ride_id
```

لتحديد الرحلة التي سيتم تتبع موقع مستخدميها.

مثال:

```text
/wss/location/1005/
```

يعني أن الاتصال خاص بالرحلة:

```text
Ride ID = 1005
```

---

# 16. متطلبات الاتصال

يحتاج العميل إلى:

1. OAuth2 Access Token صالح.
    
2. `ride_id` صحيح.
    
3. صلاحية الوصول إلى الرحلة.
    
4. اتصال WebSocket.
    

### مثال الاتصال

```text
ws://127.0.0.1:8000/ws/location/1005/?token=<access_token>
```

وفي بيئة الإنتاج:

```text
wss://api.example.com/ws/location/1005/?token=<access_token>
```

---

# 17. ملخص الصلاحيات

|نوع المستخدم|الوصول إلى WebSocket|
|---|---|
|Driver|فقط رحلاته|
|Rider|الرحلات التي لديه فيها حجز `accepted`|
|Admin|جميع الرحلات|
|مستخدم غير مصادق|غير مسموح|

---

# 18. ملاحظات مهمة

- الـ WebSocket لا يعمل كـ REST API تقليدي، لذلك لا يتم استخدام `GET` أو `POST` لعملية إرسال الموقع.
    
- يتم إنشاء قناة اتصال مستمرة بين التطبيق والسيرفر.
    
- يتم إرسال الموقع بشكل لحظي عبر WebSocket.
    
- يتم حفظ آخر موقع للمستخدم في `CurrentLocation`.
    
- يتم حفظ جميع نقاط الموقع في `LocationPoint`.
    
- جميع المستخدمين المتصلين بنفس الرحلة يستقبلون تحديثات الموقع الخاصة بالمستخدمين الموجودين ضمن الرحلة.
    
- المصادقة تعتمد على OAuth2 Access Token.
    
- صلاحية الوصول إلى الموقع تعتمد على نوع المستخدم وعلاقته بالرحلة.