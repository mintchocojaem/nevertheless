import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nevertheless/app/ui/page/setting/pages/setting_page.dart';
import 'package:nevertheless/app/ui/page/timechart/pages/time_chart.dart';
import 'package:nevertheless/app/ui/page/timer/pages/timer_page.dart';
import 'package:nevertheless/app/ui/page/todo/pages/task_page.dart';

import '../controller/bottom_nav_controller.dart';
import '../data/model/task.dart';
import '../notification/notification.dart';
import 'common_widgets/message_popup.dart';

List<Task> taskList = [
  Task(
      id: 0,
      title: "수학",
      note: "1",
      startTime: DateFormat('hh:mm a').format(DateTime.now().add(Duration(minutes: 1))),
      endTime: DateFormat('hh:mm a').format(DateTime.now().add(Duration(minutes: 3))),
      startTimeLog: [
        DateTime.now().add(Duration(minutes: 30)),
        DateTime.now().add(Duration(days: 1,minutes: 40))
      ],
      endTimeLog: [
        DateTime.now().add(Duration(minutes: 50)),
        DateTime.now().add(Duration(days: 1,minutes: 60))
      ],
      color: 0xff328938,
      repeat: [false,false,true,false,false,false,false]
  ),
  Task(
      id: 1,
      title: "과학",
      note: "1",
      startTime: DateFormat('hh:mm a').format(DateTime.now()),
      endTime: DateFormat('hh:mm a').format(DateTime.now().add(Duration(minutes: 1))),

      startTimeLog: [
        DateTime.now(),
        //DateTime.now().add(Duration(days: 1))
      ],
      endTimeLog: [
        DateTime.now().add(Duration(minutes: 20)),
        //DateTime.now().add(Duration(days: 1,minutes: 30))
      ],
      color: 0xff808080,
      repeat: [false,false,true,true,false,false,false]
  )
];


class IndexScreen extends GetView<BottomNavController> {

  IndexScreen({Key? key}) : super(key: key);

  static int position = 0;
  @override
  Widget build(BuildContext context) {


    return WillPopScope(
      onWillPop: willPopAction,
      child: Obx(() => Scaffold(
        body: Center(
          child:
            IndexedStack(
              index: position,
              children: <Widget>[
                TimerPage(taskList: taskList,),
                TaskPage(taskList: taskList),
                TimeChartPage(taskList: taskList,),
                SettingPage(),
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
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          ],
        ),
      )),
    );
  }
  Future<bool> willPopAction() async {
    showDialog(
        context: Get.context!,
        builder: (context) => MessagePopup(
          title: 'Pomodoro',
          message: '정말 종료하시겠습니까?',
          okCallback: () {
            exit(0);
          },
          cancelCallback: Get.back,
        ));
    return true;
  }

}
