# Static Files Configuration

This directory contains static files for the CarPolling project.

## Directory Structure

```
static/
├── css/
│   └── style.css          # Main CSS file
├── js/
│   └── main.js           # Main JavaScript file
├── images/               # Image files
└── README.md            # This file
```

## How to Use

### In Templates
```html
{% load static %}

<link rel="stylesheet" href="{% static 'css/style.css' %}">
<script src="{% static 'js/main.js' %}"></script>
<img src="{% static 'images/logo.png' %}" alt="Logo">
```

### In Python Views
```python
from django.templatetags.static import static

# Get static URL
static_url = static('css/style.css')
```

## Development vs Production

### Development
- Static files are served directly by Django
- Files are served from `STATICFILES_DIRS`

### Production
- Run `python manage.py collectstatic`
- Files are collected to `STATIC_ROOT`
- Serve with a web server (nginx, Apache)

## Commands

```bash
# Collect static files for production
python manage.py collectstatic

# Find static files
python manage.py findstatic css/style.css
``` 