import 'package:hive_flutter/hive_flutter.dart';

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
  String? date;
  @HiveField(4)
  String? startTime;
  @HiveField(5)
  String? endTime;
  @HiveField(6)
  int? color;
  @HiveField(7)
  List<bool>? repeat;
  @HiveField(8)
  String? rest;

  Task({
    this.id,
    this.title,
    this.note,
    this.date,
    this.startTime,
    this.endTime,
    this.color,
    this.repeat,
    this.rest,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'color': color,
      'repeat' : repeat,
      'rest' : rest,
    };
  }

  Task.fromMap(Map<String, dynamic> task){
    id =  task['id'];
    title = task['title'];
    note = task['note'];
    date = task['date'];
    startTime = task['startTime'];
    endTime = task['endTime'];
    color = task['color'];
    repeat = task['repeat'];
    rest = task['rest'];
  }
}
