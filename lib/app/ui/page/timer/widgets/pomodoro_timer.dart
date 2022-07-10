

import 'dart:async';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:nevertheless/app/ui/page/timechart/pages/time_chart.dart';
import '../../../../data/model/task.dart';
import '../../../../notification/notification.dart';
import '../../../index_screen.dart';

class PomodoroTimer extends StatefulWidget{

  PomodoroTimer({Key? key, required this.controller, required this.todayTaskList}) : super(key: key);
  final List<Task> todayTaskList;
  final CountDownController controller;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PomodoroTimer();
  }

}

class _PomodoroTimer extends State<PomodoroTimer>{

  int counter = 0;
  int taskID = 0;

  bool isItRest = false;
  String text="";
  final storage = GetStorage();   // instance of getStorage class

  bool isNotification = true;

  late DateTime startTimeLog;

  List<Map> durationList = [{
    "id" : null,
    "duration" : null
  }];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    isNotification = storage.read('notification') ?? true;

    durationList = List.empty(growable: true);

    taskID = widget.todayTaskList.first.id ?? 0;


    for (int i = 0; i < widget.todayTaskList.length; i++) {

      durationList.add(
        {
          "id" : widget.todayTaskList[i].id!,
          "duration" :  ((stringToTimeOfDay(widget.todayTaskList[i].endTime!).hour -
        stringToTimeOfDay(widget.todayTaskList[i].startTime!).hour) * 60 * 60)
        + ((stringToTimeOfDay(widget.todayTaskList[i].endTime!).minute -
        stringToTimeOfDay(widget.todayTaskList[i].startTime!).minute) * 60),
        }
      );

      if(widget.todayTaskList.indexOf(widget.todayTaskList[i]) < widget.todayTaskList.lastIndexOf(widget.todayTaskList.last)){
        durationList.add({
          "id" : null,
          "duration" :   ((stringToTimeOfDay(widget.todayTaskList[i+1].startTime!).hour -
              stringToTimeOfDay(widget.todayTaskList[i].endTime!).hour) * 60 * 60)
              + ((stringToTimeOfDay(widget.todayTaskList[i+1].startTime!).minute -
                  stringToTimeOfDay(widget.todayTaskList[i].endTime!).minute) * 60)
        });
      }
    }

    Task task = Task();
    for(Task i in widget.todayTaskList){
      if(i.id == taskID){
        task = i;
        break;
      }
    }

    return Column(
      children: [
        CircularCountDownTimer(
          duration: durationList.isNotEmpty ? durationList[counter]["duration"] : 0,
          initialDuration: 0,
          controller: widget.controller,
          width: MediaQuery
              .of(context)
              .size
              .width / 3,
          height: MediaQuery
              .of(context)
              .size
              .height / 3,
          ringColor: Colors.grey,
          ringGradient: null,
          fillColor: Colors.black45,
          fillGradient: null,
          backgroundColor: Colors.black12,
          backgroundGradient: null,
          strokeWidth: 5.0,
          strokeCap: StrokeCap.round,
          textStyle: TextStyle(
              fontSize: 24.0,
              color: Colors.white,
              fontWeight: FontWeight.bold),
          textFormat: CountdownTextFormat.HH_MM_SS,
          isReverse: true,
          isReverseAnimation: false,
          isTimerTextShown: true,
          autoStart: false,
          onStart: () {

            print('Countdown Started');
            text = "Now : ${durationList[counter]["id"] != null ?
            task.title! : "Waiting"}";

            if (!isItRest) {
              print("doStudy");
              startTimeLog = DateTime(
                  DateTime
                      .now()
                      .year, DateTime
                  .now()
                  .month, DateTime
                  .now()
                  .day, DateTime
                  .now()
                  .hour, DateTime
                  .now()
                  .minute, 0
              );
            } else {
              print("doRest");
            }
          },
          onComplete: () async {
            print('Countdown Ended');
            setState(() {
              if (!isItRest) {
                print("didStudy");

                if (task.startTimeLog == null) {
                  task.startTimeLog = List.empty(growable: true);
                  task.startTimeLog!.add(startTimeLog);
                } else {
                  task.startTimeLog!.add(startTimeLog);
                }

                if (task.endTimeLog == null) {
                  task.endTimeLog = List.empty(growable: true);
                  task.endTimeLog!.add(DateTime(
                      DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now()
                      .hour, DateTime.now().minute, 0
                  ));
                } else {
                  task.endTimeLog!.add(DateTime(
                      DateTime.now().year, DateTime.now().month, DateTime.now().day,
                      DateTime.now().hour, DateTime.now().minute, 0
                  ));
                }
                //Notification
                if (isNotification) {
                  taskNotification(task.id!, "Nevertheless",
                      "\"${task.title!}\" 시간 종료 (타임차트 기록)");
                }
              } else {
                isItRest = false;
                print("didRest");
                //Notification
                if (isNotification) {
                  taskNotification(task.id!, "Nevertheless",
                      "\"${task.title!}\" 휴식시간 종료");
                }
              }

              counter++;
              taskID = widget.todayTaskList[counter].id!;

              if (task != widget.todayTaskList.last) {
                widget.controller.restart(
                    duration: durationList[counter]["duration"]);
              }
            });
          }),
        Text(
          text, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),
        SizedBox(
          height: 24,
        )
      ],
    );
  }
}
