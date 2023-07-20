import 'package:flutter/material.dart';

import 'package:frontend/models/event.dart';
import 'package:frontend/utils/constants.dart';

// CURRENTLY NOT USED ANYWHERE, DID NOT DELETE THIS JUST IN CASE!

class TicketSearch extends StatefulWidget {
  const TicketSearch({this.key, this.event});

  final Event event;
  final Key key;

  @override
  TicketSearchState createState() => TicketSearchState();
}

class TicketSearchState extends State<TicketSearch> {
  String ticketDate = "Select Date";
  String ticketNumber = "1";
  String ticketType = "Please Select";

  @override
  Widget build(BuildContext context) {
    // Search and select ticket:
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Search Tickets"),
      ),
      body: Container(
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
          border: Border.all(),
        ),
        child: Column(
          children: [
            // Select Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  },
                  items: [
                    'Select Date',
                    'Two',
                    'Three',
                    'Four',
                    widget.event.date
                  ].map<DropdownMenuItem<String>>((String value) {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  },
                  items: ["1", "2", "3"]
                      .map<DropdownMenuItem<String>>((String value) {
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
              },
              items: ["Please Select", "Category 1", "Category2"]
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

Widget selectedTickets() {
  // Search ticket and buy ticket:
  return Scaffold(
    appBar: AppBar(
      automaticallyImplyLeading: false,
      title: Text("Your Tickets"),
    ),
    body: Container(
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text("Selection"),
              Text(""),
            ],
          ),
          Row(),
        ],
      ),
    ),
  );
}
