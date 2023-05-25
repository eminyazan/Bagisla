import 'package:bagisla/consts/consts.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("KVKK ve Hizmet Şartları"),
        centerTitle: true,
      ),
      body:const SingleChildScrollView (
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              PRIVACY_POLICY,
            ),
          ),
        ),
      ),
    );
  }
}
