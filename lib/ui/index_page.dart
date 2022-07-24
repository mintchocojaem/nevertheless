import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nevertheless/ui/timechart/pages/chart_page.dart';
import 'package:nevertheless/ui/timer/pages/timer_page.dart';
import 'package:nevertheless/ui/todo/pages/todo_page.dart';
import '../controller/bottom_nav_controller.dart';
import '../data/todo.dart';

List<Todo> todoList = [];

class IndexScreen extends GetView<BottomNavController> {

  const IndexScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Obx (() => Scaffold(
      body: Center(
          child:
          IndexedStack(
            index: controller.pageIndex.value,
            children: <Widget>[
              TimerPage(todoList: todoList,),
              TodoPage(todoList: todoList),
              ChartPage(todoList: todoList,)
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
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Chart'),
        ],
      ),
    ));
  }

}

loadTodoList(){
  final storage = GetStorage();
  List list = storage.read("todoList") ?? [];
  todoList = [];
  for(var i in list){
    todoList.add(Todo(
      id :  i['id'],
      title : i['title'],
      note : i['note'],
      startTime : i['startTime'],
      endTime : i['endTime'],
      color : i['color'],
      repeat : i['repeat'],
      timeLog : i['timeLog'],
    ));
  }
}

void saveTodo() {
  final storage = GetStorage();
  List list = List.empty(growable: true);
  for(Todo i in todoList){
    list.add(i.toMap());
  }
  storage.write("todoList", list);
}
