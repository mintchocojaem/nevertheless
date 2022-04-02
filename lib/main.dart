import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomodoro/pages/settings/setting_page.dart';
import 'package:pomodoro/widgets/pomodoro_timer.dart';
import 'models/task.dart';
import 'pages/task_page.dart';

void main() {
  runApp(
      MaterialApp(
          theme: ThemeData(
          brightness: Brightness.light,
          /* light theme settings */
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          /* dark theme settings */
        ),
        themeMode: ThemeMode.dark,

        initialRoute: '/',
        routes: {
          '/': (context) => MyApp(),
          '/schedulePage': (context) => TaskPage(),
        },

    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static List<Task> taskList = [
    Task(
        id: 0,
        title: "수학",
        note: "1",
        date:  DateFormat.yMd().format(DateTime.now()),
        startTime: DateFormat('hh:mm a').format(DateTime.now()),
        endTime: DateFormat('hh:mm a').format(DateTime.now().add(Duration(minutes: 15))),
        color: 0,
        isCompleted: 0
    ),
    Task(
        id: 1,
        title: "영어",
        note: "1",
        date:  DateFormat.yMd().format(DateTime.now()),
        startTime: DateFormat('hh:mm a').format(DateTime.now()),
        endTime: DateFormat('hh:mm a').format(DateTime.now().add(Duration(minutes: 15))),
        color: 0,
        isCompleted: 0),
  ];

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  List<Widget> taskWidgetList = [];

  @override
  void initState() {
    // TODO: implement initState
    for( Task i in MyApp.taskList){
      taskWidgetList.add(
        Card(
            child: ListTile(
                title: Text("1교시"),
                subtitle: Text(i.title!),
                trailing: Text('10%')
            )
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Pomodoro'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Center(
                child: PomodoroTimer(),
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
      floatingActionButton: Transform.scale(
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
      bottomNavigationBar: BottomNavigationBar(

        onTap: (index){
          if(index == 0){
            Navigator.pushNamed(context, '/');
          }
          else if(index == 1){
            Navigator.pushNamed(context, '/schedulePage');
          }
          else if(index ==2){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SettingPage()));
          }
        },

        items: [
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Timer',),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Todo',),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings',),
        ],

      ),
    );
  }
}
