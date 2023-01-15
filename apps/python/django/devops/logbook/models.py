from django.db import models


class Task(models.Model):

    user = models.CharField(max_length=30)
    time = models.CharField(max_length=30)
    task = models.CharField(max_length=500)
    tags = models.CharField(max_length=100, default="-", null=True)

    class Meta:
        ordering = ('-time',)

class TagManager(models.Manager):
    def populate_tags(self, values):
        for i in values:
            self.create(tag=i)
        # do something with the book
        # return i

class Tag(models.Model):

    # def __str__(self):
    #     return self.tag

    tag = models.CharField(max_length=20, default="-", primary_key=True)

    objects = TagManager()

    class Meta:
        verbose_name = "tag"
        verbose_name_plural = "tags"


# book = Book.objects.create_book("Pride and Prejudice")    

TAG_VALUES = {
'aks',
'prod',
'dev',
'cicd',
'hardware',
}

Tag.objects.populate_tags(TAG_VALUES)

# for tag in TAG_VALUES:
#     t = Tag.objects.populate_tags(tag)