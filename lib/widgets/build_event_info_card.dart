import 'package:flutter/material.dart';
import 'package:food_wastage/pages/user/user_events.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildEventInfoCard extends StatelessWidget {
  const BuildEventInfoCard({
    Key? key,
    required this.username,
    required this.location,
    required this.dateAdded,
    required this.foodCondition,
    required this.note,
    required this.userUID,
    required this.button,
  }) : super(key: key);

  final String username, location, dateAdded, foodCondition, note, userUID;
  final Widget button;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.w),
        margin: EdgeInsets.all(30.w),
        height: 350.h,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.w)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InfoRow(infoKey: 'Username', value: username),
            InfoRow(infoKey: 'Location', value: location),
            InfoRow(infoKey: 'Date Added', value: dateAdded),
            InfoRow(infoKey: 'Food Condition', value: foodCondition),
            note.characters.length > 1 ? InfoRow(infoKey: 'Note', value: note) : SizedBox(),
            button,
          ],
        ),
      ),
    );
  }
}
