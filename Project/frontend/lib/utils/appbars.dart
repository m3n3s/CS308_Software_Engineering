import 'package:flutter/material.dart';
import '../main.dart';
import 'constants.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';

BuildContext globalContext;

AppBar selectAppbar(BuildContext context) {
  if (isLoggedIn)
    return finalAppbar(context);
  else
    return initialAppbar(context);
}

AppBar initialAppbar(BuildContext context) {
  return AppBar(
    title: Text("Justicket"),
    backgroundColor: kPrimaryColor,
    automaticallyImplyLeading: false,
    actions: <Widget>[
      RawMaterialButton(
        onPressed: () {
          Navigator.pushNamed(context, "/login");
        },
        child: Text(
          "Login",
        ),
      ),
      RawMaterialButton(
        onPressed: () {
          Navigator.pushNamed(context, "/signup");
        },
        child: Text(
          "Sign Up",
        ),
      )
    ],
  );
}

AppBar finalAppbar(BuildContext context) {
  globalContext = context;
  final media = MediaQuery.of(context).size;
  bool isSmallScreen = false;

  if (media.width < 720) isSmallScreen = true;

  return AppBar(
    title: GestureDetector(
      child: Text("Justicket"),
      onTap: () {
        Navigator.pushNamed(context, "/home");
      },
    ),
    backgroundColor: kPrimaryColor,
    automaticallyImplyLeading: false,
    actions: !isSmallScreen
        ? [
            RawMaterialButton(
              onPressed: () async {
                final url =
                    "https://form.jotform.com/Demirci_Emre/justicket-evaluation-form";
                html.window.open(url, 'new_tab');
              },
              child: Text(
                "Rate Events",
              ),
            ),
            RawMaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, "/lucky");
              },
              child: Text(
                "I am feeling Lucky",
              ),
            ),
            RawMaterialButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/search");
                },
                child: Text(
                  "Filter",
                )),
            RawMaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, "/usersettings");
              },
              child: Text(
                "Settings",
              ),
            ),
            RawMaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, "/about");
              },
              child: Text(
                "About Us",
              ),
            ),
            RawMaterialButton(
              onPressed: () {
                setPrefs();
                Navigator.pushNamed(context, "/home");
              },
              child: Text(
                "Sign Out",
              ),
            ),
          ]
        : [
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {
                  'Rate Events',
                  'I am Feeling Lucky',
                  'Filter',
                  'Settings',
                  'About Us',
                  'Sign Out'
                }.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
  );
}

void handleClick(String value) {
  switch (value) {
    case 'Rate Events':
      final url =
          "https://form.jotform.com/Demirci_Emre/justicket-evaluation-form";
      html.window.open(url, 'new_tab');
      break;
    case 'I am Feeling Lucky':
      Navigator.pushNamed(globalContext, "/lucky");
      break;
    case 'Filter':
      Navigator.pushNamed(globalContext, "/search");
      break;
    case 'Settings':
      Navigator.pushNamed(globalContext, "/usersettings");
      break;
    case 'About Us':
      Navigator.pushNamed(globalContext, "/about");
      break;
    case 'Sign Out':
      setPrefs();
      Navigator.pushNamed(globalContext, "/home");
      break;
  }
}

Future setPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();

  isLoggedIn = false;
  currentUser = null;
}
