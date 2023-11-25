import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_getx/app/core/utils/extensions.dart';
import 'package:todo_app_with_getx/app/core/values/colors.dart';
import 'package:todo_app_with_getx/app/core/values/icons.dart';
import 'package:todo_app_with_getx/app/data/models/task.dart';
import 'package:todo_app_with_getx/app/screens/home/controller.dart';

class AddCard extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  AddCard({super.key});

  @override
  Widget build(BuildContext context) {
    final icons = getIcons();
    var squareWith = Get.width - 12.0.wp;
    return Container(
        width: squareWith / 2,
        height: squareWith / 2,
        margin: EdgeInsets.all(3.0.wp),
        child: InkWell(
          onTap: () async {
            await Get.defaultDialog(
                titlePadding: EdgeInsets.symmetric(vertical: 5.0.wp),
                radius: 5,
                title: 'new_task'.tr,
                content: Form(
                    key: homeCtrl.formKey,
                    child: Column(
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
                                return 'please_enter_title'.tr;
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0.wp),
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
                                            homeCtrl.chipIndex.value == index,
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
                                  ? EasyLoading.showSuccess('task_created'.tr)
                                  : EasyLoading.showError(
                                      'Something went wrong');
                            }
                          },
                          child: Text(
                            'add'.tr,
                            style: TextStyle(
                              color:
                                  Get.isDarkMode ? Colors.black : Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )));
            homeCtrl.homeTextCtrl.clear();
            homeCtrl.changeChipIndex(0);
          },
          child: DottedBorder(
            color: Colors.grey[400]!,
            dashPattern: const [8, 4],
            child: Center(
              child: Icon(
                Icons.add,
                color: Colors.grey,
                size: 10.0.wp,
              ),
            ),
          ),
        ));
  }
}
