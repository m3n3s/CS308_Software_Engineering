import 'package:flutter/material.dart';
import 'package:frontend/widget_tree.dart';
import 'package:frontend/routes/upcomingevents.dart';
import 'package:frontend/utils/search.dart';
import 'package:google_fonts/google_fonts.dart';
import 'utils/constants.dart';
import 'routes/home.dart';
import 'routes/signup.dart';
import 'routes/login.dart';
import 'routes/eventdetails.dart';
import 'routes/usersettings.dart';
import 'routes/checkout.dart';
import 'routes/payment.dart';
import 'models/user.dart';
import 'routes/feedbackpage.dart';
import 'routes/lucky.dart';
import 'routes/about.dart';

bool isLoggedIn = false;
User currentUser;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Justicket',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.secularOneTextTheme(),
      ),
      home: HomePage(),
      routes: {
        '/home': (context) => HomePage(),
        '/signup': (context) => SignUp(),
        '/login': (context) => LogIn(),
        '/event-details': (context) => EventDetails(),
        '/usersettings': (context) => UserSettings(),
        '/checkout': (context) => CheckOut(),
        '/payment': (context) => Payment(),
        '/feedbackpage': (context) => FeedbackPage(),
        '/lucky': (context) => LuckyPage(),
        '/about': (context) => AboutPage(),
        '/upcomingevents': (context) => UpcomingEventsPage(),
        '/search': (context) => ListViewFiltering(),
        '/widgetTree': (context) => WidgetTree()
      },
    );
  }
}
