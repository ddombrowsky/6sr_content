from django.contrib import admin

# Register your models here.

from .models import Segments, Content;

admin.site.register(Segments);
admin.site.register(Content);
