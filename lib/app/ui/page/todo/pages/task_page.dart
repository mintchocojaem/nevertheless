import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pomodoro/app/data/model/task.dart';
import 'package:pomodoro/app/ui/page/todo/pages/add_task_page.dart';
import 'package:pomodoro/app/ui/page/todo/widgets/task_tile.dart';
import 'package:pomodoro/main.dart';
import 'package:pomodoro/app/ui/page/todo/pages/task_detail.dart';
import 'package:pomodoro/app/ui/components/size_config.dart';


class TaskPage extends StatefulWidget {

  const TaskPage({Key? key, required this.taskList}) : super(key: key);
  final List<Task> taskList;

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {

  DateTime selectDate = DateTime.now();
  List<Task> dateTodoList = [];
  late int day;
  @override
  void initState() {
    // TODO: implement initState
    SizeConfig.orientation = Orientation.portrait;
    SizeConfig.screenHeight = 100;
    SizeConfig.screenWidth = 100;
    day = selectDate.day;
    for(var i in widget.taskList){
      Task task = i;
      if (task.repeat![selectDate.weekday-1] == true){
        dateTodoList.add(task);
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Todo"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              _dateBar(),
              dateTodoList.isNotEmpty ? _tasks() : Container(),
              dateTodoList.isEmpty ? Expanded(
                child: Container(
                  child: _noTasksMessage(),
                ),
              ) : Container()
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "btn",
        backgroundColor: Colors.deepPurpleAccent,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddTaskPage(taskList: widget.taskList,)))
          .then((value) => setState((){}));
        }
      ),

    );
  }

  Widget _dateBar() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: DatePicker(
        DateTime.now(),
        initialSelectedDate: DateTime.now(),
        onDateChange: (newDate) {
          setState(() {
            selectDate = newDate;
            dateTodoList= [];
            for(var i in widget.taskList){
              Task task = i;
              if (task.repeat![selectDate.weekday-1] == true){
                dateTodoList.add(task);
              }
            }
          });
        },
        selectionColor: Colors.deepPurpleAccent,
        width: 70,
        height: 100,
        selectedTextColor: Colors.black,
        dayTextStyle:
            TextStyle(color: Colors.white ),
        dateTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold),
        monthTextStyle:
            TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _tasks() {
    return Expanded(child:
     AnimationLimiter(
        child:  ListView.builder(
            scrollDirection:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? Axis.vertical
                    : Axis.horizontal,
            itemCount: dateTodoList.length,
            itemBuilder: (BuildContext context, int index) {

                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: Duration(milliseconds: 500 + index * 20),
                  child: SlideAnimation(
                    horizontalOffset: 400.0,
                    child: FadeInAnimation(
                      child: GestureDetector(
                        onTap: () =>
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context)=> TaskDetailPage(task: dateTodoList[index]))
                            ).then((value) {
                              setState(() {

                              });
                            }),
                        child: TaskTile(task: dateTodoList[index]),
                      ),
                    ),
                  ),
                );

            }),
        )
    );
  }


  Widget _noTasksMessage() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MediaQuery.of(context).orientation == Orientation.portrait
                ? const SizedBox(
                    height: 0,
                  )
                : const SizedBox(
                    height: 50,
                  ),
            Icon(Icons.task_rounded),
            const SizedBox(
              height: 20,
            ),
            Text("There Is No Tasks"),
          ],
        ),
      ),
    );
  }
}
