import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildOrDivider extends StatelessWidget {
  const BuildOrDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 60.w, right: 20.h),
              child: DottedLine(
                dashColor: Colors.grey.shade300,
              ),
            ),
          ),
          Text(
            'Or',
            style: TextStyle(color: Colors.grey[200]),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 20.w, right: 60.h),
              child: DottedLine(
                dashColor: Colors.grey.shade300,
              ),
            ),
          )
        ],
      ),
    );
  }
}
