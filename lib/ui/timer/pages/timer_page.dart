
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../../../data/todo.dart';
import '../../todo/pages/todo_detail_page.dart';
import '../widgets/pomodoro_timer.dart';

typedef Refresh = void Function();

class TimerPage extends StatefulWidget {

  const TimerPage({Key? key, required this.todoList }) : super(key: key);
  @override
  State<TimerPage> createState() => _TimerPageState();
  final List<Todo> todoList;

}

class _TimerPageState extends State<TimerPage> {

  List<Widget> todoWidgetList = [];
  List<Todo> todayTaskList = List.empty(growable: true);
  int durationCounter = 0;
  int countdownFlag = 0; // 0 start, 1 stop, 2 resume
  bool floatingVisible =  true;
  bool isNotification = true;

  final storage = GetStorage();   // instance of getStorage class
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final CountDownController countDownController = CountDownController();

  @override
  Widget build(BuildContext context) {

    todoWidgetList = List.empty(growable: true);
    todayTaskList = List.empty(growable: true);

    widget.todoList.sort((a,b) =>
        DateFormat('hh:mm a').parse(a.startTime!)
            .compareTo( DateFormat('hh:mm a').parse(b.startTime!)));

    isNotification = storage.read('notification') ?? true;

    for( Todo i in widget.todoList) {
      if (i.repeat![DateTime.now().weekday - 1]! ) {
        todoWidgetList.add(
            Card(
              color: Color(i.color!),
                child: ListTile(
                  title: Text(i.title!,maxLines: 1, overflow: TextOverflow.ellipsis,),
                  subtitle: Text(i.note!,maxLines: 1, overflow: TextOverflow.ellipsis,),
                  trailing: Text("${i.startTime!} ~ ${i.endTime!}"),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                        builder: (context) => TodoDetailPage(todo: i))
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
        title: const Text('Timer'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 16),
            child: IconButton(
              icon:  isNotification == true ? const Icon(Icons.notifications): const Icon(Icons.notifications_off),
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
            PomodoroTimer(todayTodoList: todayTaskList,
                controller: countDownController),
            todoWidgetList.isNotEmpty ? Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                children: todoWidgetList,
              ),
            ) : Container()
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

