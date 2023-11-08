import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:todo_app_with_getx/app/core/utils/extensions.dart';
import 'package:todo_app_with_getx/app/screens/detail/widgets/doing_list.dart';
import 'package:todo_app_with_getx/app/screens/detail/widgets/done_list.dart';
import 'package:todo_app_with_getx/app/screens/home/controller.dart';

class DetailPage extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final color = HexColor.fromHex(homeCtrl.task.value!.color);
    return Scaffold(
      body: Form(
        key: homeCtrl.formKey,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(3.0.wp),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                      homeCtrl.updateTodos();
                      homeCtrl.homeTextCtrl.clear();
                      homeCtrl.changeTask(null);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.0.wp),
              child: Row(
                children: [
                  Icon(
                    IconData(homeCtrl.task.value!.icon,
                        fontFamily: 'MaterialIcons'),
                    color: HexColor.fromHex(homeCtrl.task.value!.color),
                  ),
                  SizedBox(
                    width: 3.0.wp,
                  ),
                  Text(
                    homeCtrl.task.value!.title,
                    style: TextStyle(
                      fontSize: 20.0.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () {
                var totalTodos =
                    homeCtrl.doingTodos.length + homeCtrl.doneTodos.length;
                return Padding(
                  padding: EdgeInsets.only(
                      left: 16.5.wp, top: 3.0.wp, right: 16.5.wp),
                  child: Row(
                    children: [
                      Text(
                        '$totalTodos Tasks',
                        style: TextStyle(
                          fontSize: 12.0.sp,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        width: 3.0.wp,
                      ),
                      StepProgressIndicator(
                        totalSteps: totalTodos == 0 ? 1 : totalTodos,
                        currentStep: homeCtrl.doneTodos.length,
                        size: 5,
                        padding: 0,
                        selectedGradientColor: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [color.withOpacity(0.5), color],
                        ),
                        unselectedGradientColor: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.grey[300]!, Colors.grey[300]!],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: 2.0.wp, horizontal: 4.0.wp),
              child: TextFormField(
                controller: homeCtrl.homeTextCtrl,
                autofocus: true,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  prefixIcon: Icon(
                    Icons.check_box_outline_blank,
                    color: Colors.grey[400],
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      if (homeCtrl.formKey.currentState!.validate()) {
                        bool success =
                            homeCtrl.addTodos(homeCtrl.homeTextCtrl.text);
                        if (success) {
                          EasyLoading.showSuccess('Add todos successfully');
                        } else {
                          EasyLoading.showError('Todo item already exist');
                        }
                        homeCtrl.homeTextCtrl.clear();
                      }
                    },
                    icon: const Icon(Icons.done, color: Colors.blue),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your todo item';
                  }
                  return null;
                },
              ),
            ),
            DoingList(),
            DoneList(),
          ],
        ),
      ),
    );
  }
}
