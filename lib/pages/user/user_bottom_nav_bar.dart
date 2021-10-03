import 'package:flutter/material.dart';
import 'package:food_wastage/constants/user_bottom_nav_bar_category_list.dart';
import 'package:food_wastage/pages/user/user_chats_page.dart';
import 'package:food_wastage/pages/user/user_events.dart';
import 'package:food_wastage/pages/user/user_new_event.dart';
import 'package:food_wastage/pages/user/user_settings.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class UserBottomNavBar extends StatefulWidget {
  const UserBottomNavBar({Key? key}) : super(key: key);

  @override
  _UserBottomNavBarState createState() => _UserBottomNavBarState();
}

class _UserBottomNavBarState extends State<UserBottomNavBar> {
  int _currentIndex = 0;
  List _pages = [
    UserNewEvent(),
    UserChatsPage(),
    UserEvents(),
    UserSettings(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: userBottomNavBarCategoryList[_currentIndex].title,
          centerTitle: true),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: userBottomNavBarCategoryList,
      ),
      body: _pages[_currentIndex],
    );
  }
}
