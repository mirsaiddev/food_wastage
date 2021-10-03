import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildPlacePickerBarText extends StatelessWidget {
  const BuildPlacePickerBarText({
    Key? key,
    required String barText,
  })   : _barText = barText,
        super(key: key);

  final String _barText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      width: double.infinity,
      margin: EdgeInsets.all(30.w),
      padding: EdgeInsets.all(30.w),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50.h)),
      child: Center(
        child: Text(
          _barText,
          style: TextStyle(),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
