import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nevertheless/app/ui/page/timechart/pages/time_chart.dart';
import 'package:nevertheless/app/ui/page/timer/pages/timer_page.dart';
import 'package:nevertheless/app/ui/page/todo/pages/task_page.dart';
import '../controller/bottom_nav_controller.dart';
import '../data/model/task.dart';

List<Task> taskList = [
  /*
  Task(
      id: 0,
      title: "수학",
      note: "1",
      startTime: DateFormat('hh:mm a').format(DateTime.now().add(Duration(minutes: 1))),
      endTime: DateFormat('hh:mm a').format(DateTime.now().add(Duration(minutes: 2))),
      color: 0xff328938,
      repeat: [true,true,true,true,false,true,true]
  ),
  Task(
      id: 1,
      title: "과학",
      note: "1",
      startTime: DateFormat('hh:mm a').format(DateTime.now().add(Duration(minutes: 2))),
      endTime: DateFormat('hh:mm a').format(DateTime.now().add(Duration(minutes: 3))),
      color: 0xff808080,
      repeat: [true,true,true,true,false,true,true]
  ),
  Task(
      id: 2,
      title: "영어",
      note: "1",
      startTime: DateFormat('hh:mm a').format(DateTime.now().add(Duration(minutes: -1))),
      endTime: DateFormat('hh:mm a').format(DateTime.now().add(Duration(minutes: 1))),
      timeLog: [0,0,0,0,1,0,1],
      color: 0xff808080,
      repeat: [true,true,true,true,false,true,true]
  ),

   */
];


class IndexScreen extends GetView<BottomNavController> {

  IndexScreen({Key? key}) : super(key: key);

  static int position = 0;

  @override
  Widget build(BuildContext context) {

    return Obx(() => Scaffold(
        body: Center(
          child:
            IndexedStack(
              index: position,
              children: <Widget>[
                TimerPage(taskList: taskList,),
                TaskPage(taskList: taskList),
                TimeChartPage(taskList: taskList,),
              ],
            )
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: controller.pageIndex.value,
          elevation: 0,
          onTap: (value) {
            controller.changeBottomNav(value);
            position = value;
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Timer'),
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Todo'),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'TimeChart'),
          ],
        ),
      ),
    );
  }


}
