import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_getx/app/core/utils/extensions.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String actionText;
  final Function onTapBack;
  final Function onTapAction;
  final IconData icon;
  const MyAppBar(
      {super.key,
      required this.actionText,
      required this.onTapBack,
      required this.onTapAction,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.0.wp),
        child: IconButton(
          onPressed: () {
            Get.back();
            onTapBack;
          },
          icon: Icon(
            icon,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
          child: TextButton(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Colors.transparent),
            ),
            onPressed: () {
              onTapAction;
            },
            child: Text(
              actionText.tr,
              style: TextStyle(
                fontSize: 14.0.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(16.0.wp);
}
