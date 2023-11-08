import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_getx/app/core/utils/extensions.dart';
import 'package:todo_app_with_getx/app/core/values/colors.dart';
import 'package:todo_app_with_getx/app/core/values/icons.dart';
import 'package:todo_app_with_getx/app/data/models/task.dart';
import 'package:todo_app_with_getx/app/screens/home/controller.dart';

class AddDialog extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  AddDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final icons = getIcons();
    return Scaffold(
      body: Form(
        key: homeCtrl.formKey,
        child: Obx(
          () => ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(3.0.wp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                        homeCtrl.homeTextCtrl.clear();
                        homeCtrl.selectedTasks.clear();
                      },
                      icon: const Icon(Icons.close),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      onPressed: () {
                        if (homeCtrl.formKey.currentState!.validate()) {
                          if (homeCtrl.selectedTasks.isEmpty) {
                            EasyLoading.showError('Please select task');
                          } else {
                            bool success = homeCtrl.updateTask(
                                homeCtrl.selectedTasks,
                                homeCtrl.homeTextCtrl.text);
                            if (success) {
                              EasyLoading.showSuccess(
                                  'Task updated successfully');
                              Get.back();
                              homeCtrl.selectedTasks.clear();
                              homeCtrl.homeTextCtrl.clear();
                            } else {
                              EasyLoading.showError('Item already exist');
                            }
                          }
                        }
                      },
                      child: Text(
                        'done'.tr,
                        style: TextStyle(
                          fontSize: 14.0.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 7.0.wp),
                child: Text('New Task',
                    style: TextStyle(
                      fontSize: 20.0.sp,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 7.0.wp),
                child: TextFormField(
                  controller: homeCtrl.homeTextCtrl,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                  ),
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your task';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(7.0.wp, 3.0.wp, 7.0.wp, 3.0.wp),
                child: Text('Add to',
                    style: TextStyle(fontSize: 14.0.sp, color: Colors.grey)),
              ),
              ...homeCtrl.tasks.map(
                (element) => Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 6.0.wp, vertical: 3.0.wp),
                  child: InkWell(
                    onTap: () {
                      if (!homeCtrl.selectedTasks.contains(element)) {
                        homeCtrl.addSelectedTask(element);
                      } else {
                        homeCtrl.deleteSelectedTask(element);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              IconData(element.icon,
                                  fontFamily: 'MaterialIcons'),
                              color: HexColor.fromHex(element.color),
                            ),
                            SizedBox(
                              width: 3.0.wp,
                            ),
                            Text(
                              element.title,
                              style: TextStyle(
                                fontSize: 12.0.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        if (homeCtrl.selectedTasks.contains(element))
                          const Icon(
                            Icons.check,
                            color: Colors.blue,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 6.0.wp, vertical: 2.0.wp),
                child: InkWell(
                  onTap: () async {
                    await Get.defaultDialog(
                        titlePadding: EdgeInsets.symmetric(vertical: 2.0.wp),
                        radius: 5,
                        title: 'New Task',
                        content: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3.0.wp),
                              child: TextFormField(
                                controller: homeCtrl.homeTextCtrl,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Title'),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter title';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.0.wp),
                              child: Wrap(
                                spacing: 2.0.wp,
                                children: icons
                                    .map((e) => Obx(() {
                                          final index = icons.indexOf(e);
                                          return ChoiceChip(
                                            selectedColor: Colors.grey[100],
                                            pressElevation: 0,
                                            backgroundColor: Get.isDarkMode
                                                ? Colors.black
                                                : Colors.white,
                                            label: e,
                                            selected:
                                                homeCtrl.chipIndex.value ==
                                                    index,
                                            onSelected: (bool selected) {
                                              homeCtrl.chipIndex.value =
                                                  selected ? index : 0;
                                            },
                                          );
                                        }))
                                    .toList(),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                minimumSize: const Size(150, 40),
                              ),
                              onPressed: () {
                                if (homeCtrl.formKey.currentState!.validate()) {
                                  int icon = icons[homeCtrl.chipIndex.value]
                                      .icon!
                                      .codePoint;
                                  String color = icons[homeCtrl.chipIndex.value]
                                      .color!
                                      .toHex();
                                  var task = Task(
                                      title: homeCtrl.homeTextCtrl.text,
                                      icon: icon,
                                      color: color);
                                  Get.back();
                                  homeCtrl.addTask(task)
                                      ? EasyLoading.showSuccess('Task created')
                                      : EasyLoading.showError(
                                          'Something went wrong');
                                }
                              },
                              child: Text(
                                'add'.tr,
                                style: TextStyle(
                                  color: Get.isDarkMode
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ));
                    homeCtrl.homeTextCtrl.clear();
                    homeCtrl.changeChipIndex(0);
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.add, color: Colors.grey),
                      SizedBox(
                        width: 3.0.wp,
                      ),
                      Text(
                        'Add new',
                        style: TextStyle(
                          fontSize: 12.0.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
