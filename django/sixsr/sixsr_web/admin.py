from django.contrib import admin

# Register your models here.

from .models import Segment, Content;

admin.site.register(Segment);
admin.site.register(Content);
