import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildTextField extends StatelessWidget {
  const BuildTextField({
    Key? key,
    required this.onChanged,
    required this.validator,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    required this.keyboardType,
  }) : super(key: key);

  final TextEditingController controller;
  final void Function(String) onChanged;
  final String? Function(String?)? validator;
  final String hintText;
  final Icon prefixIcon;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50.w, vertical: 12.h),
      height: 120.h,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(60.h)),
      child: SizedBox(
        height: 120.h,
        child: Center(
          child: TextFormField(
            keyboardType: keyboardType,
            validator: validator,
            controller: controller,
            onChanged: onChanged,
            maxLength: 30,
            decoration: InputDecoration(
              counterText: '',
              contentPadding: EdgeInsets.symmetric(
                vertical: 26.h,
                horizontal: 50.w,
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 40.w, right: 30.w),
                child: prefixIcon,
              ),
              border: InputBorder.none,
              hintText: hintText,
            ),
            cursorHeight: 40.h,
          ),
        ),
      ),
    );
  }
}

class BuildTextField2 extends StatelessWidget {
  const BuildTextField2({
    Key? key,
    required this.onChanged,
    required this.validator,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    required this.keyboardType,
  }) : super(key: key);

  final TextEditingController controller;
  final void Function(String) onChanged;
  final String? Function(String?)? validator;
  final String hintText;
  final Icon prefixIcon;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 60.h),
      height: 120.h,
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(40.h)),
      child: SizedBox(
        height: 120.h,
        child: Center(
          child: TextFormField(
            keyboardType: TextInputType.name,
            validator: validator,
            controller: controller,
            onChanged: onChanged,
            maxLength: 30,
            decoration: InputDecoration(
              counterText: '',
              contentPadding: EdgeInsets.symmetric(
                vertical: 26.h,
                horizontal: 50.w,
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 40.w, right: 30.w),
                child: Icon(Icons.create_outlined),
              ),
              border: InputBorder.none,
              hintText: hintText,
            ),
            cursorHeight: 40.h,
          ),
        ),
      ),
    );
  }
}
