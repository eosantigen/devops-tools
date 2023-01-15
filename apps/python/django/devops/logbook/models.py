from django.db import models


class Task(models.Model):

    user = models.CharField(max_length=30)
    time = models.CharField(max_length=30)
    task = models.CharField(max_length=500)
    tags = models.CharField(max_length=200, default="-", null=True)

    class Meta:
        ordering = ('-time',)

class Tag(models.Model):

    # def __str__(self):
    #     return self.tag

    tag = models.CharField(max_length=20, default="-", primary_key=True)

    class Meta:
        verbose_name = "tag"
        verbose_name_plural = "tags"