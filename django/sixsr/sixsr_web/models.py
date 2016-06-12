# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Remove `managed = False` lines for those models you wish to give write DB access
# Feel free to rename the models, but don't rename db_table values or field names.
#
# Also note: You'll have to insert the output of 'django-admin.py sqlcustom [appname]'
# into your database.
from __future__ import unicode_literals

from django.db import models

class Content(models.Model):
	content_id = models.IntegerField(primary_key=True)
	uri = models.CharField(max_length=512)
	class Meta:
		managed = True
		db_table = 't$content'

	def __str__(self):
		return self.uri;

class Segments(models.Model):
	segment_id = models.IntegerField(primary_key=True)
	priority = models.IntegerField(blank=True, null=True)
	content = models.ForeignKey(Content, blank=True, null=True)
	start_time = models.TimeField(blank=True, null=True)
	end_time = models.TimeField(blank=True, null=True)
	preempt = models.IntegerField()
	class Meta:
		managed = True
		db_table = 't$segments'

	def __str__(self):
		return str(self.start_time) + ' -> ' + str(self.end_time);
