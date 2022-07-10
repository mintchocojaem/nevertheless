
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

import '../../../../data/model/task.dart';
import '../../../../notification/notification.dart';
import '../../todo/pages/task_detail.dart';
import '../widgets/pomodoro_timer.dart';

typedef Refresh = void Function();

class TimerPage extends StatefulWidget {
  TimerPage({Key? key, required this.taskList }) : super(key: key);
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
    pomodoroTaskList = List.empty(growable: true);

    widget.taskList.sort((a,b) =>
        DateFormat('hh:mm a').parse(a.startTime!)
            .compareTo( DateFormat('hh:mm a').parse(b.startTime!)));

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

        durationList.add(
            (((stringToTimeOfDay(i.endTime!).hour - stringToTimeOfDay(i.startTime!).hour) * 60) * 60)
                + (((stringToTimeOfDay(i.endTime!).minute - stringToTimeOfDay(i.startTime!).minute) * 60))
        );
        pomodoroTaskList.add(i.title!);
      }

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

    print(durationList);
    print(pomodoroTaskList);

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
            pomodoroTaskList.isNotEmpty ? Expanded(
              child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  children: taskWidgetList,
              ),
            ) :  Container(
              child: Text("오늘 일정이 없습니다", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
            ),
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: floatingVisible,
        child: Transform.scale(
          scale: 1.5,
          child: pomodoroTaskList.isNotEmpty ? FloatingActionButton(
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
          ) : null,
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
