import 'package:flutter/material.dart';
import 'package:food_wastage/constants/colors.dart';
import 'package:food_wastage/helpers/navigator_helper.dart';
import 'package:food_wastage/helpers/show.dart';
import 'package:food_wastage/main.dart';
import 'package:food_wastage/models/my_user.dart';
import 'package:food_wastage/pages/admin/admin_bottom_nav_bar.dart';
import 'package:food_wastage/pages/auth/signup_page.dart';
import 'package:food_wastage/pages/food_recipient/fr_bottom_nav_bar.dart';
import 'package:food_wastage/pages/user/user_bottom_nav_bar.dart';
import 'package:food_wastage/services/auth_service.dart';
import 'package:food_wastage/services/shared_preferences_service.dart';
import 'package:food_wastage/widgets/build_auth_page_text.dart';
import 'package:food_wastage/widgets/build_default_button.dart';
import 'package:food_wastage/widgets/build_icon.dart';
import 'package:food_wastage/widgets/build_or_divider.dart';
import 'package:food_wastage/widgets/build_textfield.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final MyUser _user = MyUser();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.redAccent,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const BuildIcon(),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    const BuildAuthPageText(text1: 'Welcome !', text2: 'Sign In'),
                    BuildTextField(
                      onChanged: (value) => setState(() {
                        _user.email = value;
                      }),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please fill this field';
                        }
                        if (!value.isValidEmail()) {
                          return 'A valid email is required';
                        }
                      },
                      controller: _emailController,
                      hintText: 'E-mail',
                      prefixIcon: const Icon(Icons.email_outlined),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    BuildTextField(
                      onChanged: (value) => setState(() {
                        _user.password = value;
                      }),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please fill this field';
                        }
                      },
                      controller: _passwordController,
                      hintText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outlined),
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    BuildDefaultButton(
                        text: const Text('Sign In'),
                        color: MyColors.red,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            String? _authResult =
                                await AuthService().signIn(email: _emailController.text.trim(), password: _passwordController.text.trim());
                            if (_authResult == 'Signed in') {
                              String _role = await AuthService().checkRole();
                              if (_role == 'Admin') {
                                await SharedPreferencesService().saveUserRole('Admin');
                                Go.pushAndRemoveUntil(context, const AdminBottomNavBar());
                              } else if (_role == 'User') {
                                await SharedPreferencesService().saveUserRole('User');
                                Go.pushAndRemoveUntil(context, const UserBottomNavBar());
                              } else if (_role == 'Food Recipient') {
                                await SharedPreferencesService().saveUserRole('Food Recipient');
                                Go.pushAndRemoveUntil(context, const FrBottomNavBar());
                              } else {
                                Show.snackbar(context, 'Something went weong');
                              }
                            } else {
                              Show.snackbar(context, 'Wrong e-mail or password');
                            }
                          }
                        }),
                    const BuildOrDivider(),
                    BuildDefaultButton(
                        text: const Text('Sign Up'),
                        color: MyColors.yellow,
                        onPressed: () {
                          Go.pushAndRemoveUntil(context, const SignupPage());
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
