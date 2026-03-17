# دليل استخدام الصور في مشروع CarPolling

## 📁 هيكل مجلدات الصور

```
carpolling/
├── static/
│   └── images/
│       ├── icons/          # الأيقونات الثابتة
│       │   ├── car.png
│       │   ├── user.png
│       │   └── location.png
│       └── ui/             # صور واجهة المستخدم
│           ├── logo.png
│           ├── header-bg.jpg
│           └── footer-bg.png
└── media/
    ├── profiles/           # صور الملفات الشخصية
    │   ├── user1.jpg
    │   └── user2.png
    ├── cars/              # صور السيارات
    │   ├── car1.jpg
    │   └── car2.png
    └── documents/         # المستندات
        ├── license1.pdf
        └── insurance1.pdf
```

## 🎯 متى تستخدم كل نوع؟

### 1. **صور الـ Static** (`static/images/`)
**استخدمها لـ:**
- شعار الموقع
- أيقونات ثابتة
- صور الخلفية
- أي صور لا تتغير

**مثال في Template:**
```html
{% load static %}
<img src="{% static 'images/icons/car.png' %}" alt="Car Icon">
<img src="{% static 'images/ui/logo.png' %}" alt="Logo">
```

### 2. **صور الـ Media** (`media/`)
**استخدمها لـ:**
- صور الملفات الشخصية للمستخدمين
- صور السيارات
- المستندات المرفوعة
- أي ملفات يرفعها المستخدمون

**مثال في Template:**
```html
<img src="{{ user.profile_picture.url }}" alt="Profile Picture">
<img src="{{ car.image.url }}" alt="Car Image">
```

## 📝 كيفية إضافة صور جديدة

### إضافة أيقونة جديدة:
1. ضع الصورة في `static/images/icons/`
2. استخدمها في Template:
```html
<img src="{% static 'images/icons/new-icon.png' %}" alt="New Icon">
```

### إضافة صورة للمستخدم:
1. الصورة ستُحفظ تلقائياً في `media/profiles/`
2. استخدمها في Template:
```html
<img src="{{ user.profile_picture.url }}" alt="Profile Picture">
```

## 🔧 إعدادات Django

### في `settings.py`:
```python
STATIC_URL = '/static/'
STATIC_ROOT = BASE_DIR / 'staticfiles'
STATICFILES_DIRS = [BASE_DIR / 'static']

MEDIA_URL = '/media/'
MEDIA_ROOT = BASE_DIR / 'media'
```

### في `urls.py`:
```python
from django.conf import settings
from django.conf.urls.static import static

if settings.DEBUG:
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
```

## 📋 الأوامر المهمة

```bash
# جمع ملفات الـ Static للإنتاج
python manage.py collectstatic

# البحث عن ملف معين
python manage.py findstatic images/icons/car.png
```

## ⚠️ ملاحظات مهمة

1. **صور الـ Static** ثابتة ولا تتغير
2. **صور الـ Media** تتغير حسب ما يرفعه المستخدمون
3. تأكد من إضافة `{% load static %}` في بداية Template
4. في الإنتاج، استخدم خادم ويب (nginx) لخدمة الملفات الثابتة 