
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:nevertheless/app/ui/index_screen.dart';

//part 'task.g.dart';

// typeId는 절대 중복되면 안된다.
@HiveType(typeId: 1)
class Task{
  @HiveField(0)  // 등록을 하고나면 절대 숫자를 바꿔주면 안된다.
  int? id;
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? note;
  @HiveField(3)
  String? startTime;
  @HiveField(4)
  String? endTime;
  @HiveField(5)
  int? color;
  @HiveField(6)
  List<bool>? repeat;
  @HiveField(9)
  List<DateTime?>? startTimeLog;
  @HiveField(10)
  List<DateTime?>? endTimeLog;

  Task({
    this.id,
    this.title,
    this.note,
    this.startTime,
    this.endTime,
    this.color,
    this.repeat,
    this.startTimeLog,
    this.endTimeLog,
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
      'startTimeLog' : startTimeLog,
      'endTimeLog' : endTimeLog
  };
  }

  Task.fromMap(Map<String, dynamic> task){
    id =  task['id'];
    title = task['title'];
    note = task['note'];
    startTime = task['startTime'];
    endTime = task['endTime'];
    color = task['color'];
    repeat = task['repeat'];
    startTimeLog = task['startTimeLog'];
    endTimeLog = task['endTimeLog'];
  }
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
