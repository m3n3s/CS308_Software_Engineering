from django.urls import path
from django.urls.conf import include
from .views import *

urlpatterns = [
    path("get-user", GetUser.as_view(), name="get-user"),
    path("sign-up", SignUp.as_view(), name="sign-up"),
    path("settings", UserSettings.as_view(), name="settings"),
    path("log-in", LogIn.as_view(), name="log-in"),
    path("homepage", HomePage.as_view(), name="homepage"),
    path("announcements", Announcements.as_view(), name="announcements"),
    path("details", EventDetails.as_view(), name="details"),
    path("purchase", MakePurchase.as_view(), name="purchase"),
    path("discount", Discount.as_view(), name="discount"),
    path("waiting-list", JoinWaitingList.as_view(), name="waiting-list"),
    path("check-waiting-list", CheckWaitingList.as_view(), name="check-waiting-list"),
    path("leave-waiting-list", LeaveWaitingList.as_view(), name="leave-waiting-list"),
]
