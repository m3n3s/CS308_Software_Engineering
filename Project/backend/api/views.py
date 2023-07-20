from django.http import request
from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework import authentication, permissions, status
from rest_framework.response import Response
from .serializers import *
from .models import *
import uuid
from datetime import date
from django.core.mail import EmailMessage
from django.template.loader import get_template
from xhtml2pdf import pisa


# Create your views here.
class GetUser(APIView):
    permission_classes = [] # No permission needed
    authentication_classes = [] # No authentication needed

    def post(self, request):
        email = request.data["email"]

        if email != None:
            user = User.objects.get(email=email)

            serializer = UserSerializer(user)
            return Response(
                serializer.data,
                status=status.HTTP_200_OK,
                headers={
                    "Access-Control-Allow-Origin": "*",
                    "Access-Control-Allow-Headers": "*",
                },
            )

        return Response(
            status=status.HTTP_400_BAD_REQUEST,
            headers={
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Headers": "*",
            }
        )


class SignUp(APIView):
    permission_classes = [] # No permission needed
    authentication_classes = [] # No authentication needed

    def post(self, request):
        serializer = UserSerializer(data=request.data)

        if serializer.is_valid():
            #TODO: Can hash the password and then save it

            serializer.save()
            
            return Response(
                {
                    "RequestId": str(uuid.uuid4()),
                    "Message": "User created successfully",                    
                    "User": serializer.data,
                }, 
                status=status.HTTP_201_CREATED,
                headers={
                    "Access-Control-Allow-Origin": "*",
                    "Access-Control-Allow-Headers": "*",
                }
            )

        return Response(
            {"Errors": serializer.errors},
            status=status.HTTP_400_BAD_REQUEST,
        )

    def get(self, request):
        if User.objects.count != 0:
            users = User.objects.all()
            serializer = UserSerializer(users, many=True)
            return Response(serializer.data)

        return Response(
            {"Errors": "No user objects exist!"},
            status=status.HTTP_400_BAD_REQUEST,
        )

class UserSettings(APIView):
    permission_classes = [] # No permission needed
    authentication_classes = [] # No authentication needed

    def post(self, request):

        # Get data from the request:
        email = request.data["email"]
        newUsername = request.data["username"]
        newName = request.data["name"]
        newPassword = request.data["password"]
        newPhonenumber = request.data["phoneNumber"]
        isActive = request.data["isActive"]
        deleteAccount = request.data["deleteAccount"]


        if deleteAccount == "True":
            user = User.objects.get(email = email)
            
            user.delete()

            return Response(
                {
                    "RequestId": str(uuid.uuid4()),
                    "Message": "Account deleted successfully",
                    "User": email,                    
                }, 
                status=status.HTTP_200_OK,
                headers={
                    "Access-Control-Allow-Origin": "*",
                    "Access-Control-Allow-Headers": "*",
                }
            )

        elif isActive == "False":
            user = User.objects.get(email = email)

            user.isActive = False
            user.save()
             
            return Response(
                {
                    "RequestId": str(uuid.uuid4()),
                    "Message": "Settings saved successfully",
                    "User": email,                    
                }, 
                status=status.HTTP_200_OK,
                headers={
                    "Access-Control-Allow-Origin": "*",
                    "Access-Control-Allow-Headers": "*",
                }
            )    

        elif email != None:
            # get current user
            user = User.objects.get(email = email)
            
            # change user info
            if newName != "":
                user.name = newName
            if newUsername != "":
                user.username = newUsername
            if newPassword != "":
                user.password = newPassword
            if newPhonenumber != "":
                user.phoneNumber = newPhonenumber
            
            # save the changes
            user.save()
            
            return Response(
                {
                    "RequestId": str(uuid.uuid4()),
                    "Message": "Settings saved successfully",
                    "User": email,                    
                }, 
                status=status.HTTP_202_ACCEPTED,
                headers={
                    "Access-Control-Allow-Origin": "*",
                    "Access-Control-Allow-Headers": "*",
                }
            )

        return Response(
            {"Errors": "No matching email"},
            status=status.HTTP_400_BAD_REQUEST,
        )


class LogIn(APIView):
    permission_classes = [] # No permission needed
    authentication_classes = [] # No authentication needed

    def post(self, request):

        email = request.data["email"]
        password = request.data["password"]

        user = User.objects.get(email = email)

        if password == user.password:
            # Correct password

            return Response(
                {
                    "RequestId": str(uuid.uuid4()),
                    "Message": "Correct password",
                    "email": email,
                    "name": user.name,
                    "username": user.username,
                    "phoneNumber": user.phoneNumber,
                    "isAuthenticated": user.isAuthenticated,
                    "isActive": user.isActive,
                }, 
                status=status.HTTP_200_OK,
                headers={
                    "Access-Control-Allow-Origin": "*",
                    "Access-Control-Allow-Headers": "*",
                }
            )

        return Response(
            {"Errors": "Wrong password!"},
            status=status.HTTP_400_BAD_REQUEST,
        )


class HomePage(APIView):
    permission_classes = [] # No permission needed
    authentication_classes = [] # No authentication needed

    def post(self, request):

        # if featured return featured events
        # if normal return all events

        email = request.data["email"]
        type = request.data["type"]
        events = []

        if type == "":
            return Response(
                    {"Errors": "Not a valid type."},
                    status=status.HTTP_400_BAD_REQUEST,
                )

        if email != "":
            # return events with regard to users previous activities maybe?

            user = User.objects.get(email = email)
            
            try:
                events = Event.objects.filter(type=type)
                serialized = EventSerializer(events, many=True)
            except:
                return Response(
                    {"Errors": "Error while filtering or serializing!"},
                    status=status.HTTP_400_BAD_REQUEST,
                )

        else:
            # get events
            try:
                events = Event.objects.filter(type=type)
                serialized = EventSerializer(events, many=True)
            except:
                return Response(
                    {"Errors": "Error while filtering or serializing!"},
                    status=status.HTTP_400_BAD_REQUEST,
                )

        

        return Response(
            serialized.data,
            status=status.HTTP_200_OK,
            headers={
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Headers": "*",
            }
        )


class Announcements(APIView):
    permission_classes = [] # No permission needed
    authentication_classes = [] # No authentication needed

    def get(self, request):
        if Announcement.objects.count != 0:
            announcements = Announcement.objects.all()
            serializer = AnnouncementSerializer(announcements, many=True)
            return Response(
                serializer.data,
                status=status.HTTP_200_OK,
                headers={
                    "Access-Control-Allow-Origin": "*",
                    "Access-Control-Allow-Headers": "*",
                },
            )

        return Response(
            {"Errors": "No announcement objects exist!"},
            status=status.HTTP_400_BAD_REQUEST,
        )


class EventDetails(APIView):
    permission_classes = [] # No permission needed
    authentication_classes = [] # No authentication needed

    def post(self, request):

        eventID = request.data["eventID"]
        rspList = []
        
        # Return ticket categories and respective prices
        # for the selected event
        if eventID != None:
            tickets = Ticket.objects.filter(eventID=eventID)

            for t in tickets:
                # print(t)
                rspList.append({
                    "category":t.category,
                    "price": t.price,
                    "date":t.date,
                })

            # print(rspList)

            return Response(
                rspList,
                status=status.HTTP_200_OK,
                headers={
                    "Access-Control-Allow-Origin": "*",
                    "Access-Control-Allow-Headers": "*",
                }
            )

        return Response(
            status=status.HTTP_400_BAD_REQUEST,
            headers={
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Headers": "*",
            }
        )


class MakePurchase(APIView):
    permission_classes = [] # No permission needed
    authentication_classes = [] # No authentication needed

    def post(self, request):

        # Save the purchases to database
        email = request.data["user-email"]
        total = request.data["total"]

        if email!= None and total != None:
            user = User.objects.get(email = email)
            purchase = Purchase(user=user, total=total)
            purchase.save()

            # Get the vatues for the beşow dictionary from request.
            # ex. "name"
            ordered_items = [{
                "name": request.data["eventname"],
                "quantity":request.data["quantity"], 
                "price": request.data["price"], 
                "total":request.data["total"], 
                "producttotal": total
            },]

            pdf_data = {
                "products": ordered_items,
                "grandTotal": total
            }

            subject = "Purchase Confirmed"
            to = user.email,
            print(to)
            html_message = get_template('invoice_email.html')
            message = html_message.render(pdf_data)
            mail = EmailMessage(subject, message, to=to, from_email="justicket.t7@gmail.com")
            print(mail)
            mail.content_subtype = 'html'

            html_pdf = get_template('invoice_pdf.html')
            attachment = html_pdf.render(pdf_data)
            attachment_name = "JusticketInvoice.pdf"
            file = open(attachment_name, "w+b")
            invoice_pdf = pisa.CreatePDF(src=attachment, dest=file)
            file.close()

            mail.attach_file('JusticketInvoice.pdf')
            mail.send()
        

        return Response(
            status=status.HTTP_200_OK,
            headers={
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Headers": "*",
            }
        )


class Discount(APIView):
    permission_classes = [] # No permission needed
    authentication_classes = [] # No authentication needed

    def post(self, request):

        code = request.data["code"]       

        # Check if the code is valid
        try:
            if code != None:
                discount = DiscountCode.objects.get(code=code)

                if discount != None:
                    today = date.today()
                    
                    if discount.start.date() < today and discount.end.date() > today:
                        # Code is entered within discount dates        

                        return Response(
                            {"discount": discount.discount},
                            status=status.HTTP_200_OK,
                            headers={
                                "Access-Control-Allow-Origin": "*",
                                "Access-Control-Allow-Headers": "*",
                            }
                        )

                    return Response(
                        status=status.HTTP_400_BAD_REQUEST,
                        headers={
                            "Access-Control-Allow-Origin": "*",
                            "Access-Control-Allow-Headers": "*",
                        }
                    )
        except:
            return Response(
                status=status.HTTP_400_BAD_REQUEST,
                headers={
                    "Access-Control-Allow-Origin": "*",
                    "Access-Control-Allow-Headers": "*",
                }
            )


class JoinWaitingList(APIView):
    permission_classes = [] # No permission needed
    authentication_classes = [] # No authentication needed

    def post(self, request):
        id = request.data["eventID"]
        useremail = request.data["useremail"]

        try:
            event = Event.objects.get(eventID=id)

            # If there is no available tickets:
            if event.availableTickets == 0:
                user = User.objects.get(email=useremail)                
                list = WaitingList.objects.get(event=event)
                list.user.add(user)

                return Response(
                    status=status.HTTP_200_OK,
                    headers={
                        "Access-Control-Allow-Origin": "*",
                        "Access-Control-Allow-Headers": "*",
                    }
                )
            else:
                raise
        except:
            print("Something went wrong!")
            return Response(
                status=status.HTTP_400_BAD_REQUEST,
                headers={
                    "Access-Control-Allow-Origin": "*",
                    "Access-Control-Allow-Headers": "*",
                }
            )


class CheckWaitingList(APIView):
    permission_classes = [] # No permission needed
    authentication_classes = [] # No authentication needed

    def post(self, request):

        eventID = request.data["eventID"]
        mail = request.data["useremail"]
        rsp = ""

        # If user is in waiting list
        user = User.objects.get(email=mail)
        event = Event.objects.get(eventID=eventID)
        list = WaitingList.objects.filter(event=event).filter(user=user)

        if list.exists():
            rsp = "true"

            return Response(
                rsp,
                status=status.HTTP_200_OK,
                headers={
                    "Access-Control-Allow-Origin": "*",
                    "Access-Control-Allow-Headers": "*",
                }
            )

        return Response(
                status=status.HTTP_400_BAD_REQUEST,
                headers={
                    "Access-Control-Allow-Origin": "*",
                    "Access-Control-Allow-Headers": "*",
                }
            )


class LeaveWaitingList(APIView):
    permission_classes = [] # No permission needed
    authentication_classes = [] # No authentication needed

    def post(self, request):
        id = request.data["eventID"]
        useremail = request.data["useremail"]

        try:
            event = Event.objects.get(eventID=id)
            user = User.objects.get(email=useremail)                
            
            list = WaitingList.objects.get(event=event)
            list.user.remove(user)

            return Response(
                status=status.HTTP_200_OK,
                headers={
                    "Access-Control-Allow-Origin": "*",
                    "Access-Control-Allow-Headers": "*",
                }
            )
            
        except:
            print("Something went wrong!")
            return Response(
                status=status.HTTP_400_BAD_REQUEST,
                headers={
                    "Access-Control-Allow-Origin": "*",
                    "Access-Control-Allow-Headers": "*",
                }
            )