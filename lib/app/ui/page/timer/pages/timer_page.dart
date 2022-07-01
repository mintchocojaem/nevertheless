
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomodoro/app/data/model/task.dart';
import 'package:pomodoro/app/ui/index_screen.dart';
import 'package:pomodoro/app/ui/page/timer/widgets/pomodoro_timer.dart';

import '../../todo/pages/task_detail.dart';

class TimerPage extends StatefulWidget {
  TimerPage({Key? key, required this.taskList}) : super(key: key);
  @override
  State<TimerPage> createState() => _TimerPageState();
  List<Task> taskList;
}

class _TimerPageState extends State<TimerPage> {

  List<Widget> taskWidgetList = [];
  List<String> pomodoroTaskList = [];
  List<int> durationList = [];
  int durationCounter = 0;
  final CountDownController countDownController = CountDownController();
  int countdownFlag = 0; // 0 start, 1 stop, 2 resume
  bool floatingVisible =  true;

  @override
  Widget build(BuildContext context) {

    taskWidgetList = List.empty(growable: true);
    durationList = List.empty(growable: true);
    for( Task i in widget.taskList){
      if(i.repeat![DateTime.now().weekday-1]){
      taskWidgetList.add(
        Card(
            child: ListTile(
              title: Text(i.title!),
              subtitle: Text(i.note!),
              trailing: Text(i.startTime! + " ~ " + i.endTime!),
              onTap: (){
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context)=> TaskDetailPage(task: i))
                ).then((value) {
                  setState(() {

                  });
                });
              },
            )
        ));
      }
      durationList.add(
          (((stringToTimeOfDay(i.endTime!).hour - stringToTimeOfDay(i.startTime!).hour) * 60) * 60)
          + (((stringToTimeOfDay(i.endTime!).minute - stringToTimeOfDay(i.startTime!).minute) * 60))
      );
      pomodoroTaskList.add(i.title!);
    }
    for( Task i in widget.taskList){
      if(i.restStartTime != null && i.restEndTime != null && i.repeat![DateTime.now().weekday-1]){
        taskWidgetList.add(
          Card(
              child: ListTile(
                title: Text("Rest Time"+" ("+ i.title! +")"),
                trailing: Text(i.restStartTime! + " ~ " + i.restEndTime!),
                onTap: (){
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context)=> TaskDetailPage(task: i))
                  ).then((value) {
                    setState(() {

                    });
                  });
                },
              )
          ),
        );
        durationList.add((((stringToTimeOfDay(i.restEndTime!).hour - stringToTimeOfDay(i.restStartTime!).hour) * 60) * 60)
            + ((stringToTimeOfDay(i.restEndTime!).minute - stringToTimeOfDay(i.restStartTime!).minute) * 60));
        pomodoroTaskList.add("Rest Time"+" ("+ i.title! +")");
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Timer'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                child: Center(
                  child: PomodoroTimer(taskList: pomodoroTaskList,durationList: durationList,controller: countDownController),
                )
            ),
            Expanded(
              child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  children: taskWidgetList
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: floatingVisible,
        child: Transform.scale(
          scale: 1.5,
          child: FloatingActionButton(
            child: Row(
              children: [
                Icon(Icons.play_arrow,color: Colors.white70,),
                Text('Play',style: TextStyle(color: Colors.white70,fontWeight: FontWeight.w600,
                    fontSize: 12),),
              ],
            ),
            onPressed: () {
              if(countdownFlag == 0){
                countDownController.start();
                countdownFlag = 1;
                floatingVisible = false;
                setState((){});
              }
              /*
              else if(countdownFlag == 1){
                countDownController.pause();
                countdownFlag = 2;

              }
              else{
                countDownController.resume();
                countdownFlag = 1;
              }

               */

            },
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
TimeOfDay stringToTimeOfDay(String tod) {
  final format = DateFormat.jm(); //"6:00 AM"
  return TimeOfDay.fromDateTime(format.parse(tod));
}
