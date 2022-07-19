import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:nevertheless/ui/todo/pages/todo_detail_page.dart';
import '../../../data/todo.dart';
import '../widgets/todo_tile.dart';
import 'todo_add_page.dart';


class TodoPage extends StatefulWidget {

  const TodoPage({Key? key, required this.todoList}) : super(key: key);
  final List<Todo> todoList;

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {

  DateTime selectDate = DateTime.now();
  List<Todo> dateTodoList = [];
  late int day;
  @override
  void initState() {
    // TODO: implement initState
    day = selectDate.day;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    dateTodoList = List.empty(growable: true);
    for(var i in widget.todoList){
      Todo task = i;
      if (task.repeat![selectDate.weekday-1] == true){
        dateTodoList.add(task);
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Todo"),
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
        backgroundColor: Colors.deepPurpleAccent,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> TodoAddPage(taskList: widget.todoList,)))
          .then((value) => setState((){}));
        }
      ),

    );
  }

  Widget _dateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: DatePicker(
        DateTime.now(),
        initialSelectedDate: DateTime.now(),
        onDateChange: (newDate) {
          setState(() {
            selectDate = newDate;
            dateTodoList= [];
            for(var i in widget.todoList){
              Todo task = i;
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
            const TextStyle(color: Colors.white ),
        dateTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold),
        monthTextStyle:
            const TextStyle(color: Colors.white),
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
                                .push(MaterialPageRoute(builder: (context)=> TodoDetailPage(todo: dateTodoList[index]))
                            ).then((value) {
                              setState(() {});
                            }),
                        child: TodoTile(todo: dateTodoList[index]),
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
            const Icon(Icons.task_alt),
            const SizedBox(
              height: 20,
            ),
            const Text("일정을 추가해주세요!"),
          ],
        ),
      ),
    );
  }
}