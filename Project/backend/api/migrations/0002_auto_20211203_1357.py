# Generated by Django 3.2.8 on 2021-12-03 10:57

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Event',
            fields=[
                ('eventID', models.AutoField(primary_key=True, serialize=False, unique=True)),
                ('title', models.TextField()),
                ('thumbnail', models.TextField()),
                ('performer', models.CharField(max_length=50)),
                ('date', models.CharField(max_length=50)),
                ('location', models.CharField(max_length=50)),
                ('time', models.CharField(max_length=50)),
                ('rules', models.CharField(max_length=50)),
                ('prices', models.CharField(max_length=50)),
                ('category', models.CharField(max_length=100)),
            ],
        ),
        migrations.AlterField(
            model_name='user',
            name='isActive',
            field=models.BooleanField(default=True),
        ),
    ]
