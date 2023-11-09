import 'package:flutter/material.dart';
import 'package:todo_app_with_getx/app/core/utils/extensions.dart';

class TodoStaticItem extends StatelessWidget {
  final Color color;
  final int count;
  final String title;
  const TodoStaticItem(
      {super.key,
      required this.color,
      required this.count,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 1.5.wp,
            ),
            Container(
              width: 3.0.wp,
              height: 3.0.wp,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 0.5.wp,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          width: 3.0.wp,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0.sp,
              ),
            ),
            SizedBox(
              height: 2.0.wp,
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12.0.sp,
                color: Colors.grey,
              ),
            ),
          ],
        )
      ],
    );
  }
}
