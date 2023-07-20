import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/sidebar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/models/event.dart';
import '../models/announcement.dart';
import '../utils/eventslider.dart';
import '../utils/animatedeventcard.dart';
import '../utils/eventcard.dart';
import '../utils/announcementtile.dart';
import '../utils/appbars.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/getuser.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSmallScreen = false;
  List<Event> events = [];
  List<Event> featuredEvents = [];
  List<Announcement> announcements = [];

  Future getEvents(String type) async {
    // Local host for django and endpoint for homepage
    final url = Uri.parse('http://127.0.0.1:8000/api/homepage');

    final requestBody = {
      "email": isLoggedIn ? currentUser.email : "",
      "type": type,
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

        if (type == "normal") {
          final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
          events = parsed.map<Event>((json) => Event.fromJson(json)).toList();

          setState(() {});
        } else if (type == "featured") {
          final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
          featuredEvents =
              parsed.map<Event>((json) => Event.fromJson(json)).toList();

          setState(() {});
        }
      }
    } catch (error) {
      print("Error: $error");

      // An error occured, please try again later.
    }
  }

  Future getAnnouncements() async {
    // Local host for django and endpoint for announcements
    final url = Uri.parse('http://127.0.0.1:8000/api/announcements');

    try {
      final response = await http.get(url);

      // Succesfull transmission
      if (response.statusCode >= 200 && response.statusCode < 300) {
        print("Transmission was succesfull!!!");

        final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

        announcements = parsed
            .map<Announcement>((json) => Announcement.fromJson(json))
            .toList();

        setState(() {});
      }
    } catch (error) {
      print("Error: $error");

      // An error occured, please try again later.
    }
  }

  Future getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey("email") && prefs.getString("email") != "") {
      getUser(prefs.getString("email"));
    }
  }

  @override
  void initState() {
    getPrefs();
    getEvents("featured");
    getEvents("normal");
    getAnnouncements();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    bool smallScreen = false;

    // Effective integer division, convert the result to int
    final crossAxisCount = media.width ~/ 400;
    if (media.width < 550) smallScreen = true;

    return Scaffold(
      appBar: selectAppbar(context),
      drawer: isLoggedIn ? SideDrawer() : Container(),
      body: ListView(
        children: [
          // Slider on top if the screen is small:
          smallScreen ? eventSlider(featuredEvents) : Container(),

          // If the screen is not small, slider and announcements in a row:
          Row(
            children: [
              // Image slider for featured events:
              !smallScreen
                  ? Expanded(
                      child: eventSlider(featuredEvents),
                    )
                  : Container(),

              // Announcements list:
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 300,
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: announcements.length,
                    itemBuilder: (context, i) {
                      return AnnouncementTile(
                        announcement: announcements[i],
                      );
                    },
                    separatorBuilder: (context, i) => Divider(),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(
            height: 10,
          ),

          // List of events:
          crossAxisCount > 0
              ? GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 2,
                    crossAxisCount: crossAxisCount,
                  ),
                  itemCount: events.length,
                  itemBuilder: (context, i) {
                    return AnimatedEventCard(
                      event: events[i],
                    );
                  },
                )
              : Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    for (var e in events)
                      SmallEventCard(
                        event: e,
                      ),
                  ],
                ),
        ],
      ),
    );
  }
}
