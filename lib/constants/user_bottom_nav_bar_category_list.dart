import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'colors.dart';

List<SalomonBottomBarItem> userBottomNavBarCategoryList = [
  SalomonBottomBarItem(
    icon: Icon(Icons.add_rounded),
    title: Text("New Event"),
    selectedColor: MyColors.red,
  ),
  SalomonBottomBarItem(
    icon: Icon(Icons.chat_bubble_outline_rounded),
    title: Text("Chats"),
    selectedColor: MyColors.red,
  ),
  SalomonBottomBarItem(
    icon: Icon(Icons.history),
    title: Text("Events"),
    selectedColor: MyColors.red,
  ),
  SalomonBottomBarItem(
    icon: Icon(Icons.settings_outlined),
    title: Text("Settings"),
    selectedColor: MyColors.red,
  ),
];
