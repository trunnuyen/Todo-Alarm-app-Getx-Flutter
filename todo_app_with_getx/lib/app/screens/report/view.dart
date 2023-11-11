import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:todo_app_with_getx/app/core/utils/extensions.dart';
import 'package:todo_app_with_getx/app/core/values/colors.dart';
import 'package:todo_app_with_getx/app/screens/home/controller.dart';
import 'package:todo_app_with_getx/app/screens/report/widgets/setting_dialog.dart';
import 'package:todo_app_with_getx/app/screens/report/widgets/todos_static_item.dart';

class ReportPage extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () {
            int allTodos = homeCtrl.getTotalTodos();
            int allDoneTodos = homeCtrl.getTotalDoneTodos();
            int remainingTodos = allTodos - allDoneTodos;
            double percentDone = (allDoneTodos / allTodos) * 100;
            return ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 5.0.wp,
                    horizontal: 4.0.wp,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.data_usage,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            width: 3.0.wp,
                          ),
                          Text(
                            'report'.tr,
                            style: TextStyle(
                              fontSize: 24.0.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          Get.to(() => SettingDialog(),
                              transition: Transition.downToUp);
                        },
                        icon: const Icon(Icons.settings),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
                  child: Text(
                    DateFormat.yMMMMd().format(DateTime.now()),
                    style: TextStyle(
                      fontSize: 14.0.sp,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 5.0.wp, vertical: 3.0.wp),
                  child: const Divider(
                    thickness: 2,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 3.0.wp, horizontal: 5.0.wp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TodoStaticItem(
                          color: Colors.orange,
                          count: remainingTodos,
                          title: 'live_tasks'.tr),
                      TodoStaticItem(
                          color: Colors.green,
                          count: allDoneTodos,
                          title: 'done_tasks'.tr),
                      TodoStaticItem(
                          color: Colors.blue,
                          count: allTodos,
                          title: 'total_tasks'.tr),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8.0.wp,
                ),
                UnconstrainedBox(
                  child: SizedBox(
                    width: 70.0.wp,
                    height: 70.0.wp,
                    child: CircularStepProgressIndicator(
                      totalSteps: allTodos == 0 ? 1 : allTodos,
                      currentStep: allDoneTodos,
                      stepSize: 20,
                      selectedColor: green,
                      unselectedColor: Colors.grey[200],
                      padding: 0,
                      width: 150,
                      height: 150,
                      selectedStepSize: 22,
                      roundedCap: (_, __) => true,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${allTodos == 0 ? 0 : percentDone.floor()}%',
                            style: TextStyle(
                                fontSize: 20.0.sp, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 2.0.wp,
                          ),
                          Text(
                            'efficiency'.tr,
                            style: TextStyle(
                              fontSize: 12.0.sp,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
