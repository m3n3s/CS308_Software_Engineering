import 'package:flutter/material.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/models/event.dart';
import '../routes/eventdetails.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    this.event,
  });

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        width: 400,
        height: 200,
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Image.network(
                this.event.thumbnail,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        this.event.name,
                        softWrap: true,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_pin,
                              color: kPrimaryColor,
                            ),
                            Flexible(
                              child: Text(
                                this.event.location,
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
                                this.event.date,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SmallEventCard extends StatelessWidget {
  const SmallEventCard({
    this.event,
  });

  final Event event;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        var url = this.event.thumbnail;
        print(url.toString());

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetails(
              event: this.event,
            ),
          ),
        );
      },
      child: Card(
        elevation: 5,
        child: Container(
          width: 175,
          height: 360,
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: Image.network(
                  this.event.thumbnail,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          this.event.name,
                          softWrap: true,
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
                              this.event.location,
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
                              this.event.date,
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
