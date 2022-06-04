import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomodoro/app/data/model/task.dart';
import 'package:pomodoro/app/ui/index_screen.dart';
import 'package:pomodoro/app/ui/page/todo/widgets/input_field.dart';
import 'package:weekday_selector/weekday_selector.dart';

class TaskDetailPage extends StatefulWidget {
  const TaskDetailPage({Key? key, required this.task}) : super(key: key);
  final Task task;

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage>{

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  String _startDate = DateFormat('hh:mm a').format(DateTime.now());
  String _endDate = DateFormat('hh:mm a').format(DateTime.now().add(Duration(minutes: 15)));

  final int _selectedColor = 0;
  bool restEnabled = false;
  List<bool> dayValues = List.filled(7, false);

  @override
  void initState() {
    // TODO: implement initState
    for(int i = 0; i < dayValues.length; i++){
      dayValues[i] = widget.task.repeat![i];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _titleController.text = widget.task.title!;
    _noteController.text = widget.task.note == null ? "" : widget.task.note!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Todo Detail"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12, left: 12),
            child: IconButton(
                onPressed: (){
                  _submitStartTime();
                  _submitEndTime();
                  if (_formKey.currentState!.validate()) {
                    _saveTaskToDB(widget.task);
                    Navigator.pop(context);
                  }
                },
                icon: Icon(Icons.check)),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 15, left: 20, right: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  InputField(
                    boldText: true,
                    isEditable: true,
                    hint: widget.task.title!,
                    label: 'Title',
                    iconOrdrop: 'icon',
                    controller: _titleController,
                    emptyText: false,
                    fontSize: 17,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InputField(
                    boldText: true,
                    isEditable: true,
                    hint: widget.task.note!,
                    label: 'Note',
                    iconOrdrop: 'icon',
                    controller: _noteController,
                    emptyText: true,
                    fontSize: 17,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  WeekdaySelector(
                    firstDayOfWeek: 0,
                    onChanged: (int day) {
                      setState(() {
                        // Use module % 7 as Sunday's index in the array is 0 and
                        // DateTime.sunday constant integer value is 7.
                        final index = day % 7;
                        // We "flip" the value in this example, but you may also
                        // perform validation, a DB write, an HTTP call or anything
                        // else before you actually flip the value,
                        // it's up to your app's needs.
                        dayValues[index] = !dayValues[index];
                      });
                    },
                    shortWeekdays: ["Mon","Tue","Wed","Thr","Fri","Sat","Sun"],
                    values: dayValues,

                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Text("Study",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                              width: 165,
                              child: InputField(
                                isEditable: false,
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
                                emptyText: false,
                              )),
                          SizedBox(
                              width: 165,
                              child: InputField(
                                controller: _endTimeController,
                                isEditable: false,
                                iconOrdrop: 'button',
                                label: 'End Time',
                                hint: _endDate.toString(),
                                widget: IconButton(
                                  icon: Icon(Icons.access_time),
                                  onPressed: () {
                                    _selectEndTime(context);
                                  },
                                ),
                                emptyText: false,
                              )),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Text("Rest",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Switch(
                            value: restEnabled,
                            onChanged: (value){
                              setState((){
                                restEnabled = !restEnabled;
                              });
                            }),
                          SizedBox(
                              width: 165,
                              child: InputField(
                                isEnabled: restEnabled,
                                isEditable: false,
                                label: 'Start Time',
                                iconOrdrop: 'button',
                                hint: _startDate.toString(),
                                widget: IconButton(
                                  icon: Icon(Icons.access_time),
                                  onPressed: () {
                                    _selectStartTime(context);
                                  },
                                ),
                                emptyText: false,
                              )),
                          SizedBox(
                              width: 165,
                              child: InputField(
                                isEnabled: restEnabled,
                                isEditable: false,
                                iconOrdrop: 'button',
                                label: 'End Time',
                                hint: _endDate.toString(),
                                widget: IconButton(
                                  icon: Icon(Icons.access_time),
                                  onPressed: () {
                                    _selectEndTime(context);
                                  },
                                ),
                                emptyText: false,
                              )),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _saveTaskToDB(Task task) {
    task.color = -_selectedColor;
    task.title = _titleController.text;
    task.note = _noteController.text;
    task.startTime = _startDate;
    task.endTime = _endDate;
    task.repeat = dayValues;
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
