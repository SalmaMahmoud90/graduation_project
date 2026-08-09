from django.db import models

class Report(models.Model):
    class ReportCategory(models.TextChoices):
        SPAM = 'spam', 'Spam'
        HARASSMENT = 'harassment', 'Harassment'
        FAKE = 'fake', 'Fake'
        DANGEROUS = 'dangerous', 'Dangerous'
        OTHER = 'other', 'Other'
    class ReportStatus(models.TextChoices):
        PENDING= 'pending', 'Pending'
        REVIEWED= 'reviewed', 'Reviewed'

    reporter= models.ForeignKey("users.MainUser", on_delete=models.CASCADE, related_name= 'reports_made')
    reported_user = models.ForeignKey("users.MainUser",on_delete=models.CASCADE,related_name='reports_received')
    ride = models.ForeignKey("rides.Ride", on_delete=models.SET_NULL, null=True, blank=True)
    type= models.CharField(max_length=20, choices= ReportCategory.choices)
    reason= models.TextField()
    status= models.CharField(max_length=20, choices= ReportStatus.choices, default=ReportStatus.PENDING)
    admin_note = models.TextField(blank=True, null=True)
    created_at= models.DateTimeField(auto_now_add=True)
    updated_at= models.DateTimeField(auto_now=True)