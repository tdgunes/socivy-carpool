# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
from django.contrib.auth.models import User


def load_super_users(apps, schema_editor):
    user = User.objects.create_superuser("tdgunes","tdgunes@gmail.com", "apranax94")
    user.is_active = True
    user.is_admin = True
    user.save()

    print("\n\nLoad Super Users:")
    for user in User.objects.all():
        print(user)


def unload_super_users(apps, schema_editor):
    MyUser.objects.all().delete()



class Migration(migrations.Migration):

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Message',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('text', models.TextField()),
                ('timestamp', models.PositiveIntegerField(verbose_name='Timestamp')),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Peer',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('email', models.EmailField(max_length=75, verbose_name='Email', unique=True)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Room',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('messages', models.ManyToManyField(to='chat.Message')),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.AddField(
            model_name='peer',
            name='rooms',
            field=models.ManyToManyField(to='chat.Room', null=True),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='message',
            name='recipient',
            field=models.ForeignKey(related_name='recipient', to='chat.Peer'),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='message',
            name='sender',
            field=models.ForeignKey(related_name='sender', to='chat.Peer'),
            preserve_default=True,
        ),
        migrations.RunPython(load_super_users, reverse_code=unload_super_users),
    ]
