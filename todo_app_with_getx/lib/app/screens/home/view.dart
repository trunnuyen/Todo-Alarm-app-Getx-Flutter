import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_getx/app/core/utils/extensions.dart';
import 'package:todo_app_with_getx/app/data/models/task.dart';
import 'package:todo_app_with_getx/app/screens/clock/binding.dart';
import 'package:todo_app_with_getx/app/screens/clock/view.dart';
import 'package:todo_app_with_getx/app/screens/home/controller.dart';
import 'package:todo_app_with_getx/app/screens/home/widgets/add_card.dart';
import 'package:todo_app_with_getx/app/screens/home/widgets/add_dialog.dart';
import 'package:todo_app_with_getx/app/screens/home/widgets/task_card.dart';
import 'package:todo_app_with_getx/app/screens/report/view.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.tabIndex.value,
          children: [
            SafeArea(
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.all(4.0.wp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.apps,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: 3.0.wp,
                            ),
                            Text(
                              'task'.tr,
                              style: TextStyle(
                                  fontSize: 24.0.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Get.to(() => const ClockPage(),
                                    binding: ClockBinding(),
                                    transition: Transition.downToUp);
                              },
                              icon: const Icon(Icons.alarm),
                            ),
                            IconButton(
                              onPressed: () {
                                Get.isDarkMode
                                    ? Get.changeTheme(ThemeData.light())
                                    : Get.changeTheme(ThemeData.dark());
                              },
                              icon: Icon(Get.isDarkMode
                                  ? Icons.light_mode
                                  : Icons.dark_mode),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      children: [
                        ...controller.tasks
                            .map(
                              (element) => LongPressDraggable(
                                data: element,
                                onDragStarted: () =>
                                    controller.changeDeleting(true),
                                onDraggableCanceled: (_, __) =>
                                    controller.changeDeleting(false),
                                onDragEnd: (_) =>
                                    controller.changeDeleting(false),
                                feedback: Opacity(
                                  opacity: 0.8,
                                  child: TaskCard(task: element),
                                ),
                                child: TaskCard(task: element),
                              ),
                            )
                            .toList(),
                        AddCard(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ReportPage(),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: DragTarget<Task>(
        builder: (_, __, ___) {
          return Obx(
            () => FloatingActionButton(
              backgroundColor:
                  controller.deleting.value ? Colors.red : Colors.blue,
              onPressed: () {
                Get.to(() => AddDialog(), transition: Transition.downToUp);
              },
              child: Icon(controller.deleting.value ? Icons.delete : Icons.add),
            ),
          );
        },
        onAcceptWithDetails: (DragTargetDetails<Task> task) {
          controller.deleteTask(task.data);
          EasyLoading.showSuccess('deleted'.tr);
        },
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent),
        child: Obx(
          () => BottomNavigationBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            onTap: (int index) => controller.changeTabIndex(index),
            currentIndex: controller.tabIndex.value,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                label: 'home'.tr,
                icon: Padding(
                  padding: EdgeInsets.only(right: 15.0.wp),
                  child: const Icon(Icons.apps),
                ),
              ),
              BottomNavigationBarItem(
                label: 'report'.tr,
                icon: Padding(
                  padding: EdgeInsets.only(left: 15.0.wp),
                  child: const Icon(Icons.data_usage),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
