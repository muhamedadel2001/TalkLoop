import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OptionItem extends StatelessWidget {
  final VoidCallback onTap;
  final String name;
  final Icon icon;
  const OptionItem(
      {super.key, required this.onTap, required this.name, required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: EdgeInsets.only(left: 12.w, top: 10.h, bottom: 30.h),
        child: Row(
          children: [
            icon,
            Flexible(
                child: Text(
              '  $name',
              style: TextStyle(
                  color: Colors.black, fontSize: 15.sp, letterSpacing: 0.5),
            ))
          ],
        ),
      ),
    );
  }
}
