from django.contrib import admin
from .models import *

# Register your models here.
admin.site.register(User)
admin.site.register(Event)
admin.site.register(Announcement)
admin.site.register(Ticket)
admin.site.register(Purchase)
admin.site.register(DiscountCode)
admin.site.register(WaitingList)