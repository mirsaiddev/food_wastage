import 'package:flutter/material.dart';
import 'package:food_wastage/constants/admin_bottom_nav_bar_category.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'admin_settings.dart';
import 'admin_view_events.dart';
import 'admin_view_accounts.dart';

class AdminBottomNavBar extends StatefulWidget {
  const AdminBottomNavBar({Key? key}) : super(key: key);

  @override
  _AdminBottomNavBarState createState() => _AdminBottomNavBarState();
}

class _AdminBottomNavBarState extends State<AdminBottomNavBar> {
  int _currentIndex = 0;
  List _pages = [
    AdminViewAccounts(),
    AdminViewEvents(),
    AdminSettings(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: adminBottomNavBarCategoryList[_currentIndex].title, centerTitle: true),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: adminBottomNavBarCategoryList,
      ),
      body: _pages[_currentIndex],
    );
  }
}
