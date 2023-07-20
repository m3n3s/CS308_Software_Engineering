import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/utils/appbars.dart';
import 'package:frontend/utils/constants.dart';
import 'package:contactus/contactus.dart';

void main() => runApp(new AboutPage());

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'About',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: kPrimaryColor,
      ),
      home: new MyHomePage(title: 'About Us'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: selectAppbar(context),
        backgroundColor: kPrimaryColor,
        body: Container(
          padding: EdgeInsets.all(50),
          child: ContactUs(
            logo: NetworkImage(
                'https://pbs.twimg.com/profile_images/989856290586464257/qiOcJHGR_400x400.jpg'),
            email: 'justicket43@gmail.com',
            companyName: 'Justicket',
            dividerThickness: 2,
            website: 'https://www.sabanciuniv.edu/en',
            githubUserName: 'm3n3s',
            linkedinURL:
                'https://www.linkedin.com/in/justicket-justicket-215913228/',
            tagLine: 'Group7',
            twitterHandle: '',
          ),
        ),
      ),
    );
  }
}
