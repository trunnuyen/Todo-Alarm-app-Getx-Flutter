import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_getx/app/core/utils/extensions.dart';
import 'package:todo_app_with_getx/app/core/values/clock.dart';
import 'package:todo_app_with_getx/app/data/models/alarm.dart';
import 'package:todo_app_with_getx/app/screens/clock/controller.dart';

class AlarmPicker extends StatelessWidget {
  final clockCtrl = Get.find<ClockController>();
  AlarmPicker({super.key});

  @override
  Widget build(BuildContext context) {
    Rx<Alarm?> alarm = clockCtrl.alarm.value == null
        ? Rx<Alarm?>(Alarm(
            time: DateTime.now(),
            weekdays: const [],
            isActive: true,
            title: '',
          ))
        : clockCtrl.alarm;

    return Scaffold(
      body: Obx(
        () => ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(3.0.wp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          clockCtrl.time.value = DateTime.now();
                          clockCtrl.alarmTextCtrl.clear();
                          clockCtrl.changeAlarm(null);
                          clockCtrl.weekdays.clear();
                          Get.back();
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  TextButton(
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 14.0.sp,
                      ),
                    ),
                    onPressed: () async {
                      var newAlarm = alarm.value!.copyWith(
                          title: clockCtrl.alarmTextCtrl.text == ''
                              ? 'Ring Ring!!'
                              : clockCtrl.alarmTextCtrl.text,
                          time: clockCtrl.time.value,
                          weekdays: clockCtrl.weekdays,
                          isActive: true);
                      clockCtrl.alarm.value != null
                          ? await clockCtrl.updateAlarm(
                              clockCtrl.alarm.value!,
                              clockCtrl.time.value,
                              clockCtrl.weekdays,
                              clockCtrl.alarmTextCtrl.text == ''
                                  ? 'Ring Ring!!'
                                  : clockCtrl.alarmTextCtrl.text,
                              true)
                          : await clockCtrl.addAlarm(newAlarm);
                      EasyLoading.showSuccess('Alarm');
                      Get.back();
                      clockCtrl.time.value = DateTime.now();
                      clockCtrl.alarmTextCtrl.clear();
                      clockCtrl.changeAlarm(null);
                      clockCtrl.weekdays.clear();
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.0.wp),
              child: SizedBox(
                height: 150,
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    brightness: Theme.of(context).brightness,
                  ),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    onDateTimeChanged: (value) {
                      clockCtrl.changeTime(value);
                    },
                    initialDateTime: clockCtrl.alarm.value != null
                        ? clockCtrl.alarm.value!.time
                        : DateTime.now(),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 7.0.wp, vertical: 3.0.wp),
              child: TextFormField(
                controller: clockCtrl.alarmTextCtrl,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'title'.tr,
                  hintText: 'optional'.tr,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter title';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.0.wp),
              child: ExpansionTile(
                title: Text(
                  'repeat'.tr,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                trailing: Text(
                  clockCtrl.weekdays.isEmpty
                      ? 'never'.tr
                      : clockCtrl.weekdays.length == 7
                          ? 'everyday'.tr
                          : clockCtrl.weekdays
                              .map((weekday) =>
                                  fromWeekdayToStringShort(weekday))
                              .join(', '),
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                children: List.generate(7, (index) => index + 1).map((weekday) {
                  final checked = clockCtrl.weekdays.contains(weekday);
                  return CheckboxListTile(
                      title: Text(
                        fromWeekdayToString(weekday),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                      value: checked,
                      activeColor: Theme.of(context).colorScheme.primary,
                      onChanged: (value) {
                        value ?? false
                            ? clockCtrl.weekdays.add(weekday)
                            : clockCtrl.weekdays.remove(weekday);
                        clockCtrl.weekdays.sort();
                      });
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
