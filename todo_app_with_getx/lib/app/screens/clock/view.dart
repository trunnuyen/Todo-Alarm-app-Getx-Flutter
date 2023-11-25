import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_getx/app/core/utils/extensions.dart';
import 'package:todo_app_with_getx/app/screens/clock/controller.dart';
import 'package:todo_app_with_getx/app/screens/clock/widgets/alarm_list.dart';
import 'package:todo_app_with_getx/app/screens/clock/widgets/clock_widget.dart';
import 'package:todo_app_with_getx/app/screens/clock/widgets/timer_countdown_widget.dart';

class ClockPage extends GetView<ClockController> {
  const ClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(
          () => IndexedStack(
            index: controller.tabIndex.value,
            children: [
              AlarmList(),
              TimerCountdown(),
              SafeArea(
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(3.0.wp),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                    ClockWidget(),
                  ],
                ),
              ),
            ],
          ),
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
                  label: 'alarm'.tr,
                  icon: Padding(
                    padding: EdgeInsets.only(right: 15.0.wp),
                    child: const Icon(Icons.alarm_add),
                  ),
                ),
                BottomNavigationBarItem(
                  label: 'timer'.tr,
                  icon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
                    child: const Icon(Icons.timer),
                  ),
                ),
                BottomNavigationBarItem(
                  label: 'clock'.tr,
                  icon: Padding(
                    padding: EdgeInsets.only(left: 15.0.wp),
                    child: const Icon(Icons.access_time),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
