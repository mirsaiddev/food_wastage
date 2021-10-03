import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildDefaultButton extends StatelessWidget {
  const BuildDefaultButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.color,
  }) : super(key: key);

  final Text text;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 12.h),
      child: ElevatedButton(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size(720.w, 120.h)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(60.h))),
          backgroundColor: MaterialStateProperty.all(color),
          shadowColor: MaterialStateProperty.all(color.withOpacity(0.5)),
        ),
        onPressed: onPressed,
        child: text,
      ),
    );
  }
}

class BuildDefaultButton2 extends StatelessWidget {
  const BuildDefaultButton2({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.color,
  }) : super(key: key);

  final Text text;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: ElevatedButton(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size(720.w, 120.h)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.h))),
          backgroundColor: MaterialStateProperty.all(color),
          shadowColor: MaterialStateProperty.all(color.withOpacity(0.5)),
        ),
        onPressed: onPressed,
        child: text,
      ),
    );
  }
}
