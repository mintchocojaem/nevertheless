
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
  int duration = 0;

  @override
  void initState() {

    // TODO: implement initState
    for( Task i in widget.taskList){
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
        ),
      );
      duration += (((stringToTimeOfDay(i.endTime!).hour - stringToTimeOfDay(i.startTime!).hour) * 60) * 60)
          + ((stringToTimeOfDay(i.endTime!).minute - stringToTimeOfDay(i.startTime!).minute) * 60);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

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
                  child: PomodoroTimer(duration: duration),
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
      floatingActionButton:Transform.scale(
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
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
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
