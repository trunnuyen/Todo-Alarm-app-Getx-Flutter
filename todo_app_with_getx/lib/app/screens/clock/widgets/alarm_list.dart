import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_getx/app/core/utils/extensions.dart';
import 'package:todo_app_with_getx/app/core/values/clock.dart';
import 'package:todo_app_with_getx/app/screens/clock/controller.dart';
import 'package:todo_app_with_getx/app/screens/clock/widgets/alarm_picker_widget.dart';

class AlarmList extends StatelessWidget {
  final alarmCtrl = Get.find<ClockController>();
  AlarmList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              leading: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0.wp),
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
                  child: TextButton(
                    style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                    onPressed: () {
                      alarmCtrl.changeAlarm(null);
                      alarmCtrl.alarmTextCtrl.clear();
                      Get.to(() => AlarmPicker());
                    },
                    child: Text(
                      'add'.tr,
                      style: TextStyle(
                        fontSize: 14.0.sp,
                      ),
                    ),
                  ),
                ),
              ]),
          body: alarmCtrl.alarms.isEmpty
              ? SizedBox(
                  child: Center(
                    child: Text('add_alram'.tr),
                  ),
                )
              : ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    ...alarmCtrl.alarms.map(
                      (element) => Dismissible(
                        key: ObjectKey(element),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => alarmCtrl.deleteAlarm(element),
                        background: Container(
                          color: Colors.red.withOpacity(0.8),
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 5.0.wp),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 2.0.wp, horizontal: 6.0.wp),
                          child: Card(
                            child: ListTile(
                              title: Text(
                                fromTimeToString(element.time),
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    element.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.blue),
                                  ),
                                  SizedBox(
                                    height: 1.0.wp,
                                  ),
                                  Text(
                                    element.weekdays.isEmpty
                                        ? 'never'.tr
                                        : element.weekdays.length == 7
                                            ? 'everyday'.tr
                                            : element.weekdays
                                                .map((weekday) =>
                                                    fromWeekdayToStringShort(
                                                        weekday))
                                                .join(', '),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                  ),
                                ],
                              ),
                              trailing: Switch(
                                // This bool value toggles the switch.
                                value: element.isActive,
                                activeColor: Colors.red,
                                onChanged: (bool value) {
                                  alarmCtrl.updateAlarm(element, element.time,
                                      element.weekdays, element.title, value);
                                },
                              ),
                              onTap: () {
                                alarmCtrl.changeAlarm(element);
                                alarmCtrl.changeweekdays(element.weekdays);
                                alarmCtrl.changeTime(element.time);
                                Get.to(() => AlarmPicker());
                              },
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
