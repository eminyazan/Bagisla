import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../view/colors/app_colors.dart';

Future<void> customAlertDialogError(BuildContext context, String title, String desc) async {
  await Alert(
    context: context,
    type: AlertType.error,
    title: title,
    desc: desc,
    buttons: [
      DialogButton(
        color: AppColors.buttonColor,
        onPressed: () => Navigator.pop(context),
        width: 120,
        child: const Text(
          "Tamam",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    ],
  ).show();
}

Future<void> customAlertDialogWarning(BuildContext context, String title, String desc) async {
  await Alert(
    context: context,
    type: AlertType.warning,
    title: title,
    desc: desc,
    buttons: [
      DialogButton(
        color: AppColors.buttonColor,
        onPressed: () => Navigator.pop(context),
        width: 120,
        child: const Text(
          "Tamam",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    ],
  ).show();
}

Future<void> customAlertDialogSuccess(BuildContext context, String title, String desc) async {
  await Alert(
    context: context,
    type: AlertType.success,
    title: title,
    desc: desc,
    buttons: [
      DialogButton(
        color: Colors.greenAccent,
        onPressed: () => Navigator.pop(context),
        width: 120,
        child: const Text(
          "Tamam",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    ],
  )
      .show();
}