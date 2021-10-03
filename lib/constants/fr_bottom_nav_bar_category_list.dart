import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'colors.dart';

List<SalomonBottomBarItem> frBottomNavBarCategoryList = [
  SalomonBottomBarItem(
    icon: Icon(Icons.map),
    title: Text("View Events"),
    selectedColor: MyColors.red,
  ),
  SalomonBottomBarItem(
    icon: Icon(Icons.chat_bubble_outline_rounded),
    title: Text("Chats"),
    selectedColor: MyColors.red,
  ),
  SalomonBottomBarItem(
    icon: Icon(Icons.settings),
    title: Text("Settings"),
    selectedColor: MyColors.red,
  ),
];
