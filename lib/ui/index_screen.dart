import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nevertheless/ui/timechart/pages/time_chart.dart';
import 'package:nevertheless/ui/timer/pages/timer_page.dart';
import 'package:nevertheless/ui/todo/pages/task_page.dart';
import '../controller/bottom_nav_controller.dart';
import '../data/task.dart';

List<Task> taskList = [];

class IndexScreen extends GetView<BottomNavController> {

  IndexScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: loadTaskList(),
      builder: (context, snapshot) {
        if(snapshot.hasData == false){
          return CircularProgressIndicator();
        }else{
          return Obx (() =>Scaffold(
            body: Center(
                child:
                IndexedStack(
                  index: controller.pageIndex.value,
                  children: <Widget>[
                    TimerPage(taskList: taskList,),
                    TaskPage(taskList: taskList),
                    TimeChartPage(taskList: taskList,)
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
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Timer'),
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Todo'),
                BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'TimeChart'),
              ],
            ),
          ));
        }
      }
    );
  }

}
