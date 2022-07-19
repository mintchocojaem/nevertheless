

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../../data/todo.dart';
import '../../../notification/notification.dart';
class PomodoroTimer extends StatefulWidget{

  PomodoroTimer({Key? key, required this.controller, required this.todayTodoList}) : super(key: key);
  final List<Todo> todayTodoList;
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
  String? text;
  int initDuration = 0;
  bool isNotification = true;
  late DateTime startTimeLog;
  Todo? todo;
  List<Map<String,dynamic>> durationList = [{
    "todo" : null,
    "startTime" : null,
    "endTime" : null,
  }];

  final storage = GetStorage();   // instance of getStorage class

  @override
  initState(){

    DateTime now = DateTime.now();
    durationList = List.empty(growable: true);

    if(widget.todayTodoList.isNotEmpty){
      if(now.compareTo(stringToDateTime(widget.todayTodoList.first.startTime!)) == -1){
        durationList.add(
            {"todo" : null,
              "startTime" : now,
              "endTime" : stringToDateTime(widget.todayTodoList.first.startTime!)
            }
        );
      }

      for (int i = 0; i < widget.todayTodoList.length; i++) {

        if(now.compareTo(stringToDateTime(widget.todayTodoList[i].startTime!)) >= 0 &&
            now.compareTo(stringToDateTime(widget.todayTodoList[i].endTime!))  == -1){

          durationList.add(
              {"todo" : widget.todayTodoList[i],
                "startTime" : stringToDateTime(widget.todayTodoList[i].startTime!)
                    .add(Duration(hours: now.hour - stringToDateTime(widget.todayTodoList[i].startTime!).hour,
                    minutes: now.minute - stringToDateTime(widget.todayTodoList[i].startTime!).minute,
                    seconds: now.second)),
                "endTime" : stringToDateTime(widget.todayTodoList[i].endTime!),
              }
          );
          //print("12");

        }else{
          if(now.compareTo(stringToDateTime(widget.todayTodoList[i].startTime!)) >= 0 &&
              now.compareTo(stringToDateTime(widget.todayTodoList[i].endTime!))  >= 0){
            durationCounter++;
          }

          durationList.add(
              {"todo" : widget.todayTodoList[i],
                "startTime" : stringToDateTime(widget.todayTodoList[i].startTime!),
                "endTime" : stringToDateTime(widget.todayTodoList[i].endTime!)
              }
          );
        }

        if((widget.todayTodoList[i] != widget.todayTodoList.last)
            && subtractDateTimeToInt(stringToDateTime(widget.todayTodoList[i].endTime!),
                stringToDateTime(widget.todayTodoList[i+1].startTime!)) > 0){
          durationList.add(
              {"todo" : null,
                "startTime" : now.compareTo(stringToDateTime(widget.todayTodoList[i].endTime!)) == -1
                    ? stringToDateTime(widget.todayTodoList[i].endTime!)
                    : now,
                "endTime" : stringToDateTime(widget.todayTodoList[i+1].startTime!)
              }
          );
          //print("13");
        }
      }

      initDuration =  durationList.isNotEmpty && DateTime.now().compareTo(durationList.last["endTime"]) == -1
          ? subtractDateTimeToInt(durationList[durationCounter]["startTime"],
          durationList[durationCounter]["endTime"]) : 1;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    isNotification = storage.read('notification') ?? true;

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
                textStyle: const TextStyle(fontSize: 24.0, color: Colors.white, fontWeight: FontWeight.bold),
                textFormat: CountdownTextFormat.HH_MM_SS,
                isReverse: true,
                isReverseAnimation: false,
                isTimerTextShown: true,
                autoStart: true,
                onStart: () {

                  if(widget.todayTodoList.isNotEmpty){

                    DateTime now = DateTime.now();
                    if(initDuration != 1){
                      todo = durationList[durationCounter]["todo"];
                      isItRest = durationList[durationCounter]["todo"] != null ? false: true;
                      text = durationList[durationCounter]["todo"] != null
                          ? "진행중 : ${durationList[durationCounter]["todo"].title}"
                          : durationList[durationCounter+1]["todo"] != null ?
                      "대기중 : ${durationList[durationCounter+1]["todo"].title}" : "모든 일정 종료";
                    }else{
                      text = "진행 가능한 일정 없음";
                    }
                    if (!isItRest) {
                      print("doStudy");
                      startTimeLog = DateTime(
                          now.year, now.month, now
                          .day, now.hour, now.minute, 0
                      );
                    } else {
                      print("doRest");
                    }
                  }

                },
                onComplete: () {

                  if(widget.todayTodoList.isNotEmpty){

                    DateTime now = DateTime.now();

                    setState(() {

                      if (!isItRest && todo != null) {
                        print("didStudy");
                        if(todo!.timeLog == null){
                          todo!.timeLog = [0,0,0,0,0,0,0];
                        }
                        todo!.timeLog![now.weekday-1] = todo!.timeLog![now.weekday-1]!
                            + subtractDateTimeToInt(startTimeLog, now)~/60;
                        //Notification
                        if (isNotification) {
                          taskNotification(todo!.id!, "Nevertheless",
                              "\"${todo!.title!}\" 시간 종료 (타임차트 기록)");
                        }
                      } else {
                        isItRest = false;
                        print("didRest");
                        //Notification
                        if (isNotification) {
                          taskNotification(999, "Nevertheless", "휴식시간 종료");
                        }
                      }

                      if (initDuration!=1 && todo?.id != widget.todayTodoList.last.id) {
                        durationCounter++;
                        widget.controller.restart(
                            duration: subtractDateTimeToInt( durationList[durationCounter]["startTime"],
                                durationList[durationCounter]["endTime"]));
                      }else if(initDuration!=1 && todo?.id == widget.todayTodoList.last.id){
                        text = "모든 일정 종료";
                      }

                    });
                  }
                }),
            FutureBuilder(
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return widget.todayTodoList.isNotEmpty ? Text(
                    text ?? "",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400)) : Container();
              }),
            const SizedBox(
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

  return result;
}
