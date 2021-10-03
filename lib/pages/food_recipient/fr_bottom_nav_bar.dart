import 'package:flutter/material.dart';
import 'package:food_wastage/constants/fr_bottom_nav_bar_category_list.dart';
import 'package:food_wastage/pages/food_recipient/fr_chats_page.dart';
import 'package:food_wastage/pages/food_recipient/fr_settings.dart';
import 'package:food_wastage/pages/food_recipient/fr_view_events.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class FrBottomNavBar extends StatefulWidget {
  const FrBottomNavBar({Key? key}) : super(key: key);

  @override
  _FrBottomNavBarState createState() => _FrBottomNavBarState();
}

class _FrBottomNavBarState extends State<FrBottomNavBar> {
  int _currentIndex = 0;
  List _pages = [
    FrViewEvents(),
    FrChatsPage(),
    FrSettings(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: frBottomNavBarCategoryList[_currentIndex].title,
          centerTitle: true),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: frBottomNavBarCategoryList,
      ),
      body: _pages[_currentIndex],
    );
  }
}
