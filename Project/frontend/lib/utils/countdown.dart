import 'package:quiver/async.dart';
import 'package:flutter/material.dart';

class Timer extends StatefulWidget {
  const Timer({Key key}) : super(key: key);

  @override
  _TimerState createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  CountdownTimer countDownTimer;
  var sub;
  Duration timer = Duration(minutes: 5);
  Duration current;
  String timerText = "5:00";

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    countDownTimer = null;
    sub.cancel();
    super.dispose();
  }

  void startTimer() {
    countDownTimer = new CountdownTimer(
      timer,
      new Duration(seconds: 1),
    );

    sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() {
        //_current = _start - duration.elapsed.inSeconds;
        current = timer - duration.elapsed;
        if (current != null) {
          timerText =
              '${current.inMinutes.remainder(60).toString()}:${current.inSeconds.remainder(60).toString().padLeft(2, '0')}';
        }
      });
    });

    sub.onDone(() {
      print("Done");
      sub.cancel();
      // Return to previous page
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      /*
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 0,
        ),
      ),
      */
      child: Text(
        "$timerText",
        style: TextStyle(fontSize: 20, color: Colors.redAccent),
      ),
    );
  }
}
