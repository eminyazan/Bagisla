import 'package:bagisla/consts/consts.dart';
import 'package:bagisla/model/user/user_model.dart';
import 'package:bagisla/view/colors/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'service/db/local_db_service.dart';
import 'view/pages/home/home_page.dart';
import 'view/pages/login/login_page.dart';
import 'view/pages/onboard/onboarding_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>(LOCAL_DB_BOX);
  await Hive.openBox<bool>(ONBOARD_BOX);

  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  MyApp({
    Key? key,
  }) : super(key: key);
  final LocalDBService localDBService = LocalDBService();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Bağışla',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green.shade700,
        primarySwatch: AppColors.appMainColor,
      ),
      home: localDBService.readOnBoardFromLocalDB()
          ? const OnBoardingPage()
          : localDBService.readUserFromLocalDB() == null
              ? const LoginPage()
              : const HomePage(),
    );
  }
}
