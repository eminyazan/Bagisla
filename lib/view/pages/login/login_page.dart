import 'package:bagisla/model/user/user_model.dart';
import 'package:bagisla/view/pages/home/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../model/error_manager/error_manager.dart';
import '../../../view/components/already_have_an_account_check.dart';
import '../../../view/components/custom_alert_dialogs.dart';
import '../../../view/components/custom_button.dart';
import '../../../view/components/custom_navigation.dart';
import '../../../view/components/custom_text_field.dart';
import '../../../view/components/view_state.dart';
import '../../../view/pages/loading/loading_page.dart';
import '../../../view/pages/register/register_page.dart';
import '../../../viewmodel/login/login_page_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final LoginPageViewModel _loginPageViewModel = LoginPageViewModel();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late CustomTextField _mailTextField, _passTextField;

  @override
  void initState() {
    super.initState();
    _mailTextField = CustomTextField(
      hintText: "Mail Adresiniz",
      controller: _mailController,
      icon: const Icon(
        Icons.mail,
        color: Colors.white,
      ),
    );
    _passTextField = CustomTextField(
      hintText: "Şifreniz",
      controller: _passwordController,
      obscureText: true,
      icon: const Icon(
        Icons.lock,
        color: Colors.white,
      ),
    );
  }

  _formSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        UserModel? user = await _loginPageViewModel.login(
          _mailTextField.onSave()!,
          _passTextField.onSave()!,
        );
        if (user == null) {
          await customAlertDialogError(
            context,
            "HATA!",
            "Beklenmeyen bir hata oluştu daha sonra tekrar deneyin",
          );
        } else {

          goPageAndClearStack(context, const HomePage());
        }
      } on FirebaseAuthException catch (e) {
        _loginPageViewModel.setViewState=ViewState.idle;
        await customAlertDialogError(
          context,
          "HATA!",
          ErrorManager.show(
            e.code,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Obx(
      () => _loginPageViewModel.getViewState == ViewState.idle
          ? Scaffold(
              body: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            "Giriş Yapın",
                            style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: size.height * 0.03),
                          SvgPicture.asset(
                            "assets/images/help.svg",
                            height: size.height * 0.3,
                          ),
                          SizedBox(height: size.height * 0.03),
                          _mailTextField,
                          _passTextField,
                          CustomButton(
                            text: "Giriş Yap",
                            press: () {
                              _formSubmit();
                            },
                          ),
                          SizedBox(height: size.height * 0.03),
                          AlreadyHaveAnAccountCheck(
                            login: true,
                            press: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          : const LoadingPage(),
    );
  }
}
