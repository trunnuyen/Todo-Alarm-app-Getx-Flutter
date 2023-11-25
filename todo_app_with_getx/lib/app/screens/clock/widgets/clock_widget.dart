import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_getx/app/core/utils/extensions.dart';
import 'package:todo_app_with_getx/app/screens/clock/controller.dart';
import 'package:todo_app_with_getx/app/screens/clock/painter/clock_painter.dart';

class ClockWidget extends StatelessWidget {
  final clockCtrl = Get.find<ClockController>();
  ClockWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0.wp, right: 10.0.wp, top: 4.0.wp),
      child: Obx(
        () => AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: Get.isDarkMode
                  ? const Color(0xff141414)
                  : const Color(0xffFFFFFF),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 0),
                    blurRadius: 64,
                    color: const Color(0xFF364564).withOpacity(0.14))
              ],
            ),
            child: Transform.rotate(
              angle: -pi / 2,
              child: CustomPaint(
                painter: ClockPainter(
                  context,
                  clockCtrl.dateTime.value,
                  curve: Curves.easeInOut,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
