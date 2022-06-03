import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomodoro/app/data/model/task.dart';
import 'package:pomodoro/app/ui/page/todo/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  AddTaskPage({Key? key, required this.taskList}) : super(key: key);

  final List<Task> taskList;

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {


  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();


  String _selectedDate = DateFormat.yMd().format(DateTime.now());
  String _startDate = DateFormat('hh:mm a').format(DateTime.now());
  String _endDate = DateFormat('hh:mm a').format(DateTime.now().add(Duration(minutes: 15)));

  List<int> reminderList = [5, 10, 15, 20];

  final int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("add Todo"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 15, left: 20, right: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Add Task",
                        style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  InputField(
                    isEnabled: true,
                    hint: 'Enter Title',
                    label: 'Title',
                    iconOrdrop: 'icon',
                    controller: _titleController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InputField(
                    isEnabled: true,
                    hint: 'Enter Note',
                    label: 'Note',
                    iconOrdrop: 'icon',
                    controller: _noteController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InputField(
                    controller: _dateController,
                    isEnabled: false,
                    hint: '${_selectedDate.toString()}',
                    label: 'Date',
                    iconOrdrop: 'button',
                    widget: IconButton(
                      icon: Icon(Icons.date_range),
                      onPressed: () {
                        _selectDate(context);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: 165,
                          child: InputField(
                            isEnabled: false,
                            controller: _startTimeController,
                            label: 'Start Time',
                            iconOrdrop: 'button',
                            hint: _startDate.toString(),
                            widget: IconButton(
                              icon: Icon(Icons.access_time),
                              onPressed: () {
                                _selectStartTime(context);
                              },
                            ),
                          )),
                      SizedBox(
                          width: 165,
                          child: InputField(
                            controller: _endTimeController,
                            isEnabled: false,
                            iconOrdrop: 'button',
                            label: 'End Time',
                            hint: _endDate.toString(),
                            widget: IconButton(
                              icon: Icon(Icons.access_time),
                              onPressed: () {
                                _selectEndTime(context);
                              },
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CupertinoButton(
                          onPressed: () async {
                            _submitDate();
                            _submitStartTime();
                            _submitEndTime();
                            if (_formKey.currentState!.validate()) {
                              final Task task = Task();
                              _addTaskToDB(task);
                              widget.taskList.add(task);
                              Navigator.pop(context);
                            }
                          },
                             child: Text('add Task'),)
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _addTaskToDB(Task task) {
    task.color = -_selectedColor;
    task.title = _titleController.text;
    task.note = _noteController.text;
    task.date = _selectedDate.toString();
    task.startTime = _startDate;
    task.endTime = _endDate;
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      currentDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),

    );
    setState(() {
      if(selected != null){
        _selectedDate = DateFormat.yMd().format(selected).toString();
      }
      else {
        _selectedDate = DateFormat.yMd().format(DateTime.now()).toString();
      }
    });
  }

  _submitDate() {
    _dateController.text = _selectedDate;
  }

  _selectStartTime(BuildContext context) async {
    final TimeOfDay? selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    String formattedTime = selected!.format(context);
    setState(() {
      _startDate = formattedTime;
    });
  }

  _submitStartTime() {
    _startTimeController.text = _startDate;
  }

  _selectEndTime(BuildContext context) async {
    final TimeOfDay? selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    String formattedTime = selected!.format(context);
    setState(() {
      _endDate = formattedTime;
    });
  }

  _submitEndTime() {
    _endTimeController.text = _endDate;
  }

}
