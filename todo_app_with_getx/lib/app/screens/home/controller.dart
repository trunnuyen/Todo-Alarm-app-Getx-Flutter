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

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    tasks.assignAll(taskRepository.readTasks());
    ever(tasks, (_) => taskRepository.writeTasks(tasks));
  }

  void changeChipIndex(int value){
    chipIndex.value = value;
  }
}
