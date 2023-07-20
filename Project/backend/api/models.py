from typing import ContextManager
from django.db import models
from django.db.models.deletion import CASCADE
from django.db.models.fields import DateField
from django.utils.timezone import now
# Create your models here.

class User(models.Model):
    userID = models.AutoField(primary_key=True, unique=True)
    username = models.CharField(max_length=50)
    name = models.CharField(max_length=50)
    email = models.EmailField(max_length=50, unique=True)
    password = models.CharField(max_length=50)
    phoneNumber = models.CharField(max_length=20, default="")
    isAuthenticated = models.BooleanField(default=False)
    isActive = models.BooleanField(default=True)

    def __str__(self):
        return self.username


class Event(models.Model):
    eventID = models.AutoField(primary_key=True, unique=True)
    name = models.TextField(null=False)
    thumbnail = models.TextField(null=False)
    performer = models.CharField(max_length=50, default="")
    date = models.CharField(max_length=50, null=False)
    location = models.CharField(max_length=100, default="Location: ")
    time = models.CharField(max_length=50, default="Time: ")
    rules = models.TextField(default="Event details: ")
    prices = models.TextField(default="Prices: ")
    category = models.CharField(max_length=100, default="")
    type = models.CharField(max_length=50, default="normal")
    seatingPlan = models.TextField(null=True)
    totalTickets = models.IntegerField()
    availableTickets = models.IntegerField()

    def __str__(self):
        return str(self.eventID) + ": " + self.name


class Announcement(models.Model):
    announcementID = models.AutoField(primary_key=True, unique=True)
    content = models.CharField(max_length=250)
    date = models.CharField(max_length=250)

    def __str__(self):
        return self.content


class Ticket(models.Model):
    ticketID = models.AutoField(primary_key=True, unique=True)
    eventID = models.ForeignKey(Event, on_delete=models.CASCADE)
    date = models.DateTimeField()
    category = models.CharField(max_length=50, default="Category 1")
    price = models.DecimalField(decimal_places=2, max_digits=10)

    def __str__(self):
        return str(self.ticketID)


class Purchase(models.Model):
    purchaseID = models.AutoField(primary_key=True, unique=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    total = models.DecimalField(decimal_places=2, max_digits=10)
    dateUTC = models.DateTimeField(default=now, blank=True)

    def __str__(self):
        return self.purchaseID


class DiscountCode(models.Model):
    codeID = models.AutoField(primary_key=True, unique=True)
    code = models.CharField(max_length=50, unique=True)
    start = models.DateTimeField()
    end = models.DateTimeField()
    discount = models.DecimalField(decimal_places=4, max_digits=5)

    def __str__(self):
        return str(self.codeID) + ": " + self.code


class WaitingList(models.Model):
    listID = models.AutoField(primary_key=True, unique=True)
    event = models.OneToOneField(Event, on_delete=models.CASCADE)
    user = models.ManyToManyField(User)

    def __str__(self):
        return str(self.listID) + ": " + str(self.event)
