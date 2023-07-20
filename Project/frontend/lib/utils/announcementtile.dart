import '../models/announcement.dart';
import 'package:flutter/material.dart';

class AnnouncementTile extends StatelessWidget {
  const AnnouncementTile({this.announcement});

  final Announcement announcement;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Icon(Icons.add_alert),
          SizedBox(
            width: 2,
          ),
          Flexible(
            child: Text(this.announcement.content),
          ),
        ],
      ),
    );
  }
}
