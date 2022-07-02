import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weekday_selector/weekday_selector.dart';

import '../../../../data/model/task.dart';
import '../widgets/input_field.dart';

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
  final TextEditingController _startRestTimeController = TextEditingController();
  final TextEditingController _endRestTimeController = TextEditingController();

  String? _startDate;
  String? _endDate;
  String? _restStartDate ;
  String? _restEndDate;
  final int _selectedColor = 0;
  bool restEnabled = false;
  List<bool> dayValues = List.filled(7, false);

  @override
  void initState() {
    // TODO: implement initState
    for(int i = 0; i < dayValues.length; i++){
      dayValues[i] = widget.task.repeat![i];
    }
    _startDate = widget.task.startTime;
    _endDate = widget.task.endTime;
    _restStartDate = widget.task.restStartTime;
    _restEndDate = widget.task.restEndTime;
    restEnabled = widget.task.restStartTime != null && widget.task.restEndTime != null;
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
                    height: 25,
                  ),
                  Column(
                    children: [
                      Text("Study",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                      SizedBox(
                        height: 25,
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
                    height: 25,
                  ),
                  Column(
                    children: [
                      Text("Rest",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Switch(
                            value: restEnabled,
                            onChanged: (value){
                              setState((){
                                restEnabled = !restEnabled;
                                if(!restEnabled){
                                  _restStartDate = null;
                                  _restEndDate = null;
                                }
                              });
                            }),
                          SizedBox(
                              width: 165,
                              child: InputField(
                                controller: _startRestTimeController,
                                isEnabled: restEnabled,
                                isEditable: false,
                                label: 'Start Time',
                                iconOrdrop: 'button',
                                hint: _restStartDate ?? "없음",
                                widget: IconButton(
                                  icon: Icon(Icons.access_time),
                                  onPressed: () {
                                    _selectRestStartTime(context);
                                  },
                                ),
                                emptyText: true,
                              )),
                          SizedBox(
                              width: 165,
                              child: InputField(
                                controller: _endRestTimeController,
                                isEnabled: restEnabled,
                                isEditable: false,
                                iconOrdrop: 'button',
                                label: 'End Time',
                                hint: _restEndDate ?? "없음",
                                widget: IconButton(
                                  icon: Icon(Icons.access_time),
                                  onPressed: () {
                                    _selectRestEndTime(context);
                                  },
                                ),
                                emptyText: true,
                              )),
                        ],
                      ),

                    ],
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  Center(
                    child: IconButton(icon: Icon(Icons.delete_outline), onPressed: () {

                    },),
                  ),
                  const SizedBox(
                    height: 48,
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
    if(restEnabled) {
      task.restStartTime = _restStartDate;
      task.restEndTime = _restEndDate;
    } else{
      task.restStartTime = null;
      task.restEndTime = null;
    }
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
    _startTimeController.text = _startDate!;
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

  _selectRestStartTime(BuildContext context) async {
    final TimeOfDay? selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    String formattedTime = selected!.format(context);
    setState(() {
      _restStartDate = formattedTime;
    });
  }
  _selectRestEndTime(BuildContext context) async {
    final TimeOfDay? selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    String formattedTime = selected!.format(context);
    setState(() {
      _restEndDate = formattedTime;
    });
  }

  _submitEndTime() {
    _endTimeController.text = _endDate!;
  }

}
