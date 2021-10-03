import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_wastage/constants/colors.dart';
import 'package:food_wastage/pages/auth/splash_page.dart';
import 'package:food_wastage/services/notification_service.dart';
import 'package:intl/intl.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await Firebase.initializeApp();
    NotificationService _notificationService = NotificationService();
    await _notificationService.checkNotifications();
    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) async {
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
    await Workmanager().registerPeriodicTask(
      'notificationTaskId',
      'notificationTask',
      frequency: Duration(minutes: 15),
    );
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(720, 1520),
      builder: () => MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.red,
          primaryColor: MyColors.red,
        ),
        home: const SplashPage(),
      ),
    );
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

extension FormatDate on DateTime {
  String format() {
    return '${DateFormat('MMM d, y').format(this)} at ${this.hour}:${this.minute}';
  }
}
