# Generated by Django 3.2.8 on 2021-12-19 08:24

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0012_rename_useremail_purchase_user'),
    ]

    operations = [
        migrations.CreateModel(
            name='DiscountCode',
            fields=[
                ('codeID', models.AutoField(primary_key=True, serialize=False, unique=True)),
                ('code', models.CharField(max_length=50)),
                ('start', models.DateTimeField()),
                ('end', models.DateTimeField()),
                ('discount', models.DecimalField(decimal_places=4, max_digits=5)),
            ],
        ),
    ]