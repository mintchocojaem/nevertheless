

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
  int durationCounter = 0;
  bool isItRest = false;
  String text="";
  final storage = GetStorage();   // instance of getStorage class
  int initDuration = 0;
  bool isNotification = true;

  late DateTime startTimeLog;

  Task? task;
  List<Map<String,dynamic>> durationList = [{
    "task" : null,
    "startTime" : null,
    "endTime" : null,
  }];

  @override
  initState(){
    DateTime now = DateTime.now();

    durationList = List.empty(growable: true);


    if(now.compareTo(stringToDateTime(widget.todayTaskList.first.startTime!)) == -1){
      durationList.add(
          {"task" : null,
            "startTime" : now,
            "endTime" : stringToDateTime(widget.todayTaskList.first.startTime!)
          }
      );
    }


    for (int i = 0; i < widget.todayTaskList.length; i++) {

      if(now.compareTo(stringToDateTime(widget.todayTaskList[i].startTime!)) >= 0 &&
          now.compareTo(stringToDateTime(widget.todayTaskList[i].endTime!))  == -1){

        durationList.add(
            {"task" : widget.todayTaskList[i],
              "startTime" : stringToDateTime(widget.todayTaskList[i].startTime!)
                  .add(Duration(hours: now.hour - stringToDateTime(widget.todayTaskList[i].startTime!).hour,
                  minutes: now.minute - stringToDateTime(widget.todayTaskList[i].startTime!).minute,
                  seconds: now.second)),
              "endTime" : stringToDateTime(widget.todayTaskList[i].endTime!),
            }
        );
        //print("12");

      }else{
        if(now.compareTo(stringToDateTime(widget.todayTaskList[i].startTime!)) >= 0 &&
            now.compareTo(stringToDateTime(widget.todayTaskList[i].endTime!))  >= 0){
          durationCounter++;
        }

        durationList.add(
            {"task" : widget.todayTaskList[i],
              "startTime" : stringToDateTime(widget.todayTaskList[i].startTime!),
              "endTime" : stringToDateTime(widget.todayTaskList[i].endTime!)
            }
        );
      }

      if((widget.todayTaskList[i] != widget.todayTaskList.last)
          && subtractDateTimeToInt(stringToDateTime(widget.todayTaskList[i].endTime!),
              stringToDateTime(widget.todayTaskList[i+1].startTime!)) > 0){
        durationList.add(
            {"task" : null,
              "startTime" : now.compareTo(stringToDateTime(widget.todayTaskList[i].endTime!)) == -1
                  ? stringToDateTime(widget.todayTaskList[i].endTime!)
                  : now,
              "endTime" : stringToDateTime(widget.todayTaskList[i+1].startTime!)
            }
        );
        //print("13");
      }
    }

    initDuration =  durationList.isNotEmpty && DateTime.now().compareTo(durationList.last["endTime"]) == -1
        ? subtractDateTimeToInt(durationList[durationCounter]["startTime"],
        durationList[durationCounter]["endTime"])
        : 1;

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    isNotification = storage.read('notification') ?? true;
      print(durationList);


      return Column(
          children: [
            CircularCountDownTimer(
                duration : initDuration,
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
                    fontSize: 24.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textFormat: CountdownTextFormat.HH_MM_SS,
                isReverse: true,
                isReverseAnimation: false,
                isTimerTextShown: true,
                autoStart: true,
                onStart: () {

                  DateTime now = DateTime.now();
                  print(durationCounter);
                  if(initDuration != 1){
                    task = durationList[durationCounter]["task"];
                    isItRest = durationList[durationCounter]["task"] != null ? false: true;

                    text = durationList[durationCounter]["task"] != null
                        ? "진행중 : ${task?.title!}" : durationList[durationCounter+1]["task"] != null ?
                    "대기중 : ${durationList[durationCounter+1]["task"].title}" : "모든 일정 종료";
                  } else{
                    text = "진행 가능한 일정 없음";
                  }

                  /*
                  if (!isItRest) {
                    print("doStudy");

                    startTimeLog = DateTime(
                        now.year, now.month, now
                        .day, now.hour, now.minute, 0
                    );
                  } else {
                    print("doRest");
                  }

                   */

                },
                onComplete: () {

                  DateTime now = DateTime.now();
                  setState(() {
                    /*
                    if (!isItRest) {
                      print("didStudy");

                      if (task?.startTimeLog == null) {
                        task?.startTimeLog = List.empty(growable: true);
                        task?.startTimeLog!.add(startTimeLog);
                      } else {
                        task?.startTimeLog!.add(startTimeLog);
                      }

                      if (task?.endTimeLog == null) {
                        task?.endTimeLog = List.empty(growable: true);
                        task?.endTimeLog!.add(DateTime(
                            now.year, now.month, now.day, now
                            .hour, now.minute, 0
                        ));
                      } else {
                        task?.endTimeLog!.add(DateTime(
                            now.year, now.month,now.day,
                            now.hour, now.minute, 0
                        ));
                      }
                      //Notification
                      if (isNotification) {

                        taskNotification(task!.id!, "Nevertheless",
                            "\"${task!.title!}\" 시간 종료 (타임차트 기록)");

                      }
                    } else {
                      isItRest = false;
                      print("didRest");
                      //Notification
                      if (isNotification) {
                        taskNotification(999, "Nevertheless", "휴식시간 종료");
                      }
                    }*/

                      if (initDuration!=1 && task?.id != widget.todayTaskList.last.id) {

                        print(durationList.map((e) => e.values));
                        durationCounter++;

                        widget.controller.restart(
                            duration: subtractDateTimeToInt( durationList[durationCounter]["startTime"],
                                durationList[durationCounter]["endTime"]));

                      }else if(initDuration!=1 && task?.id == widget.todayTaskList.last.id){
                        text = "모든 일정 종료";
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

int dateTimeToSecond(DateTime startTime, DateTime endTime){
  return ((endTime.hour - startTime.hour) * 60 * 60) +
      ((endTime.minute - startTime.minute) * 60) + (endTime.second - startTime.second);
}

DateTime stringToDateTime(String time){
  DateTime now = DateTime.now();
  final format = DateFormat.jm(); //"6:00 AM"
  var tod = TimeOfDay.fromDateTime(format.parse(time));
  var result = DateTime(now.year,now.month,now.day,tod.hour, tod.minute, 0);
  return result;
}

int subtractDateTimeToInt(DateTime startTime, DateTime endTime){

  DateTime time;
  int result = 0;
  startTime.compareTo(endTime) <= -1 ?
  time =  endTime.subtract(Duration(hours: startTime.hour,minutes: startTime.minute,seconds: startTime.second))
  :  time =  startTime.subtract(Duration(hours: endTime.hour,minutes: endTime.minute,seconds: endTime.second));

  startTime.compareTo(endTime) <= -1 ?
  result = ((time.hour * 60 * 60) + (time.minute * 60) + time.second)
      : result = - ((time.hour * 60 * 60) + (time.minute * 60) + time.second);
  //print(startTime);
  //print(endTime);
  //print(time);
  //print(result);
  return result;
}
