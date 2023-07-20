import 'package:flutter/material.dart';
import "dart:math";
import 'package:flutter/widgets.dart';
import 'package:frontend/utils/constants.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

void main() => runApp(new LuckyPage());

class LuckyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: kPrimaryColor,
      ),
      home: new MyHomePage(title: 'Justicket Events - Feeling Lucky'),
    );
  }
}
var list = ['Buy the first ticket you see','Buy the ticket at the bottom right side of the page','Buy the third ticket you see today','Ask for free drink to bartender','You dont need luck you are the luck',"Sprint 2 looks good","Sprint 2 looking good good good"];
final _random = new Random();
var element = list[_random.nextInt(list.length)];

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Justicket Events - Feeling Lucky',style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: kPrimaryColor,
      ),
      body: Center(
          child: AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                element,
                textStyle: const TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
                speed: const Duration(milliseconds: 2000),
              ),
            ],

            totalRepeatCount: 4,
            pause: const Duration(milliseconds: 1000),
            displayFullTextOnTap: true,
            stopPauseOnTap: true,
          )
      ),
    );
  }
}