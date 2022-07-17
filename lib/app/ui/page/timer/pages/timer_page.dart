
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
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
  List<Task> todayTaskList = List.empty(growable: true);
  int durationCounter = 0;
  final CountDownController countDownController = CountDownController();
  int countdownFlag = 0; // 0 start, 1 stop, 2 resume
  bool floatingVisible =  true;

  final storage = GetStorage();   // instance of getStorage class
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  bool isNotification = true;


  @override
  Widget build(BuildContext context) {

    taskWidgetList = List.empty(growable: true);
    todayTaskList = List.empty(growable: true);

    widget.taskList.sort((a,b) =>
        DateFormat('hh:mm a').parse(a.startTime!)
            .compareTo( DateFormat('hh:mm a').parse(b.startTime!)));

    isNotification = storage.read('notification') ?? true;


    for( Task i in widget.taskList) {
      if (i.repeat![DateTime.now().weekday - 1] ) {
        taskWidgetList.add(
            Card(
                child: ListTile(
                  title: Text(i.title!),
                  subtitle: Text(i.note!),
                  trailing: Text(i.startTime! + " ~ " + i.endTime!),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                        builder: (context) => TaskDetailPage(task: i))
                    ).then((value) {
                      setState(() {});
                    });
                  },
                )
            ));
        todayTaskList.add(i);
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Timer'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 16),
            child: IconButton(
              icon:  isNotification == true ? Icon(Icons.notifications): Icon(Icons.notifications_off),
              onPressed: (){
                if (isNotification == true) {
                  setState((){
                    storage.write('notification', false);
                    flutterLocalNotificationsPlugin.cancelAll();
                  });
                } else {
                  setState((){
                    storage.write('notification', true);
                  });
                }
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            PomodoroTimer(todayTaskList: todayTaskList,
                controller: countDownController),
            taskWidgetList.isNotEmpty ? Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                children: taskWidgetList,
              ),
            ) : Container(
              child: Text("오늘 일정이 없습니다",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
            ),
          ],
        ),
      ),
    );
  }
}
TimeOfDay stringToTimeOfDay(String tod) {
  final format = DateFormat.jm(); //"6:00 AM"
  return TimeOfDay.fromDateTime(format.parse(tod));
}

