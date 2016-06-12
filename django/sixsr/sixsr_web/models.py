#
#
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

class Segment(models.Model):
	segment_id = models.IntegerField(primary_key=True)
	priority = models.IntegerField(blank=True, null=True)
	content = models.ForeignKey(Content, blank=True, null=True)
	start_time = models.TimeField(blank=True, null=True)
	end_time = models.TimeField(blank=True, null=True)
	preempt = models.IntegerField()
	class Meta:
		managed = True
		db_table = 't$segment'

	def __str__(self):
		return (str(self.start_time) + ' -> ' + str(self.end_time) +
		       ' priority:' + str(self.priority));
