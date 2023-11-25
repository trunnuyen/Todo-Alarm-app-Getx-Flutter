import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:todo_app_with_getx/app/core/utils/extensions.dart';
import 'package:todo_app_with_getx/app/core/values/colors.dart';
import 'package:todo_app_with_getx/app/screens/clock/controller.dart';
import 'package:todo_app_with_getx/app/widgets/app_bar.dart';

class TimerCountdown extends StatelessWidget {
  final timeCtrl = Get.find<ClockController>();
  TimerCountdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: MyAppBar(
          actionText: '',
          icon: Icons.close,
          onTapAction: () {},
          onTapBack: () {},
        ),
        body: Container(
          margin: EdgeInsets.all(10.0.wp),
          width: Get.width,
          height: Get.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Center Circle
              Container(
                decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? const Color.fromARGB(255, 21, 21, 21)
                      : Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10.0,
                        offset: const Offset(5, 5),
                        color: Get.isDarkMode
                            ? Colors.black
                            : const Color.fromARGB(109, 144, 144, 144)),
                    BoxShadow(
                        blurRadius: 10.0,
                        offset: const Offset(-5, -5),
                        color: Get.isDarkMode
                            ? const Color.fromARGB(255, 27, 27, 27)
                            : const Color.fromARGB(255, 243, 243, 243))
                  ],
                ),
                width: 300.0,
                height: 300.0,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0.wp),
                      child: CircularProgressIndicator(
                        strokeWidth: 1.0.wp,
                        valueColor: AlwaysStoppedAnimation(
                            timeCtrl.seconds.value ==
                                    timeCtrl.duration.value.inSeconds
                                ? Colors.green
                                : Colors.red),
                        backgroundColor: Get.isDarkMode
                            ? const Color.fromARGB(255, 34, 34, 34)
                            : const Color.fromARGB(255, 237, 237, 237),
                        value:
                        timeCtrl.duration.value.inSeconds == 0 ? 0 :
                            timeCtrl.seconds.value / timeCtrl.duration.value.inSeconds,
                      ),
                    ),
                    Center(
                        child: Text(
                      timeCtrl.timeString.value,
                      style: TextStyle(
                        fontSize: 20.0.sp,
                        fontWeight: FontWeight.bold,
                        color: timeCtrl.isCompleted()
                            ? const Color.fromARGB(255, 8, 123, 12)
                            : const Color.fromARGB(255, 178, 14, 2),
                      ),
                    )),
                  ],
                ),
              ),
              SizedBox(
                height: 50.0.wp,
              ),

              /// Buttons
              timeCtrl.isTimerRuning() || !timeCtrl.isCompleted()
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                            timeCtrl.isTimerRuning()
                                ? Colors.red
                                : Colors.green,
                          )),
                          onPressed: () {
                            timeCtrl.isTimerRuning()
                                ? timeCtrl.stopTimer(rest: false)
                                : timeCtrl.startTimer(rest: false);
                          },
                          child: Text(
                            timeCtrl.isTimerRunning.value
                                ? 'pause'.tr
                                : 'resume'.tr,
                            style: const TextStyle(fontWeight: FontWeight.w400),
                          ),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.red)),
                          onPressed: () {
                            timeCtrl.stopTimer(rest: true);
                          },
                          child: Text(
                            'cancel'.tr,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    )
                  : ElevatedButton(
                      onPressed: timeCtrl.duration.value.inSeconds == 0
                          ? () async {
                              await Get.defaultDialog(
                                titlePadding:
                                    EdgeInsets.symmetric(vertical: 5.0.wp),
                                radius: 5,
                                title: 'new_timer'.tr,
                                content: Obx(
                                  () => Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              const Text('H'),
                                              NumberPicker(
                                                  itemWidth: 98,
                                                  value: timeCtrl.hour.value,
                                                  minValue: 00,
                                                  maxValue: 24,
                                                  onChanged: (value) {
                                                    timeCtrl.hour.value = value;
                                                  }),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              const Text('M'),
                                              NumberPicker(
                                                  itemWidth: 98,
                                                  value: timeCtrl.min.value,
                                                  minValue: 00,
                                                  maxValue: 60,
                                                  onChanged: (value) {
                                                    timeCtrl.min.value = value;
                                                  }),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              const Text('S'),
                                              NumberPicker(
                                                  itemWidth: 98,
                                                  value: timeCtrl.sec.value,
                                                  minValue: 00,
                                                  maxValue: 60,
                                                  onChanged: (value) {
                                                    timeCtrl.sec.value = value;
                                                  }),
                                            ],
                                          ),
                                        ],
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: blue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          minimumSize: const Size(150, 40),
                                        ),
                                        onPressed: () {
                                          timeCtrl.duration.value = Duration(
                                              hours: timeCtrl.hour.value,
                                              minutes: timeCtrl.min.value,
                                              seconds: timeCtrl.sec.value);
                                          timeCtrl.seconds.value =
                                              timeCtrl.duration.value.inSeconds;
                                          timeCtrl.printDuration(
                                              timeCtrl.duration.value);
                                          Get.back();
                                        },
                                        child: Text(
                                          'add'.tr,
                                          style: TextStyle(
                                            color: Get.isDarkMode
                                                ? Colors.black
                                                : Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          : () {
                              timeCtrl.startTimer();
                            },
                      child: Text(
                        'start'.tr,
                        style: TextStyle(
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
