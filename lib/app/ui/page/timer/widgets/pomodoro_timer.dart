

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PomodoroTimer extends StatefulWidget{
  const PomodoroTimer({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PomodoroTimer();
  }

}

class _PomodoroTimer extends State<PomodoroTimer>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  CircularCountDownTimer(
        duration: 100,
        initialDuration: 0,
        controller: CountDownController(),
        width: MediaQuery.of(context).size.width / 3,
        height: MediaQuery.of(context).size.height / 3,
        ringColor: Colors.grey,
        ringGradient: null,
        fillColor: Colors.black45,
        fillGradient: null,
        backgroundColor: Colors.black12,
        backgroundGradient: null,
        strokeWidth: 5.0,
        strokeCap: StrokeCap.round,
        textStyle: TextStyle(
            fontSize: 24.0, color: Colors.white, fontWeight: FontWeight.bold),
        textFormat: CountdownTextFormat.HH_MM_SS,
        isReverse: true,
        isReverseAnimation: false,
        isTimerTextShown: true,
        autoStart: true,
        onStart: () {
          print('Countdown Started');
        },
        onComplete: () {
          print('Countdown Ended');
        },
      );

  }

}