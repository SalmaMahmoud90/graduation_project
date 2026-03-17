from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import MainUser, Rider, Driver, AppAdmin

# Register your models here.

class MainUserAdmin(UserAdmin):
    model = MainUser
    list_display = ('email', 'name', 'user_type', 'is_staff', 'is_active', 'created_at')
    list_filter = ('user_type', 'is_staff', 'is_active')
    readonly_fields = ('created_at','updated_at')
    fieldsets = (
        (None, {'fields': ('email', 'password')}),
        ('Personal info', {'fields': ('name', 'user_type')}),
        ('Permissions', {'fields': ('is_staff', 'is_active', 'groups', 'user_permissions')}),
        ('Important dates', {'fields': ('created_at', 'updated_at')}),
    )
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('email', 'name', 'user_type', 'password1', 'password2', 'is_staff', 'is_active')}
        ),
    )
    search_fields = ('email', 'name')
    ordering = ('email',)

admin.site.register(MainUser, MainUserAdmin)
admin.site.register(Rider)
admin.site.register(Driver)
admin.site.register(AppAdmin)
