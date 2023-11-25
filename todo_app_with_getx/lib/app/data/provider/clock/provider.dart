import 'dart:convert';
import 'package:get/get.dart';
import 'package:todo_app_with_getx/app/core/utils/keys.dart';
import 'package:todo_app_with_getx/app/data/models/alarm.dart';
import 'package:todo_app_with_getx/app/data/services/storage/services.dart';

class AlarmProvider {
  final StorageService _storage = Get.find<StorageService>();

  List<Alarm> readAlarms() {
    var alarms = <Alarm>[];
    jsonDecode(_storage.read(timeKey).toString())
        .forEach((e) => alarms.add(Alarm.fromJson(e)));
    return alarms;
  }

  void writeAlarms(List<Alarm> alarms) {
    _storage.write(timeKey, jsonEncode(alarms));
  }
}
