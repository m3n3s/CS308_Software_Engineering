# Generated by Django 3.2.8 on 2021-12-03 14:51

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0007_rename_title_event_name'),
    ]

    operations = [
        migrations.CreateModel(
            name='Announcement',
            fields=[
                ('announcementID', models.AutoField(primary_key=True, serialize=False, unique=True)),
                ('content', models.CharField(max_length=250)),
                ('date', models.CharField(max_length=250)),
            ],
        ),
    ]
