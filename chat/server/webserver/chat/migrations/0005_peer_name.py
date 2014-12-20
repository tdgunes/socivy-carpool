# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('chat', '0004_auto_20141220_2246'),
    ]

    operations = [
        migrations.AddField(
            model_name='peer',
            name='name',
            field=models.CharField(max_length=100, default='not available now', verbose_name='Name'),
            preserve_default=False,
        ),
    ]
