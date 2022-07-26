import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weekday_selector/weekday_selector.dart';
import '../../../data/todo.dart';
import '../../index_page.dart';
import '../widgets/input_field.dart';
import '../widgets/customColorPicker.dart';

class TodoDetailPage extends StatefulWidget {
  const TodoDetailPage({Key? key, required this.todo}) : super(key: key);
  final Todo todo;

  @override
  State<TodoDetailPage> createState() => _TodoDetailPageState();
}

class _TodoDetailPageState extends State<TodoDetailPage>{

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  String? _startDate;
  String? _endDate;

  late Color pickerColor;

  List<bool> dayValues = List.filled(7, false);

  @override
  void initState() {
    // TODO: implement initState

    for(int i = 0; i < dayValues.length; i++){
      dayValues[i] = widget.todo.repeat![i];
    }
    _startDate = widget.todo.startTime;
    _endDate = widget.todo.endTime;
    pickerColor = Color(widget.todo.color!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    _titleController.text = widget.todo.title!;
    _noteController.text = widget.todo.note == null ? "" : widget.todo.note!;
    _startTimeController.text = _startDate!;
    _endTimeController.text = _endDate!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Todo 정보"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12, left: 12),
            child: IconButton(
                onPressed: (){

                  if (_formKey.currentState!.validate()) {
                    _saveTodo(widget.todo);
                  }
                },
                icon: Icon(Icons.check)),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 15, left: 20, right: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  InputField(
                    boldText: true,
                    isEditable: true,
                    hint: widget.todo.title!,
                    label: '제목',
                    controller: _titleController,
                    emptyText: false,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  InputField(
                    boldText: true,
                    isEditable: true,
                    hint: widget.todo.note!,
                    label: '메모',
                    controller: _noteController,
                    emptyText: true,
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
                    shortWeekdays: const ["Mon","Tue","Wed","Thr","Fri","Sat","Sun"],
                    values: dayValues,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      const Icon(Icons.alarm,size: 30,),
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
                                        label: '시작 시각',
                                        hint: _startDate.toString(),
                                        emptyText: false,
                                      ),
                                    ),
                              ),
                              SizedBox(
                                  width: 100,
                                  child: InputField(
                                    onTap: () async{
                                      await _selectEndTime(context);
                                    },
                                    controller: _endTimeController,
                                    isEditable: false,
                                    label: '종료 시각',
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
                  SizedBox(
                    height: 80,
                    child: Stack(
                      children: [
                        const Align(
                          child: Icon(Icons.color_lens_rounded,size: 30,),
                          alignment: Alignment.centerLeft,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: MaterialButton(
                              height: 32,
                              color: pickerColor,
                              shape: const CircleBorder(),
                              onPressed: (){
                                showDialog(context: context,
                                    builder: (BuildContext context) =>
                                        CustomColorPicker(
                                            bgColor: ThemeData.dark().primaryColor,
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
                    child: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () {

                      showCupertinoDialog(context: context, builder: (context) {
                        return CupertinoAlertDialog(
                          title: const Text("일정 삭제"),
                          content: Text("\"${_titleController.text}\" 일정을 삭제하시겠습니까?"),
                          actions: [
                            CupertinoDialogAction(isDefaultAction: false, child: const Text("확인",style: TextStyle(color: Colors.red),),
                                onPressed: () {
                                  FlutterLocalNotificationsPlugin().cancel(widget.todo.id!);
                                  todoList.remove(widget.todo);
                                  saveTodo();
                                  Get.offAll(() => IndexScreen());
                                }
                            ),
                            CupertinoDialogAction(isDefaultAction: false, child: Text("취소"), onPressed: () {
                              Navigator.pop(context);
                            })
                          ],
                        );
                      });
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

  _saveTodo(Todo todo) {

    Todo temp = Todo(
      id: todo.id,
      color: pickerColor.value,
      title: _titleController.text,
      note: _noteController.text,
      startTime: _startDate,
      endTime:  _endDate,
      repeat: dayValues,
      timeLog: todo.timeLog
    );


    if(DateFormat('hh:mm a').parse(temp.endTime!).compareTo(DateFormat('hh:mm a').parse(temp.startTime!)) == 0 ){
      ScaffoldMessenger.of(context)
          .showSnackBar(
          SnackBar(
              backgroundColor: ThemeData.dark().backgroundColor,
              content: const Text("종료 시각이 시작 시각과 같습니다",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),)));

    }else if(DateFormat('hh:mm a').parse(temp.endTime!).compareTo(DateFormat('hh:mm a').parse(temp.startTime!)) < 0){
      ScaffoldMessenger.of(context)
          .showSnackBar(
          SnackBar(
              backgroundColor: ThemeData.dark().backgroundColor,
              content: const Text("종료 시각이 시작 시각보다 작습니다",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),)));
    }else if(!dayValues.contains(true)){
      ScaffoldMessenger.of(context)
          .showSnackBar(
          SnackBar(
              backgroundColor: ThemeData.dark().backgroundColor,
              content: const Text("요일을 선택해주세요",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),)));
    } else{

      if(!temp.isTimeNested(schedule: temp, todoList: todoList)){
        todo.id = temp.id;
        todo.color = temp.color;
        todo.title = temp.title;
        todo.note = temp.note;
        todo.startTime = temp.startTime;
        todo.endTime = temp.endTime;
        todo.repeat = temp.repeat;
        todo.timeLog = temp.timeLog;

        saveTodo();
        Get.offAll(() => IndexScreen());

      }else{
        ScaffoldMessenger.of(context)
            .showSnackBar(
            SnackBar(
                backgroundColor: ThemeData.dark().backgroundColor,
                content: const Text("해당 시간에 다른 일정이 존재합니다",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),)));
      }
    }

  }

  _selectStartTime(BuildContext context) async {
    final TimeOfDay? selected = await showTimePicker(
      context: context,
      initialTime: stringToTimeOfDay(_startDate!),
      cancelText: "취소",
      confirmText: "확인"
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
      cancelText: "취소",
      confirmText: "확인"
    );
    if(selected != null){
      String formattedTime = selected.format(context);
      setState(() {
        _endDate = formattedTime;
      });
    }

  }

  TimeOfDay stringToTimeOfDay(String tod) {
    final format = DateFormat.jm(); //"6:00 AM"
    return TimeOfDay.fromDateTime(format.parse(tod));
  }

}
