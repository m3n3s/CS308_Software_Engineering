import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/event.dart';
import '../routes/eventdetails.dart';

Widget eventSlider(List<Event> events) {
  return Container(
    margin: EdgeInsets.all(15),
    child: CarouselSlider.builder(
      itemCount: events.length,
      options: CarouselOptions(
        enlargeCenterPage: true,
        height: 300,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        reverse: false,
        aspectRatio: 5.0,
      ),
      itemBuilder: (context, i, id) {
        return GestureDetector(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.white,
                )),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: events.isNotEmpty
                  ? Image.network(
                      events[i].thumbnail,
                      width: 500,
                      fit: BoxFit.cover,
                    )
                  : Container(),
            ),
          ),
          onTap: () {
            // var url = featuredEvents[i].thumbnail;
            // print(url.toString());

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventDetails(
                  event: events[i],
                ),
              ),
            );
          },
        );
      },
    ),
  );
}
