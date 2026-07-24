from django.db import models
from django.utils import timezone
from django.contrib.auth.models import User


class List(models.Model):
    name = models.CharField(max_length=100)
    owner = models.ForeignKey(User, on_delete=models.CASCADE, null=True, blank=True, related_name='listeler')

    def __str__(self):
        return self.name

class Word(models.Model):
    eng = models.CharField(max_length=100)
    tr = models.CharField(max_length=100)
    example = models.TextField()

    # ilk eklendiğinde kelime henüz test edilmediği için durumu belirsiz (None) olarak başlıyor
    known = models.BooleanField(null=True, blank=True, default=None)

    level = models.IntegerField(default=0)
    next_review_date = models.DateTimeField(default=timezone.now)
    
    liste = models.ForeignKey(
        List,
        on_delete=models.CASCADE
    )

    def __str__(self):
        return self.eng