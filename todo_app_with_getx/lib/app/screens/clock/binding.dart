import 'package:get/get.dart';
import 'package:todo_app_with_getx/app/data/provider/clock/provider.dart';
import 'package:todo_app_with_getx/app/data/services/storage/repository.dart';
import 'package:todo_app_with_getx/app/screens/clock/controller.dart';

class ClockBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ClockController(
        alarmRepository: AlarmRepository(alarmProvider: AlarmProvider())));
  }
}
