import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_wastage/constants/colors.dart';
import 'package:food_wastage/helpers/navigator_helper.dart';
import 'package:food_wastage/pages/food_recipient/fr_bottom_nav_bar.dart';
import 'package:food_wastage/pages/user/user_bottom_nav_bar.dart';
import 'package:food_wastage/services/auth_service.dart';
import 'package:food_wastage/services/firestore_service.dart';
import 'package:food_wastage/services/shared_preferences_service.dart';
import 'package:food_wastage/widgets/build_auth_page_text.dart';
import 'package:food_wastage/widgets/build_default_button.dart';
import 'package:food_wastage/widgets/build_icon.dart';

class RoleChosePage extends StatefulWidget {
  const RoleChosePage({Key? key}) : super(key: key);

  @override
  _RoleChosePageState createState() => _RoleChosePageState();
}

class _RoleChosePageState extends State<RoleChosePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.yellowAccent,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const BuildIcon(),
              Column(
                children: [
                  const BuildAuthPageText(text1: 'Please select the role that you want sign up as', text2: 'Sign up as :'),
                  BuildDefaultButton(
                      text: const Text('User'),
                      color: MyColors.yellow,
                      onPressed: () async {
                        User? _user = AuthService().getCurrentUser();
                        await FirestoreService().updateRole(user: _user!, role: 'User');
                        await SharedPreferencesService().saveUserRole('User');
                        Go.pushAndRemoveUntil(context, const UserBottomNavBar());
                      }),
                  BuildDefaultButton(
                      text: const Text('Food Recipient'),
                      color: MyColors.red,
                      onPressed: () async {
                        User? _user = AuthService().getCurrentUser();
                        await FirestoreService().updateRole(user: _user!, role: 'Food Recipient');
                        await SharedPreferencesService().saveUserRole('Food Recipient');
                        Go.pushAndRemoveUntil(context, const FrBottomNavBar());
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
