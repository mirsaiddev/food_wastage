import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:food_wastage/constants/colors.dart';
import 'package:food_wastage/helpers/navigator_helper.dart';
import 'package:food_wastage/helpers/show.dart';
import 'package:food_wastage/pages/auth/signin_page.dart';
import 'package:food_wastage/services/auth_service.dart';
import 'package:food_wastage/services/firestore_service.dart';
import 'package:food_wastage/widgets/build_default_button.dart';

class AdminSettings extends StatefulWidget {
  const AdminSettings({Key? key}) : super(key: key);

  @override
  _AdminSettingsState createState() => _AdminSettingsState();
}

class _AdminSettingsState extends State<AdminSettings> {
  TextEditingController _controller = TextEditingController();
  String _username = '';

  Future<void> _getUsername() async {
    _username = await FirestoreService().getCurrentUsersUsername();
    _controller.text = _username;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getUsername();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_username.isEmpty
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 60.h),
                        height: 120.h,
                        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(40.h)),
                        child: SizedBox(
                          height: 120.h,
                          child: Center(
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              controller: _controller,
                              onChanged: (value) {
                                _username = value;
                                setState(() {});
                              },
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
                                hintText: 'Type new username',
                              ),
                              cursorHeight: 40.h,
                            ),
                          ),
                        ),
                      ),
                      BuildDefaultButton2(
                        text: Text('To change your username, type new username and click'),
                        onPressed: () async {
                          String _oldUsername = await FirestoreService().getCurrentUsersUsername();
                          if (_oldUsername != _username) {
                            await FirestoreService().changeUsername(_username);
                            Show.snackbar(context, 'Username changed successfully');
                          }
                        },
                        color: MyColors.red,
                      ),
                    ],
                  ),
                  BuildDefaultButton2(
                    text: Text('Reset Password'),
                    onPressed: () async {
                      await AuthService().sendPasswordResetMail();
                      Show.snackbar(context, 'A Password Reset Mail sent to your e-mail');
                    },
                    color: MyColors.red,
                  ),
                  BuildDefaultButton2(
                    text: Text('Sign Out'),
                    onPressed: () async {
                      Show.dialog(
                        context,
                        AlertDialog(
                          title: Text('Warning!'),
                          content: Text('Are you sure that you want to sign out?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                await AuthService().signOut();
                                Go.pushAndRemoveUntil(context, SigninPage());
                              },
                              child: Text('Sign Out'),
                            ),
                          ],
                        ),
                      );
                    },
                    color: MyColors.red,
                  ),
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
