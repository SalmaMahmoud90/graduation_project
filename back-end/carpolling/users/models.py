
from django.db import models
from django.contrib.auth.models import AbstractBaseUser, PermissionsMixin, BaseUserManager

class MainUserManager(BaseUserManager):
    def create_user(self, email=None, password=None, **extra_fields):
        if not email:
            raise ValueError('The Email field must be set')
        email = self.normalize_email(email)
        user = self.model(email=email, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email=None, password=None,**extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        extra_fields.setdefault('is_active', True)
        
        if extra_fields.get('is_staff') is not True:
            raise ValueError('Superuser must have is_staff=True.')
        if extra_fields.get('is_superuser') is not True:
            raise ValueError('Superuser must have is_superuser=True.')
        
        return self.create_user(email, password, **extra_fields)
    
class MainUser(AbstractBaseUser, PermissionsMixin):
    USER_TYPE_CHOICES = [
        ('driver', 'Driver'),
        ('rider', 'Rider'),
        ('admin', 'Admin')
    ]
    name = models.CharField(max_length=15)
    email = models.EmailField(unique=True)
    profile_picture = models.ImageField(upload_to='profiles/%Y/%m/%d/', null=True, blank=True)
    user_type = models.CharField(max_length=10, choices=USER_TYPE_CHOICES, null=True, blank=True)
    phone= models.CharField(max_length= 50, unique= True, null=True, blank=True)
    is_staff = models.BooleanField(default=False)
    is_active = models.BooleanField(default=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    objects = MainUserManager()

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = []

    def __str__(self):
        return self.name or self.email

    def get_full_name(self):
        return self.name


class Rider(models.Model):
    user = models.OneToOneField(MainUser, on_delete=models.CASCADE)
    current_location = models.CharField(max_length=50,null=True, blank=True)
    def __str__(self):
        return f"Rider : {self.user.email}"


class Driver(models.Model):
    user = models.OneToOneField(MainUser, on_delete=models.CASCADE)
    car_model = models.CharField(max_length=50, null=True, blank=True)
    car_color= models.CharField(max_length=50, null=True, blank=True)
    car_number= models.CharField(max_length=50, null=True, blank=True)
    car_image = models.ImageField(upload_to='car_images/', null=True, blank=True)

    def __str__(self):
        return f"Driver : {self.user.email}"


class AppAdmin(models.Model):
    user = models.OneToOneField(MainUser, on_delete=models.CASCADE)
    def __str__(self):
        return f"Admin : {self.user.email}"


class EmailVerification(models.Model):
    user = models.OneToOneField("MainUser",on_delete=models.CASCADE, related_name="email_verification")
    code = models.CharField(max_length=6)
    expires_at = models.DateTimeField()

    def __str__(self):
        return self.user.email

class PasswordResetCode(models.Model):
    user = models.OneToOneField(
        MainUser,
        on_delete=models.CASCADE,
        related_name="password_reset"
    )
    reset_token = models.CharField(max_length=128, unique=True)
    code = models.CharField(max_length=6)
    expires_at = models.DateTimeField()
    is_verified = models.BooleanField(default=False)
    def __str__(self):
        return self.user.email