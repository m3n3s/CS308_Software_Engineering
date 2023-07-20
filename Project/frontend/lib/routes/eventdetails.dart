import 'package:flutter/material.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:frontend/main.dart';
import 'package:frontend/routes/checkout.dart';
import 'package:frontend/utils/appbars.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/models/event.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter_html/flutter_html.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({this.event});

  final Event event;

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  String ticketDate = "Select Date";
  String ticketNumber = "1";
  String ticketType = "Select Category";
  double price;
  double total = 0;
  var details = [];
  var dates = ['Select Date'];
  var categories = ['Select Category'];
  bool waiting = false;

  Future getDetails() async {
    // Local host for django and endpoint for details
    final url = Uri.parse('http://127.0.0.1:8000/api/details');

    final requestBody = {
      "eventID": widget.event.id,
    };

    try {
      final response = await http.post(
        url,
        body: requestBody,
        encoding: Encoding.getByName("utf-8"),
      );

      // Succesfull transmission
      if (response.statusCode >= 200 && response.statusCode < 300) {
        print("Transmission was succesfull!!!");

        details = json.decode(response.body);
        // print(details);
        for (var d in details) {
          String date = d["date"].split("T")[0];

          if (!dates.contains(date)) dates.add(date);

          if (!categories.contains(d["category"]))
            categories.add(d["category"]);
        }

        setState(() {});
      }
    } catch (error) {
      print("Error: $error");

      // An error occured, please try again later.
    }
  }

  void getPrice() {
    if ((ticketDate != 'Select Date') && (ticketType != 'Select Category')) {
      for (var d in details) {
        if (d["date"].startsWith(ticketDate) && d["category"] == ticketType) {
          price = d["price"];
          total = price * int.parse(ticketNumber);
        }
      }
    }
  }

  Future joinWaitingList() async {
    // Local host for django and endpoint for joining waiting list
    final url = Uri.parse('http://127.0.0.1:8000/api/waiting-list');

    final requestBody = {
      "useremail": "test@test.com", //currentUser.email,
      "eventID": widget.event.id,
    };

    try {
      final response = await http.post(
        url,
        body: requestBody,
        encoding: Encoding.getByName("utf-8"),
      );

      // Succesfull transmission
      if (response.statusCode >= 200 && response.statusCode < 300) {
        print("Transmission was succesfull!!!");

        // Succesfully added to waiting list
        setState(() {
          waiting = true;
        });
      }
    } catch (error) {
      print("Error: $error");

      // An error occured, please try again later.
    }
  }

  Future leaveWaitingList() async {
    // Local host for django and endpoint for leaving waiting list
    final url = Uri.parse('http://127.0.0.1:8000/api/leave-waiting-list');

    final requestBody = {
      "useremail": "test@test.com", //currentUser.email,
      "eventID": widget.event.id,
    };

    try {
      final response = await http.post(
        url,
        body: requestBody,
        encoding: Encoding.getByName("utf-8"),
      );

      // Succesfull transmission means that user was removed from the list
      if (response.statusCode >= 200 && response.statusCode < 300) {
        print("Transmission was succesfull!!!");

        setState(() {
          waiting = false;
        });
      }
    } catch (error) {
      print("Error: $error");

      // An error occured, please try again later.
    }
  }

  Future checkWaitingList() async {
    // Local host for django and endpoint for checking waiting list
    final url = Uri.parse('http://127.0.0.1:8000/api/check-waiting-list');

    final requestBody = {
      "useremail": "test@test.com", //currentUser.email,
      "eventID": widget.event.id,
    };

    try {
      final response = await http.post(
        url,
        body: requestBody,
        encoding: Encoding.getByName("utf-8"),
      );

      // Succesfull transmission
      if (response.statusCode >= 200 && response.statusCode < 300) {
        print("Transmission was succesfull!!!");

        print(response.body);
        var rsp = json.decode(response.body);

        // If already in waiting list:
        if (rsp == "true") {
          setState(() {
            waiting = true;
          });
        }
      }
    } catch (error) {
      print("Error: $error");

      // An error occured, please try again later.
    }
  }

  @override
  void initState() {
    super.initState();
    getDetails();
    checkWaitingList();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    bool isSmallScreen = false;
    double scaffoldSize = media.width - 250;

    if (media.width < 720) isSmallScreen = true;

    return Scaffold(
      appBar: selectAppbar(context),
      body: ListView(
        padding: !isSmallScreen
            ? EdgeInsets.fromLTRB(100, 100, 100, 50)
            : EdgeInsets.all(20),
        shrinkWrap: true,
        children: [
          // Image, name, date, location:
          isSmallScreen ? Image.network(widget.event.thumbnail) : Container(),
          Row(
            children: [
              !isSmallScreen
                  ? Expanded(
                      flex: 3,
                      child: Image.network(widget.event.thumbnail),
                    )
                  : Container(),
              !isSmallScreen ? SizedBox(width: 20) : Container(),
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        widget.event.name,
                        style: TextStyle(fontSize: 45),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_pin,
                          color: kPrimaryColor,
                        ),
                        Flexible(
                          child: Text(
                            widget.event.location,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.date_range,
                          color: kPrimaryColor,
                        ),
                        Flexible(
                          child: Text(
                            widget.event.date,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(
            height: 25,
          ),

          // Description, details
          DefaultTabController(
            length: 2,
            child: Container(
              height: 200,
              child: Scaffold(
                appBar: TabBar(
                  indicatorColor: kPrimaryColor,
                  tabs: [
                    CustomTab(text: "Event Details"),
                    CustomTab(text: "Ticket Prices"),
                  ],
                ),
                body: TabBarView(
                  children: [
                    ExpandableText(
                      widget.event.rules,
                      expandText: 'Show More',
                      collapseText: 'Show Less',
                      maxLines: 2,
                      linkColor: Colors.blue,
                    ),
                    ExpandableText(
                      widget.event.prices,
                      expandText: 'Show More',
                      collapseText: 'Show Less',
                      maxLines: 1,
                      linkColor: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(
            height: 15,
          ),

          Wrap(
            runSpacing: 20,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 300,
                    width: isSmallScreen ? media.width : scaffoldSize * (2 / 3),
                    // Search tickets box:
                    child: Scaffold(
                      appBar: AppBar(
                        backgroundColor: kPrimaryColor,
                        automaticallyImplyLeading: false,
                        title: Text("Search Tickets"),
                      ),
                      body: Container(
                        padding: EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          border: Border.all(),
                        ),
                        child: widget.event.availableTickets == 0
                            ? Column(
                                children: [
                                  Center(
                                    child: Text(
                                        "There are currently no available tickets for this event. If you want to jain the waiting list in case there are available tickets, please clicke below."),
                                  ),
                                  SizedBox(height: 20),
                                  !waiting
                                      ? ElevatedButton(
                                          onPressed: () => joinWaitingList(),
                                          child: Text("Join Waiting List!"),
                                        )
                                      : Column(
                                          children: [
                                            Text("You are in waiting list."),
                                            TextButton(
                                              onPressed: () =>
                                                  leaveWaitingList(),
                                              child:
                                                  Text("Leave waiting list."),
                                            ),
                                          ],
                                        )
                                ],
                              )
                            : Column(
                                children: [
                                  // Select Date
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Select Date"),
                                      DropdownButton(
                                        value: ticketDate,
                                        icon: const Icon(Icons.arrow_downward),
                                        iconSize: 24,
                                        elevation: 16,
                                        underline: Container(
                                          height: 2,
                                          color: kPrimaryColor,
                                        ),
                                        onChanged: (newValue) {
                                          setState(() {
                                            ticketDate = newValue;
                                          });
                                          getPrice();
                                        },
                                        items: dates
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),

                                  // Select ticket number
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Ticket Quantity"),
                                      DropdownButton(
                                        value: ticketNumber,
                                        icon: const Icon(Icons.arrow_downward),
                                        iconSize: 24,
                                        elevation: 16,
                                        underline: Container(
                                          height: 2,
                                          color: kPrimaryColor,
                                        ),
                                        onChanged: (newValue) {
                                          setState(() {
                                            ticketNumber = newValue;
                                          });
                                          getPrice();
                                        },
                                        items: ["1", "2", "3"]
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),

                                  // Select ticket type:
                                  DropdownButton(
                                    value: ticketType,
                                    icon: const Icon(Icons.arrow_downward),
                                    iconSize: 24,
                                    elevation: 16,
                                    underline: Container(
                                      height: 2,
                                      color: kPrimaryColor,
                                    ),
                                    onChanged: (newValue) {
                                      setState(() {
                                        ticketType = newValue;
                                      });
                                      getPrice();
                                    },
                                    items: categories
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Seating Plan:
                  widget.event.seatingPlan != null
                      ? Container(
                          width: isSmallScreen
                              ? media.width
                              : scaffoldSize * (2 / 3),
                          child: Image.network(
                            widget.event.seatingPlan,
                          ),
                        )
                      : Container(
                          width: isSmallScreen
                              ? media.width
                              : scaffoldSize * (2 / 3),
                        ),
                ],
              ),
              !isSmallScreen
                  ? SizedBox(
                      width: 10,
                    )
                  : Container(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 500,
                    width: isSmallScreen ? media.width : scaffoldSize * (1 / 3),
                    // Selected tickets box:
                    child: Scaffold(
                      appBar: AppBar(
                        backgroundColor: kPrimaryColor,
                        automaticallyImplyLeading: false,
                        title: Text("Your Tickets"),
                      ),
                      body: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            border: Border.all(),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(child: Text("Selected Date")),
                                  Flexible(child: Text(ticketDate)),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                      child: Text("Selected Ticket Number")),
                                  Flexible(child: Text(ticketNumber)),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(child: Text("Selected Ticket Type")),
                                  Flexible(child: Text(ticketType)),
                                ],
                              ),
                              SizedBox(height: 30),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(child: Text("Total Price")),
                                  Flexible(
                                      child: Text("${total.toString()}\$")),
                                ],
                              ),
                              SizedBox(height: 50),
                              OutlinedButton(
                                child: Text("Continue"),
                                onPressed: () {
                                  if (isLoggedIn) {
                                    if ((ticketDate != 'Select Date') &&
                                        (ticketType != 'Select Category')) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CheckOut(
                                            eventname: widget.event.name,
                                            date: ticketDate,
                                            type: ticketType,
                                            number: ticketNumber,
                                            price: price.toString(),
                                            total: total.toString(),
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                              SizedBox(height: 20),
                              !isLoggedIn
                                  ? Text("Please log in to continue!",
                                      style: TextStyle(color: Colors.redAccent))
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // QR CODE IS DONE FOR EVALUATION
                  Container(
                    width: isSmallScreen ? media.width : scaffoldSize * (1 / 3),
                    child: Html(
                        data:
                            "<a href='https://form.jotform.com/Demirci_Emre/justicket-evaluation-form' rel='no-follow'><img src='https://www.jotform.com/uploads/Demirci_Emre/form_files/213453479284059_1639910883_qrcode_muse.png' width='100%' style='max-width: 200px' alt='QR Code for Jotform form'/></a>"),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomTab extends StatelessWidget {
  const CustomTab({this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Center(
        child: Text(
          this.text,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
            color: kPrimaryColor,
          ),
        ),
      ),
    );
  }
}
