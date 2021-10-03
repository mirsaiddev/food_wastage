import 'package:flutter/material.dart';
import 'package:food_wastage/constants/colors.dart';
import 'package:food_wastage/helpers/navigator_helper.dart';
import 'package:food_wastage/helpers/show.dart';
import 'package:food_wastage/main.dart';
import 'package:food_wastage/models/my_user.dart';
import 'package:food_wastage/pages/auth/role_chose_page.dart';
import 'package:food_wastage/pages/auth/signin_page.dart';
import 'package:food_wastage/services/auth_service.dart';
import 'package:food_wastage/widgets/build_auth_page_text.dart';
import 'package:food_wastage/widgets/build_default_button.dart';
import 'package:food_wastage/widgets/build_icon.dart';
import 'package:food_wastage/widgets/build_or_divider.dart';
import 'package:food_wastage/widgets/build_textfield.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final MyUser _user = MyUser();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.yellowAccent,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const BuildIcon(),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    const BuildAuthPageText(text1: 'Hello !', text2: 'Let\'s Start'),
                    BuildTextField(
                      onChanged: (value) => setState(() {
                        _user.username = value;
                      }),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please fill this field';
                        }
                      },
                      controller: _usernameController,
                      hintText: 'Ad Soyad',
                      prefixIcon: const Icon(Icons.person_outlined),
                      keyboardType: TextInputType.name,
                    ),
                    BuildTextField(
                      onChanged: (value) => setState(() {
                        _user.email = value;
                      }),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please fill this field';
                        }
                        if (!value.isValidEmail()) {
                          return 'Please type a correct email';
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
                        if (value.characters.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                      },
                      controller: _passwordController,
                      hintText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outlined),
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    BuildDefaultButton(
                        text: const Text('Sign Up'),
                        color: MyColors.yellow,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            String? _authResult = await AuthService().signUp(
                                email: _emailController.text.trim(), password: _passwordController.text.trim(), username: _usernameController.text);

                            if (_authResult == 'Signed up') {
                              Go.push(context, const RoleChosePage());
                            } else {
                              Show.snackbar(context, 'Something went wrong');
                            }
                          }
                        }),
                    const BuildOrDivider(),
                    BuildDefaultButton(
                        text: const Text('Sign In'),
                        color: MyColors.red,
                        onPressed: () {
                          Go.pushAndRemoveUntil(context, const SigninPage());
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
