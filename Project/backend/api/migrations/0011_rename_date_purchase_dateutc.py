# Generated by Django 3.2.8 on 2021-12-19 07:52

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0010_purchase'),
    ]

    operations = [
        migrations.RenameField(
            model_name='purchase',
            old_name='date',
            new_name='dateUTC',
        ),
    ]
