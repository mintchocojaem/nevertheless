import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../ui/index_screen.dart';

class Task{

  int? id;
  String? title;
  String? note;
  String? startTime;
  String? endTime;
  int? color;
  List? repeat;
  List? timeLog;

  Task({
    this.id,
    this.title,
    this.note,
    this.startTime,
    this.color,
    this.repeat,
    this.endTime,
    this.timeLog
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'startTime': startTime,
      'endTime': endTime,
      'color': color,
      'repeat' : repeat,
      'timeLog' : timeLog
    };
  }

  bool isTimeNested({required Task schedule}){

    TimeOfDay stringToTimeOfDay(String tod) {
      final format = DateFormat.jm(); //"6:00 AM"
      return TimeOfDay.fromDateTime(format.parse(tod));
    }

    for(Task i in taskList){
      for(int j =0; j < 7; j++){
        if((i.id != schedule.id) && (schedule.repeat![j] ==true && i.repeat![j] == true)){
          if((stringToTimeOfDay(schedule.startTime!).hour < stringToTimeOfDay(i.startTime!).hour ||
              (stringToTimeOfDay(schedule.startTime!).hour == stringToTimeOfDay(i.startTime!).hour
                  && stringToTimeOfDay(schedule.startTime!).minute < stringToTimeOfDay(i.startTime!).minute))
              &&(stringToTimeOfDay(schedule.endTime!).hour > stringToTimeOfDay(i.startTime!).hour ||
                  (stringToTimeOfDay(schedule.endTime!).hour == stringToTimeOfDay(i.startTime!).hour
                      && stringToTimeOfDay(schedule.endTime!).minute > stringToTimeOfDay(i.startTime!).minute))){
            return true;
          } else if(
          (stringToTimeOfDay(schedule.startTime!).hour > stringToTimeOfDay(i.startTime!).hour ||
              (stringToTimeOfDay(schedule.startTime!).hour == stringToTimeOfDay(i.startTime!).hour &&
                  stringToTimeOfDay(schedule.startTime!).minute >= stringToTimeOfDay(i.startTime!).minute))
              &&(stringToTimeOfDay(schedule.startTime!).hour < stringToTimeOfDay(i.endTime!).hour ||
              (stringToTimeOfDay(schedule.startTime!).hour == stringToTimeOfDay(i.endTime!).hour &&
                  stringToTimeOfDay(schedule.startTime!).minute < stringToTimeOfDay(i.endTime!).minute))
          ){
            return true;
          }else{
            return false;
          }
        }
      }
    }

    return false;
  }

  int generateID(List<Task> taskList){

    int id = 0;
    List<int> idList = List.empty(growable: true);

    for(Task i in taskList){
      idList.add(i.id!);
    }
    for(int j = 0; j < 128; j++){
      if(!idList.contains(j)){
        id = j;
        break;
      }
    }

    return id;
  }

}

Future<List> loadTaskList() async{

  final storage = GetStorage();
  List list = await storage.read("taskList");
  taskList = [];
  for(var i in list){
    taskList.add(Task(
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
  return list;
}

void saveTask() async{
  final storage = GetStorage();
  List list = List.empty(growable: true);
  for(Task i in taskList){
    list.add(i.toMap());
  }
  await storage.write("taskList", list);
}

