import 'package:todo_app_with_getx/app/data/models/task.dart';
import 'package:todo_app_with_getx/app/data/provider/task/provider.dart';

class TaskRepository {
  TaskProvider taskProvider;
  TaskRepository({required this.taskProvider});

  List<Task> readTasks() => taskProvider.readTasks();
  void writeTasks(List<Task> tasks) => taskProvider.writeTasks(tasks);
}
