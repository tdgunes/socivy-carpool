# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('chat', '0003_auto_20141220_2121'),
    ]

    operations = [
        migrations.AddField(
            model_name='room',
            name='contacts',
            field=models.ManyToManyField(to='chat.Peer'),
            preserve_default=True,
        ),
        migrations.AlterField(
            model_name='message',
            name='timestamp',
            field=models.DateTimeField(auto_now_add=True),
            preserve_default=True,
        ),
        migrations.AlterField(
            model_name='room',
            name='messages',
            field=models.ManyToManyField(to='chat.Message', blank=True),
            preserve_default=True,
        ),
    ]
