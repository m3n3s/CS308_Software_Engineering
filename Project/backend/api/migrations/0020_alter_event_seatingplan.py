# Generated by Django 3.2.8 on 2021-12-19 19:33

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0019_alter_event_seatingplan'),
    ]

    operations = [
        migrations.AlterField(
            model_name='event',
            name='seatingPlan',
            field=models.TextField(null=True),
        ),
    ]
