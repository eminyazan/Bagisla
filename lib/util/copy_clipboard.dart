import 'package:flutter/services.dart';
import 'package:get/get.dart';

Future<void> copyToClipBoard(String text, String name) async {
  Clipboard.setData(
    ClipboardData(
      text: text,
    ),
  );
  await Get.snackbar("Başarılı", "$name kopyalandı").show();
}
