import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildIcon extends StatelessWidget {
  const BuildIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 120.h, bottom: 80.h),
      child: Image.asset('assets/waste.png', scale: ScreenUtil().setSp(5)),
    );
  }
}
