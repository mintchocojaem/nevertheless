import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'dart:math' as math;
import '../../../data/todo.dart';
import '../../index_page.dart';
import '../widgets/input_field.dart';
import '../widgets/customColorPicker.dart';

class TodoAddPage extends StatefulWidget {

  const TodoAddPage({Key? key, required this.todoList}) : super(key: key);
  final List<Todo> todoList;
  @override
  State<TodoAddPage> createState() => _TodoAddPageState();

}

class _TodoAddPageState extends State<TodoAddPage> {


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

    _startDate = DateFormat('hh:mm a').format(DateTime.now());
    _endDate =  DateFormat('hh:mm a').format(DateTime.now().add(Duration(minutes: 30)));
    pickerColor = Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    _startTimeController.text = _startDate!;
    _endTimeController.text = _endDate!;

    return Scaffold(
     appBar: AppBar(
       centerTitle: true,
       title: const Text("Todo 추가"),
       actions: [
         Padding(
           padding: const EdgeInsets.only(right: 12, left: 12),
           child: IconButton(
               onPressed: (){
                 if (_formKey.currentState!.validate()) {
                   _saveTodo();
                 }
               },
               icon: const Icon(Icons.check)),
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
                   label: '제목',
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
                   label: '메모',
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
                       final index = day % 7;
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
               ],
             ),
           ),
         ),
       ),
     ),
   );
  }

  _saveTodo() {

    Todo temp = Todo(
      id: null,
      color: pickerColor.value,
      title: _titleController.text,
      note: _noteController.text,
      startTime: _startDate,
      endTime:  _endDate,
      repeat: dayValues,
    );
    temp.id = temp.generateID(todoList);

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

          widget.todoList.add(temp);
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
