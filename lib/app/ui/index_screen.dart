import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pomodoro/app/controller/bottom_nav_controller.dart';
import 'package:pomodoro/app/ui/common_widgets/message_popup.dart';
import 'package:pomodoro/app/ui/page/setting/pages/setting_page.dart';
import 'package:pomodoro/app/ui/page/timer/pages/timer_page.dart';
import 'package:pomodoro/app/ui/page/todo/pages/task_page.dart';


class IndexScreen extends GetView<BottomNavController> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Obx(() => Scaffold(
        body: Center(
          child: IndexedStack(
            index: controller.pageIndex.value,
            children: [
              TimerPage(),
              TaskPage(taskList: []),
              SettingPage()
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: controller.pageIndex.value,
          elevation: 0,
          onTap: (value) {
            controller.changeBottomNav(value);
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Timer'),
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Todo'),
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
          title: '모모두',
          message: '정말 종료하시겠습니까?',
          okCallback: () {
            exit(0);
          },
          cancelCallback: Get.back,
        ));
    return true;
  }

}
