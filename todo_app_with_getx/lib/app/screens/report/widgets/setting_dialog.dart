import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_getx/app/core/utils/extensions.dart';
import 'package:todo_app_with_getx/app/screens/home/controller.dart';

class SettingDialog extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  SettingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: ListView(
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0.wp),
              child: const Divider(
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 6.6.wp,
                vertical: 2.0.wp,
              ),
              child: GestureDetector(
                onTap: () {
                  homeCtrl.checkLocalLanguage();
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Obx(
                        () => Wrap(
                          direction: Axis.vertical,
                          spacing: 3.0,
                          children: List<Widget>.generate(
                            2,
                            (int index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3.0.wp, vertical: 1.0.wp),
                                child: ChoiceChip(
                                  selectedColor: Colors.blue[100],
                                  pressElevation: 0,
                                  backgroundColor: Get.isDarkMode
                                      ? Colors.black
                                      : Colors.white,
                                  label: Row(
                                    children: [
                                      Image.asset(
                                          index == 0
                                              ? 'assets/images/vietnam.png'
                                              : 'assets/images/english.png',
                                          fit: BoxFit.cover,
                                          width: 20.0.sp),
                                      SizedBox(
                                        width: 3.0.wp,
                                      ),
                                      Text(
                                        index == 0
                                            ? 'vietnam'.tr
                                            : 'english'.tr,
                                        style: TextStyle(
                                          fontSize: 14.0.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                  selected: homeCtrl.value.value == index,
                                  onSelected: (bool selected) {
                                    homeCtrl.value.value = selected ? index : 0;
                                    homeCtrl.changeLanguage(index);
                                  },
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      );
                    },
                  );
                },
                child: Row(
                  children: [
                    const Icon(Icons.language),
                    SizedBox(
                      width: 6.0.wp,
                    ),
                    Text(
                      'language'.tr,
                      style: TextStyle(
                        fontSize: 14.0.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 4.0.wp,
              ),
              child: const Divider(
                thickness: 1,
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 6.6.wp, vertical: 2.0.wp),
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.all(3.0.wp),
                        child: Wrap(
                          direction: Axis.vertical,
                          spacing: 3.0,
                          children: [
                            Text(
                              'Made with Flutter by trunnuyen',
                              style: TextStyle(fontSize: 14.0.sp),
                            ),
                            SizedBox(
                              height: 3.0.wp,
                            ),
                            Text(
                              'Github: https://github.com/trunnuyen',
                              style: TextStyle(fontSize: 14.0.sp),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Row(
                  children: [
                    const Icon(Icons.info),
                    SizedBox(
                      width: 6.0.wp,
                    ),
                    Text(
                      'about'.tr,
                      style: TextStyle(
                        fontSize: 14.0.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 4.0.wp,
              ),
              child: const Divider(
                thickness: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
