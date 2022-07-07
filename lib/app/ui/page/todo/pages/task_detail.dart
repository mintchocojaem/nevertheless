import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:nevertheless/app/ui/index_screen.dart';
import 'package:time_picker_widget/time_picker_widget.dart';
import 'package:weekday_selector/weekday_selector.dart';

import '../../../../data/model/task.dart';
import '../widgets/input_field.dart';
import 'CustomColorPicker.dart';

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
  final TextEditingController _restTimeController = TextEditingController();

  String? _startDate;
  String? _endDate;
  String? _restStartDate ;
  String? _restEndDate;
  late Color pickerColor;
  List<Color> colors = [
    Color(0xFFF9D1DE),
    Color(0xFFEBD6EE),
    Color(0xFFC2B7F3),
    Color(0xFF9ED0A0),
    Color(0xFF7CACF7),
  ];
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

    if(_restStartDate !=null && _restEndDate != null){
      _restTimeController.text = (DateFormat('hh:mm a').parse(_restEndDate!)
          .subtract(Duration(hours: DateFormat('hh:mm a').parse(_restStartDate!).hour,
          minutes: DateFormat('hh:mm a').parse(_restStartDate!).minute)).minute
          + (DateFormat('hh:mm a').parse(_restEndDate!)
              .subtract(Duration(hours: DateFormat('hh:mm a').parse(_restStartDate!).hour,
          minutes: DateFormat('hh:mm a').parse(_restStartDate!).minute)).hour *60)
      ).toString();
    }else{
      _restTimeController.text = "0";
    }

    pickerColor = Color(widget.task.color!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    _titleController.text = widget.task.title!;
    _noteController.text = widget.task.note == null ? "" : widget.task.note!;

    _startTimeController.text = _startDate!;
    _endTimeController.text = _endDate!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Todo Detail"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12, left: 12),
            child: IconButton(
                onPressed: (){

                  if (_formKey.currentState!.validate()) {
                    _saveTaskToDB(widget.task);
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
                    controller: _titleController,
                    emptyText: false,
                    fontSize: 17,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  InputField(
                    boldText: true,
                    isEditable: true,
                    hint: widget.task.note!,
                    label: 'Note',
                    controller: _noteController,
                    emptyText: true,
                    fontSize: 17,
                  ),
                  const SizedBox(
                    height: 30,
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
                    height: 30,
                  ),
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Icon(Icons.alarm,size: 30,),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Align(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Center(
                                child: SizedBox(
                                    width: 100,
                                      child: InputField(
                                        onTap: () async{
                                          await _selectStartTime(context);
                                        },
                                        isEditable: false,
                                        controller: _startTimeController,
                                        label: 'Start Time',
                                        hint: _startDate.toString(),
                                        widget: IconButton(
                                          icon: Icon(Icons.access_time),
                                          onPressed: () async{
                                            await _selectStartTime(context);
                                          },
                                        ),
                                        emptyText: false,
                                      ),
                                    ),
                              ),
                              SizedBox(
                                  width: 100,
                                  child: InputField(
                                    onTap: () async{
                                      await _selectStartTime(context);
                                    },
                                    controller: _endTimeController,
                                    isEditable: false,
                                    label: 'End Time',
                                    hint: _endDate.toString(),

                                    emptyText: false,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Icon(Icons.bed,size: 30,),
                      Align(
                        alignment: Alignment.center,
                        child:  SizedBox(
                          width: 100,
                          child: TextFormField(
                            controller: _restTimeController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              // for below version 2 use this
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              labelStyle: TextStyle(height:0.1),
                              labelText: "Rest Minute",
                              hintText: "10m ~ 60m",
                            ),
                            validator: (value){
                              if(value == null) {
                                return null;
                              }else{
                                if(int.parse(value) > 60) {
                                  return 'Rest minute can\'t be bigger than 60';
                                }
                                if(int.parse(value) < 0) {
                                  return 'Rest minute can\'t be lower than 0';
                                }else if(int.parse(value) == 0){
                                  _restTimeController.text = value;
                                  _restStartDate = null;
                                  _restEndDate = null;
                                }else{
                                  _restTimeController.text = value;
                                  _restStartDate = _endDate;
                                  _restEndDate = TimeOfDay(hour:  DateFormat('hh:mm a').parse(_endDate!)
                                      .add(Duration(minutes: int.parse(_restTimeController.text))).hour,
                                      minute:  DateFormat('hh:mm a').parse(_endDate!)
                                          .add(Duration(minutes: int.parse(_restTimeController.text))).minute).format(context);
                                }
                              }

                            },
                          ),
                        ),

                      ),

                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 80,
                    child: Stack(
                      children: [
                        Align(
                          child: Icon(Icons.color_lens_rounded,size: 30,),
                          alignment: Alignment.centerLeft,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: MaterialButton(
                              height: 32,
                              color: pickerColor,
                              shape: CircleBorder(),
                              onPressed: (){
                                showDialog(context: context,
                                    builder: (BuildContext context) =>
                                        CustomColorPicker(
                                            backgroundColor: ThemeData.dark().primaryColor,
                                            colors: colors,
                                            pickerColor: pickerColor,
                                            textColor: ThemeData.dark().textTheme.bodyText1!.color,
                                            onColorSelected: (color) {
                                              setState(() {
                                                pickerColor = color;
                                              });
                                            })
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  Center(
                    child: IconButton(icon: Icon(Icons.delete_outline), onPressed: () {
                      FlutterLocalNotificationsPlugin().cancel(widget.task.id!);
                      taskList.remove(widget.task);
                      Navigator.pop(context);
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

    Task temp = Task(
      id: task.id,
      color: pickerColor.value,
      title: _titleController.text,
      note: _noteController.text,
      startTime: _startDate,
      endTime:  _endDate,
      repeat: dayValues,
      restStartTime:  _restStartDate,
      restEndTime: _restEndDate,
      startTimeLog: task.startTimeLog,
      endTimeLog:  task.endTimeLog,
    );


    if(DateFormat('hh:mm a').parse(temp.endTime!).compareTo(DateFormat('hh:mm a').parse(temp.startTime!)) <= 0 ){
      ScaffoldMessenger.of(context)
          .showSnackBar(
          SnackBar(
              backgroundColor: ThemeData.dark().backgroundColor,
              content: Text("종료시각이 시작시각보다 작거나 같습니다",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),)));
    }else{
      if(!isTimeNested(schedule: temp)){

        task.id = temp.id;
        task.color = temp.color;
        task.title = temp.title;
        task.note = temp.note;
        task.startTime = temp.startTime;
        task.endTime = temp.endTime;
        task.repeat = temp.repeat;
        task.restStartTime = temp.restStartTime;
        task.restEndTime = temp.restEndTime;
        task.startTimeLog = temp.startTimeLog;
        task.endTimeLog = temp.endTimeLog;

        Navigator.pop(context);
      }else{
        ScaffoldMessenger.of(context)
            .showSnackBar(
            SnackBar(
                backgroundColor: ThemeData.dark().backgroundColor,
                content: Text("해당 시간에 다른 일정이 존재합니다",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),)));
      }
    }

  }

  _selectStartTime(BuildContext context) async {
    final TimeOfDay? selected = await showTimePicker(
      context: context,
      initialTime: stringToTimeOfDay(_startDate!),
    );
    if(selected != null){
      String formattedTime = selected.format(context);
      setState(() {
        _startDate = formattedTime;
      });
    }
  }


  _selectEndTime(BuildContext context) async {
    final TimeOfDay? selected = await showTimePicker(
      context: context,
      initialTime: stringToTimeOfDay(_endDate!),
    );
    if(selected != null){
      String formattedTime = selected.format(context);
      setState(() {
        _endDate = formattedTime;
      });
    }

  }

}
TimeOfDay stringToTimeOfDay(String tod) {
  final format = DateFormat.jm(); //"6:00 AM"
  return TimeOfDay.fromDateTime(format.parse(tod));
}
