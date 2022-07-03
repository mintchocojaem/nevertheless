

import 'dart:async';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../notification/notification.dart';
import '../../../index_screen.dart';

class PomodoroTimer extends StatefulWidget{

  PomodoroTimer({Key? key, required this.durationList, required this.controller, required this.taskList}) : super(key: key);
  final List durationList;
  final List taskList;
  final CountDownController controller;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PomodoroTimer();
  }

}

class _PomodoroTimer extends State<PomodoroTimer>{

  int durationCounter = 0;
  int taskCounter = 0;
  bool isItRest = false;
  String text="";
  final storage = GetStorage();   // instance of getStorage class

  bool isNotification = true;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    isNotification = storage.read('notification') ?? true;

    return  Column(
      children: [
        CircularCountDownTimer(
            duration: widget.durationList.isNotEmpty  ? widget.durationList[0] :  0,
            initialDuration: 0,
            controller: widget.controller,
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
            autoStart: false,
            onStart: () {
              print('Countdown Started');
              text = "Now : "+widget.taskList[durationCounter];


              if(!isItRest){
                print("doStudy");
                if (taskList[taskCounter].startTimeLog == null){
                  taskList[taskCounter].startTimeLog = List.empty(growable: true);
                  taskList[taskCounter].startTimeLog!.add(DateTime(
                      DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute,0
                  ));
                }else{
                  taskList[taskCounter].startTimeLog!.add(DateTime(
                      DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute,0
                  ));
                }

              }else{
                print("doRest");
              }
            },
            onComplete: () async {
              print('Countdown Ended');
              setState((){
                durationCounter++;
                if(!isItRest){
                  print("didStudy");
                  if (taskList[taskCounter].endTimeLog == null){
                    taskList[taskCounter].endTimeLog = List.empty(growable: true);
                    taskList[taskCounter].endTimeLog!.add(DateTime(
                      DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute,0
                    ));
                  }else{
                    taskList[taskCounter].endTimeLog!.add(DateTime(
                        DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute,0
                    ));
                  }
                  //Notification
                  if(isNotification){
                    taskNotification(taskList[taskCounter].id!, "Nevertheless",
                        "\"${taskList[taskCounter].title!}\" 시간 종료");
                  }

                }else{
                  isItRest = false;
                  print("didRest");
                  //Notification
                  if(isNotification){
                    taskNotification(taskList[taskCounter].id!, "Nevertheless",
                        "\"${taskList[taskCounter].title!}\" 휴식시간 종료");
                  }

                }
                if(taskList[taskCounter].restStartTime != null && taskList[taskCounter].restEndTime != null){
                  taskCounter -=1;
                  isItRest = true;
                }
                taskCounter++;
                widget.controller.restart(duration: widget.durationList[durationCounter]);


              });
            },
          ),
        Text(text, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),
        SizedBox(
          height: 24,
        )
      ],
    );

  }

}
