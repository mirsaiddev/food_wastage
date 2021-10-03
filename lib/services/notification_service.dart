import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:food_wastage/services/auth_service.dart';
import 'package:food_wastage/services/chat_service.dart';
import 'package:food_wastage/services/firestore_service.dart';
import 'package:food_wastage/services/shared_preferences_service.dart';

class NotificationService {
  Future<void> checkNotifications() async {
    FlutterLocalNotificationsPlugin _flutterLocalNotifications =
        new FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings _initializationSettingsAndroid =
        AndroidInitializationSettings('marker');
    IOSInitializationSettings _initializationSettingsIOS =
        IOSInitializationSettings();
    InitializationSettings _initializationSettings = InitializationSettings(
        android: _initializationSettingsAndroid,
        iOS: _initializationSettingsIOS);
    await _flutterLocalNotifications.initialize(_initializationSettings);
    await Firebase.initializeApp();

    String? _userRole = await SharedPreferencesService().getUserRole();

    if (_userRole != 'Admin') {
      if (await ChatService().isThereANewMessage()) {
        await _showNotification(_flutterLocalNotifications,
            title: 'Check the new messages.',
            content: 'There is some new messages!',
            image: 'marker');
      }
      if (_userRole == 'Food Recipient') {
        int? _totalEventNumber =
            await FirestoreService().getTotalEventsNumber();
        int? _localTotalEventNumber =
            await SharedPreferencesService().getTotalEvents();
        if (_localTotalEventNumber! < _totalEventNumber) {
          await _showNotification(_flutterLocalNotifications,
              title: 'Check the new events.',
              content: 'There is some new events added!',
              image: 'marker');
        }
      }
    }
  }

  Future<void> _showNotification(
    FlutterLocalNotificationsPlugin _flutterLocalNotifications, {
    required String title,
    required String content,
    required String image,
  }) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '1234',
      'New Event Notifications',
      'New Event Notifications',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      largeIcon: DrawableResourceAndroidBitmap(image),
      icon: "marker",
      ongoing: false,
    );
    IOSNotificationDetails iOSPlatformChannelSpecifics =
        new IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await _flutterLocalNotifications.show(
        0, title, content, platformChannelSpecifics,
        payload: 'Default_Sound');
  }
}
