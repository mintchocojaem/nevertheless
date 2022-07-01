import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pomodoro/app/controller/bottom_nav_controller.dart';
import 'package:pomodoro/app/ui/common_widgets/message_popup.dart';
import 'package:pomodoro/app/ui/page/setting/pages/setting_page.dart';
import 'package:pomodoro/app/ui/page/timechart/pages/time_chart.dart';
import 'package:pomodoro/app/ui/page/timer/pages/timer_page.dart';
import 'package:pomodoro/app/ui/page/todo/pages/task_page.dart';

import '../data/model/task.dart';

List<Task> taskList = [
  Task(
      id: 0,
      title: "수학",
      note: "1",
      date:  DateFormat.yMd().format(DateTime.now()),
      startTime: DateFormat('hh:mm a').format(DateTime.now()),
      endTime: DateFormat('hh:mm a').format(DateTime.now().add(Duration(minutes: 1))),
      restStartTime: DateFormat('hh:mm a').format(DateTime.now()),
      restEndTime: DateFormat('hh:mm a').format(DateTime.now().add(Duration(minutes: 1))),
      color: 0,
      repeat: [false,false,false,false,true,false,false],
  )
];


class IndexScreen extends GetView<BottomNavController> {

  IndexScreen({Key? key}) : super(key: key);

  static int position = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
      onWillPop: willPopAction,
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
