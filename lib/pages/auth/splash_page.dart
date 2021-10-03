import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_wastage/helpers/navigator_helper.dart';
import 'package:food_wastage/helpers/show.dart';
import 'package:food_wastage/pages/admin/admin_bottom_nav_bar.dart';
import 'package:food_wastage/pages/auth/role_chose_page.dart';
import 'package:food_wastage/pages/food_recipient/fr_bottom_nav_bar.dart';
import 'package:food_wastage/pages/user/user_bottom_nav_bar.dart';
import 'package:food_wastage/services/auth_service.dart';
import 'signin_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final User? _user = AuthService().getCurrentUser();
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      yonlendir();
    });
  }

  void yonlendir() async {
    if (_user == null) {
      Go.replacement(context, const SigninPage());
    } else {
      print(_user);
      String _role = await AuthService().checkRole();
      if (_role == 'Admin') {
        Go.pushAndRemoveUntil(context, const AdminBottomNavBar());
      } else if (_role == 'User') {
        Go.pushAndRemoveUntil(context, const UserBottomNavBar());
      } else if (_role == 'Food Recipient') {
        Go.pushAndRemoveUntil(context, const FrBottomNavBar());
      } else if (_role == 'unknown') {
        Go.pushAndRemoveUntil(context, const RoleChosePage());
      } else {
        Show.snackbar(context, 'Something went weong');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset('assets/mapmarker256.png', scale: ScreenUtil().setSp(6))),
    );
  }
}
