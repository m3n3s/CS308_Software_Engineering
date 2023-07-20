import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/main.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(currentUser.name),
            accountEmail: Text(currentUser.email),
          ),
          ListTile(),
          ListTile(
            title: Text('Upcoming Events'),
            subtitle: Text('View Upcoming Events'),
            leading: Icon(Icons.access_alarms),
            onTap: () => Navigator.pushNamed(
              context,
              '/upcomingevents',
            ),
          ),
          ListTile(
            title: Text('Feedback'),
            leading: Icon(Icons.feedback_rounded),
            onTap: () => Navigator.pushNamed(
              context,
              '/feedbackpage',
            ),
          ),
          ListTile(
            title: Text('Admin Dashboard'),
            leading: Icon(Icons.admin_panel_settings),
            onTap: () => Navigator.pushNamed(
              context,
              '/widgetTree',
            ),
          ),
        ],
      ),
    ));
  }
}
