import 'package:hive_flutter/hive_flutter.dart';

//part 'task.g.dart';

// typeId는 절대 중복되면 안된다.
@HiveType(typeId: 1)
class Task{
  @HiveField(0)       // 등록을 하고나면 절대 숫자를 바꿔주면 안된다.
  int? id;
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? note;
  @HiveField(3)
  int? isCompleted;
  @HiveField(4)
  String? date;
  @HiveField(5)
  String? startTime;
  @HiveField(6)
  String? endTime;
  @HiveField(7)
  int? color;
  @HiveField(8)
  int? remind;
  @HiveField(9)
  String? repeat;

  Task({
    this.id,
    this.title,
    this.note,
    this.isCompleted,
    this.date,
    this.startTime,
    this.endTime,
    this.color,
    this.remind,
    this.repeat,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'remind': remind,
      'repeat': repeat,
      'color': color,
      'isCompleted': isCompleted,
    };
  }

  Task.fromMap(Map<String, dynamic> task){
    id =  task['id'];
    title = task['title'];
    note = task['note'];
    date = task['date'];
    startTime = task['startTime'];
    endTime = task['endTime'];
    remind = task['remind'];
    repeat = task['repeat'];
    color = task['color'];
    isCompleted = task['isCompleted'];

  }
}
