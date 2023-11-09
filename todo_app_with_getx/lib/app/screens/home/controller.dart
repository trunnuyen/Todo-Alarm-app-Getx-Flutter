import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_getx/app/data/models/task.dart';
import 'package:todo_app_with_getx/app/data/services/storage/repository.dart';

class HomeController extends GetxController {
  TaskRepository taskRepository;
  HomeController({required this.taskRepository});

  final tasks = <Task>[].obs;
  final formKey = GlobalKey<FormState>();
  final TextEditingController homeTextCtrl = TextEditingController();
  final chipIndex = 0.obs;
  final deleting = false.obs;
  final task = Rx<Task?>(null);
  final selectedTasks = <Task>[].obs;
  final doingTodos = <dynamic>[].obs;
  final doneTodos = <dynamic>[].obs;
  final tabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    tasks.assignAll(taskRepository.readTasks());
    ever(tasks, (_) => taskRepository.writeTasks(tasks));
  }

  void changeChipIndex(int value) {
    chipIndex.value = value;
  }

  void changeDeleting(bool value) {
    deleting.value = value;
  }

  void deleteTask(Task task) {
    tasks.remove(task);
  }

  void changeTask(Task? selectedTask) {
    task.value = selectedTask;
  }

  void addSelectedTask(Task task) {
    selectedTasks.add(task);
  }

  void deleteSelectedTask(Task task) {
    selectedTasks.remove(task);
  }

  void changeTodos(List<dynamic> todos) {
    doingTodos.clear();
    doneTodos.clear();
    for (int i = 0; i < todos.length; i++) {
      var todo = todos[i];
      var status = todo['done'];
      if (status) {
        doneTodos.add(todo);
      } else {
        doingTodos.add(todo);
      }
    }
  }

  void updateTodos() {
    var newTodos = <Map<String, dynamic>>[];
    newTodos.addAll([
      ...doingTodos,
      ...doneTodos,
    ]);
    var newTask = task.value!.copyWith(todos: newTodos);
    int oldIndex = tasks.indexOf(task.value);
    tasks[oldIndex] = newTask;
    tasks.refresh();
  }

  void changeTodoStatus(String title) {
    var doingTodo = {'title': title, 'done': false};
    int index = doingTodos.indexWhere(
        (element) => mapEquals<String, dynamic>(doingTodo, element));
    doingTodos.removeAt(index);
    var doneTodo = {'title': title, 'done': true};
    doneTodos.add(doneTodo);
    doingTodos.refresh();
    doneTodos.refresh();
  }

  void deleteDoneTodo(dynamic doneTodo) {
    int index = doneTodos
        .indexWhere((element) => mapEquals<String, dynamic>(doneTodo, element));
    doneTodos.removeAt(index);
    doingTodos.refresh();
  }

  void deleteDoingTodo(dynamic doingTodo) {
    int index = doingTodos.indexWhere(
        (element) => mapEquals<String, dynamic>(doingTodo, element));
    doingTodos.removeAt(index);
    doingTodos.refresh();
  }

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  bool addTask(Task task) {
    if (tasks.contains(task)) {
      return false;
    }
    tasks.add(task);
    return true;
  }

  bool updateTask(List<Task> selectedTasks, String title) {
    bool result = false;
    for (var element in selectedTasks) {
      List<dynamic> todos = element.todos ?? [];
      if (!checkDuplicatedTodo(todos, title)) {
        final todo = {'title': title, 'done': false};
        todos.add(todo);
        var newTask = element.copyWith(todos: todos);
        int oldIndex = tasks.indexOf(element);
        tasks[oldIndex] = newTask;
        tasks.refresh();
        result = true;
      }
    }
    return result;
  }

  bool checkDuplicatedTodo(List todos, String title) {
    return todos.any((element) => element['title'] == title);
  }

  bool addTodos(String title) {
    var todo = {'title': title, 'done': false};
    doingTodos.add(todo);
    return true;
  }

  bool isTodosEmpty(Task task) {
    return task.todos == null || task.todos!.isEmpty;
  }

  int getDoneTodos(Task task) {
    int count = 0;
    for (int i = 0; i < task.todos!.length; i++) {
      if (task.todos![i]['done'] == true) {
        count += 1;
      }
    }
    return count;
  }

  int getTotalTodos() {
    int totalTodos = 0;
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].todos != null) {
        totalTodos += tasks[i].todos!.length;
      }
    }
    return totalTodos;
  }

  int getTotalDoneTodos() {
    int totalDoneTodos = 0;
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].todos != null) {
        for (int j = 0; j < tasks[i].todos!.length; j++) {
          if (tasks[i].todos![j]['done'] == true) {
            totalDoneTodos += 1;
          }
        }
      }
    }
    return totalDoneTodos;
  }
}
