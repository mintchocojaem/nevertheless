import 'package:hive/hive.dart';
import 'package:nevertheless/app/data/model/task.dart';
//part of 'task_model.dart';

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      id: fields[0] as int?,
      title: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.id)
      ..write(obj.title);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TaskAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}
