import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildAuthPageText extends StatelessWidget {
  final String text1, text2;
  const BuildAuthPageText({
    Key? key,
    required this.text1,
    required this.text2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30.w),
      child: Column(
        children: [
          Text(text1, style: TextStyle(fontSize: ScreenUtil().setSp(38), color: Colors.white), textAlign: TextAlign.center),
          SizedBox(height: 16.h),
          Text(text2, style: TextStyle(fontSize: ScreenUtil().setSp(52), fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
