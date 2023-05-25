import 'package:flutter/material.dart';

goBack(BuildContext context) {
  Navigator.of(context).pop();
}

goPage(BuildContext context, Widget page) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}

goPageAndClearStack(BuildContext context, Widget page) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (context) => page,
    ),
    (route) => false,
  );
}
