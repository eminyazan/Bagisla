import 'dart:io';

import 'package:bagisla/model/error_manager/error_manager.dart';
import 'package:bagisla/model/user/user_model.dart';
import 'package:bagisla/view/colors/app_colors.dart';
import 'package:bagisla/view/components/already_have_an_account_check.dart';
import 'package:bagisla/view/components/custom_alert_dialogs.dart';
import 'package:bagisla/view/components/custom_button.dart';
import 'package:bagisla/view/components/custom_image_picker.dart';
import 'package:bagisla/view/components/custom_navigation.dart';
import 'package:bagisla/view/components/custom_text_field.dart';
import 'package:bagisla/view/components/view_state.dart';
import 'package:bagisla/view/pages/home/home_page.dart';
import 'package:bagisla/view/pages/loading/loading_page.dart';
import 'package:bagisla/view/pages/privacy_policy/privacy_policy.dart';
import 'package:bagisla/viewmodel/register/register_page_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  late CustomTextField _nameTextField, _surnameTextField, _mailTextField, _passTextField;

  UserModel? _user;

  Rx<File?> image = Rx<File?>(null);

  final RegisterPageViewModel _registerPageViewModel = RegisterPageViewModel();
  final _formKey = GlobalKey<FormState>();
  final CustomImagePicker _customImagePicker = CustomImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

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
      controller: _passController,
      obscureText: true,
      icon: const Icon(
        Icons.lock,
        color: Colors.white,
      ),
    );
    _nameTextField = CustomTextField(
      hintText: "Adınız",
      controller: _nameController,
      icon: const Icon(
        Icons.person,
        color: Colors.white,
      ),
    );
    _surnameTextField = CustomTextField(
      hintText: "Soyadınız",
      controller: _surnameController,
      icon: const Icon(
        Icons.person_outline_sharp,
        color: Colors.white,
      ),
    );
  }

  _formSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        _user = UserModel(
          name: _nameTextField.onSave()!,
          surname: _surnameTextField.onSave()!,
          email: _mailTextField.onSave()!,
        );
        _user = await _registerPageViewModel.register(
          _passTextField.onSave()!,
          _user!,
          image.value,
        );
        if (_user == null) {
          await customAlertDialogError(
            context,
            "HATA!",
            "Beklenmeyen bir hata oluştu daha sonra tekrar deneyin",
          );
        } else {
          goPageAndClearStack(context, const HomePage());
        }
      } on FirebaseAuthException catch (e) {
        _registerPageViewModel.setViewState = ViewState.idle;
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
      () => _registerPageViewModel.getViewState == ViewState.idle
          ? Scaffold(
              body: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                      child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        const Text(
                          "Kayıt Olun",
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: size.height * 0.03),
                        Obx(
                          () => Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () async {
                                    return showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return SizedBox(
                                            height: size.height * 0.15,
                                            child: Column(
                                              children: <Widget>[
                                                ListTile(
                                                  leading: const Icon(
                                                    Icons.camera_alt,
                                                  ),
                                                  title: const Text("Kameradan Çek"),
                                                  onTap: () async {
                                                    await _customImagePicker.takePicFromCamera().then((value) {
                                                      image.value = value;
                                                      goBack(context);
                                                    });
                                                  },
                                                ),
                                                ListTile(
                                                  leading: const Icon(Icons.image),
                                                  title: const Text("Galeriden Seç"),
                                                  onTap: () async {
                                                    await _customImagePicker.chooseFromGallery().then((value) {
                                                      image.value = value;
                                                      goBack(context);
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  child: Stack(
                                    alignment: AlignmentDirectional.bottomEnd,
                                    children: [
                                      CircleAvatar(
                                        radius: size.width * 0.2,
                                        backgroundColor: AppColors.appBarColor,
                                        backgroundImage: (image.value != null)
                                            ? FileImage(
                                                image.value!,
                                              )
                                            : null,
                                        child: image.value == null
                                            ? const Icon(
                                                Icons.camera_alt,
                                                size: 45,
                                                color: Colors.white,
                                              )
                                            : null,
                                      ),
                                      image.value == null
                                          ? const Icon(Icons.camera_alt, color: AppColors.signInColor)
                                          : const SizedBox()
                                    ],
                                  ),
                                ),
                              ),
                              image.value != null
                                  ? const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Profil Resminiz",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    )
                                  : const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Profil Resmi Ekleyebilirsiniz",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        _nameTextField,
                        _surnameTextField,
                        _mailTextField,
                        _passTextField,
                        Center(
                          child: SizedBox(
                            width: size.width*0.75,
                            child: GestureDetector(
                              child: const Text(
                                "Uygulamaya kayıt olarak KVKK ve Hizmet sartlarını kabul etmiş olursunuz",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                ),
                              ),
                              onTap: () => _goToTermsPage(),
                            ),
                          ),
                        ),
                        CustomButton(
                          press: () => _formSubmit(),
                          text: "Kaydol",
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: AlreadyHaveAnAccountCheck(
                            login: false,
                            press: () => goBack(
                              context,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                ),
              ),
            )
          : const LoadingPage(),
    );
  }

  _goToTermsPage() {
    goPage(context, const PrivacyPolicyPage());
  }
}
