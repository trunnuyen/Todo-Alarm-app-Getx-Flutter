import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_getx/app/core/utils/extensions.dart';
import 'package:todo_app_with_getx/app/screens/home/controller.dart';
import 'package:todo_app_with_getx/app/screens/home/widget/add_card.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(4.0.wp),
              child: Text(
                'add'.tr,
                style:
                    TextStyle(fontSize: 24.0.sp, fontWeight: FontWeight.bold),
              ),
            ),
            GridView.count(crossAxisCount: 2,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [AddCard()],
            )
          ],
        ),
      ),
    );
  }
}
