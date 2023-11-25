import 'package:todo_app_with_getx/app/data/models/alarm.dart';
import 'package:todo_app_with_getx/app/data/models/task.dart';
import 'package:todo_app_with_getx/app/data/provider/clock/provider.dart';
import 'package:todo_app_with_getx/app/data/provider/task/provider.dart';

class TaskRepository {
  TaskProvider taskProvider;
  TaskRepository({required this.taskProvider});

  List<Task> readTasks() => taskProvider.readTasks();
  void writeTasks(List<Task> tasks) => taskProvider.writeTasks(tasks);
}

class AlarmRepository {
  AlarmProvider alarmProvider;
  AlarmRepository({required this.alarmProvider});

  List<Alarm> readAlarms() => alarmProvider.readAlarms();
  void writeAlarms(List<Alarm> alarms) => alarmProvider.writeAlarms(alarms);
}
