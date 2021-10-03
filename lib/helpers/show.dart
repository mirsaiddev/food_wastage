import 'package:flutter/material.dart';

class Show {
  Show.snackbar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Show.dialog(BuildContext context, Widget dialog) {
    showDialog(context: context, builder: (context) => dialog);
  }
}
