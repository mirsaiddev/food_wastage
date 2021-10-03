import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Go {
  Go.push(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  Go.replacement(BuildContext context, Widget page) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  Go.pop(BuildContext context, dynamic T) {
    Navigator.pop(context, T);
  }

  Go.pushAndRemoveUntil(BuildContext context, Widget page) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => page,
      ),
      (Route<dynamic> route) => false,
    );
  }
}
