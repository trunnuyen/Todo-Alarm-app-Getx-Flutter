import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart';
import 'package:todo_app_with_getx/app/core/values/clock.dart';
import 'package:todo_app_with_getx/app/data/models/alarm.dart';
import 'package:todo_app_with_getx/app/data/services/storage/repository.dart';

class ClockController extends GetxController {
  AlarmRepository alarmRepository;
  ClockController({required this.alarmRepository});

  //Alarm
  Rx<DateTime> dateTime = DateTime.now().obs;
  RxBool status = false.obs;
  final alarms = <Alarm>[].obs;
  final alarm = Rx<Alarm?>(null);
  final weekdays = <int>[].obs;
  var time = DateTime.now().obs;
  final TextEditingController alarmTextCtrl = TextEditingController();
  final tabIndex = 0.obs;

  //Timer
  static const maxSeconds = 60;
  var seconds = 0.obs;
  Timer? timer;
  RxBool isTimerRunning = false.obs;
  RxInt hour = 0.obs;
  RxInt min = 0.obs;
  RxInt sec = 0.obs;
  Rx<Duration> duration = const Duration().obs;
  static const secondsPerMinute = 60;
  static const secondsPerHour = 60 * 60;
  RxString negativeSign = ''.obs;
  RxString twoDigitMinutes = ''.obs;
  RxString twoDigitSeconds = ''.obs;
  RxString timeString = ''.obs;

  @override
  void onInit() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      dateTime.value = DateTime.now();
    });
    super.onInit();
    alarms.assignAll(alarmRepository.readAlarms());
    ever(alarms, (_) => alarmRepository.writeAlarms(alarms));
  }

  int alarmSort(alarm1, alarm2) => alarm1.time.compareTo(alarm2.time);

  Future<void> addAlarm(Alarm alarm) async {
    alarms.add(alarm);
    alarms.sort(alarmSort);
    alarms.refresh();
    await _scheduleAlarm(alarm);
  }

  Future<void> updateAlarm(Alarm selectedAlarm, DateTime? time,
      List<int>? weekdays, String? title, bool? isActive) async {
    int oldIndex = alarms.indexOf(selectedAlarm);
    var newAlarm = selectedAlarm.copyWith(
        time: time, weekdays: weekdays, title: title, isActive: isActive);
    alarms[oldIndex] = newAlarm;
    alarms.sort(alarmSort);
    alarms.refresh();
    !newAlarm.isActive
        ? await _removeScheduledAlarm(newAlarm)
        : await _scheduleAlarm(newAlarm);
  }

  Future<void> deleteAlarm(Alarm alarm) async {
    alarms.remove(alarm);
    await _removeScheduledAlarm(alarm);
  }

  Future<void> _scheduleAlarm(Alarm alarm) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'alarmTodo',
      'AlarmToDo',
      channelDescription: 'Show the alarm',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('alarm'),
    );
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      sound: 'alarm.aiff',
      presentSound: true,
      presentAlert: true,
      presentBadge: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    if (alarm.weekdays.isEmpty) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        alarm.id,
        'Alarm ${fromTimeToString(alarm.time)}',
        alarm.title,
        TZDateTime.local(
          alarm.time.year,
          alarm.time.month,
          alarm.time.day,
          alarm.time.hour,
          alarm.time.minute,
        ),
        platformChannelSpecifics,
        // ignore: deprecated_member_use
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } else {
      for (var weekday in alarm.weekdays) {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          // acts as an id, for cancelling later
          alarm.id * 10 + weekday,
          'Alarm ${fromTimeToString(alarm.time)}',
          alarm.title,
          TZDateTime.local(
            alarm.time.year,
            alarm.time.month,
            alarm.time.day - alarm.time.weekday + weekday,
            alarm.time.hour,
            alarm.time.minute,
          ),
          platformChannelSpecifics,
          // ignore: deprecated_member_use
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        );
      }
    }
  }

  Future<void> _removeScheduledAlarm(Alarm alarm) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    if (alarm.weekdays.isNotEmpty) {
      for (var notification in pendingNotificationRequests) {
        // get grouped id
        if ((notification.id / 10).floor() == alarm.id) {
          await flutterLocalNotificationsPlugin.cancel(notification.id);
        }
      }
    } else {
      await flutterLocalNotificationsPlugin.cancel(alarm.id);
    }
  }

  void changeAlarm(Alarm? selectedAlarm) {
    alarm.value = selectedAlarm;
    alarmTextCtrl.text = selectedAlarm != null ? alarm.value!.title : '';
  }

  void changeTime(DateTime datetime) {
    time.value = datetime;
  }

  void changeweekdays(List<int> weekdayss) {
    weekdays.clear();
    weekdays.addAll(weekdayss);
  }

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  Future<void> scheduleAlarm(Alarm alarm) async {
    await _scheduleAlarm(alarm);
  }

  /// Start Timer
  void startTimer({bool rest = false}) {
    if (rest) {
      resetTimer();
      update();
    }
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds.value > 0) {
        printDuration(Duration(seconds: seconds.value - 1));
        seconds.value--;
        update();
      } else {
        final player = AudioPlayer();
        player.play(AssetSource('sounds/timer_sound.wav'));
        stopTimer(rest: false);
        resetTimer();
      }
    });
    isTimerRunning.value = true;
  }

  /// Stop Timer
  void stopTimer({bool rest = true}) {
    if (rest) {
      resetTimer();
      update();
    }
    timer?.cancel();
    isTimerRunning.value = false;
    update();
  }

  /// Reset Timer
  void resetTimer() {
    duration.value = const Duration(hours: 0, minutes: 0, seconds: 0);
    seconds.value = 0;
    hour.value = 0;
    min.value = 0;
    sec.value = 0;
    printDuration(Duration(seconds: seconds.value));
    update();
  }

  /// is Timer Active?
  bool isTimerRuning() {
    return timer == null ? false : timer!.isActive;
  }

  /// is Timer Completed?
  bool isCompleted() {
    return seconds.value == duration.value.inSeconds || seconds.value == 0;
  }

  String twoDigits(int n) => n.toString().padLeft(2, "0");

  void printDuration(Duration duration) {
    negativeSign.value = duration.isNegative ? '-' : '';
    twoDigitMinutes.value = twoDigits(duration.inMinutes.remainder(60).abs());
    twoDigitSeconds.value = twoDigits(duration.inSeconds.remainder(60).abs());
    timeString.value =
        "${negativeSign.value}${twoDigits(duration.inHours)}:${twoDigitMinutes.value}:${twoDigitSeconds.value}";
  }
}
