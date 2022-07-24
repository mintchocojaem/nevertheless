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

  @override
  Widget build(BuildContext context) {

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
              widget.todoList.isNotEmpty ? _todo() :Expanded(
                child: Container(
                  child: _noTodoMessage(),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff505050),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> TodoAddPage(todoList: widget.todoList,)))
          .then((value) => setState((){}));
        }
      ),

    );
  }

  Widget _todo() {
    return Expanded(child:
     AnimationLimiter(
        child:  ListView.builder(
            itemCount: widget.todoList.length,
            itemBuilder: (BuildContext context, int index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 300),
                  child: SlideAnimation(
                    horizontalOffset: 400.0,
                    child: FadeInAnimation(
                      child: GestureDetector(
                        onTap: () =>
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context)=> TodoDetailPage(todo: widget.todoList[index]))
                            ).then((value) {
                              setState(() {});
                            }),
                        child: TodoTile(todo: widget.todoList[index]),
                      ),
                    ),
                  ),
                );
            }),
        )
    );
  }

  Widget _noTodoMessage() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
