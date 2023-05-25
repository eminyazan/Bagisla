import 'dart:io';

import 'package:bagisla/model/error_manager/error_manager.dart';
import 'package:bagisla/model/user/user_model.dart';
import 'package:bagisla/view/colors/app_colors.dart';
import 'package:bagisla/view/components/custom_alert_dialogs.dart';
import 'package:bagisla/view/components/custom_button.dart';
import 'package:bagisla/view/components/custom_image_picker.dart';
import 'package:bagisla/view/components/custom_navigation.dart';
import 'package:bagisla/view/components/custom_text_field.dart';
import 'package:bagisla/view/components/view_state.dart';
import 'package:bagisla/view/pages/home/home_page.dart';
import 'package:bagisla/view/pages/loading/loading_page.dart';
import 'package:bagisla/view/pages/login/login_page.dart';
import 'package:bagisla/viewmodel/settings/settings_page_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late CustomTextField _nameTextField, _surnameTextField, _mailTextField;

  final SettingsPageViewModel _settingsPageViewModel = SettingsPageViewModel();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final CustomImagePicker _customImagePicker = CustomImagePicker();

  final _formKey = GlobalKey<FormState>();
  Rx<File?> image = Rx<File?>(null);

  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _initializeTextFields();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    _user = await _settingsPageViewModel.getUserInfo();
    if (_user == null) {
      customAlertDialogError(
        context,
        "HATA!",
        "Beklenmeyen bir hata oluştu! daha sonra tekrar deneyin",
      );
      goPage(
        context,
        const HomePage(),
      );
    } else {
      _fillTextFields();
    }
  }

  Future<void> _fillTextFields() async {
    _nameController.text = _user!.name;
    _surnameController.text = _user!.surname;
    _mailController.text = _user!.email;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Obx(
      () => _settingsPageViewModel.getViewState == ViewState.idle
          ? Scaffold(
              appBar: AppBar(
                title: const Text(
                  "Ayarlar",
                ),
                actions: [
                  TextButton.icon(
                    onPressed: () => _logOutControl(),
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Çıkış Yap",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
              body: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                      child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
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
                                                  title: const Text(
                                                    "Kameradan Çek",
                                                  ),
                                                  onTap: () async {
                                                    await _customImagePicker.takePicFromCamera().then((value) {
                                                      image.value = value;
                                                      goBack(context);
                                                    });
                                                  },
                                                ),
                                                ListTile(
                                                  leading: const Icon(Icons.image),
                                                  title: const Text(
                                                    "Galeriden Seç",
                                                  ),
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
                                      image.value != null
                                          ? CircleAvatar(
                                              radius: size.width * 0.2,
                                              backgroundImage: FileImage(
                                                image.value!,
                                              ),
                                            )
                                          : CircleAvatar(
                                              radius: size.width * 0.2,
                                              backgroundImage: NetworkImage(_user!.photoUrl!),
                                            ),

                                      image.value != null
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
                                        "Yeni Profil Resminiz",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    )
                                  : const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Profil Resminiz",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        _nameTextField,
                        _surnameTextField,
                        _mailTextField,
                        CustomButton(text: "Şifre Değiştir", press: () => _resetPassword()),
                        image.value != null
                            ? CustomButton(
                                text: "Profil resmini güncelle",
                                press: () => _updateProfilePhoto(),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  )),
                ),
              ),
            )
          : const LoadingPage(),
    );
  }

  Future<void> _logOut() async {
    try {
      await _settingsPageViewModel.logout();

      goPageAndClearStack(
        context,
        const LoginPage(),
      );
    } on FirebaseAuthException catch (e) {
      customAlertDialogError(
        context,
        "HATA!",
        ErrorManager.show(
          e.code,
        ),
      );
    }
  }

  Future<void> _logOutControl() async {
    return showDialog(
      context: (context),
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Onay"),
          content: const Text("Çıkış yapacaksınız onaylıyor musunuz?"),
          actions: [
            TextButton(
              onPressed: () async {
                goBack(context);
                _logOut();
              },
              child: const Text("Çıkış Yap"),
            ),
            TextButton(
              onPressed: () {
                goBack(context);
              },
              child: const Text("Geri Dön"),
            ),
          ],
        );
      },
    );
  }

  void _initializeTextFields() {
    _mailTextField = CustomTextField(
      hintText: "Mail Adresiniz",
      controller: _mailController,
      readOnly: true,
      icon: const Icon(
        Icons.mail,
        color: Colors.white,
      ),
    );
    _nameTextField = CustomTextField(
      hintText: "Adınız",
      controller: _nameController,
      readOnly: true,
      icon: const Icon(
        Icons.person,
        color: Colors.white,
      ),
    );
    _surnameTextField = CustomTextField(
      hintText: "Soyadınız",
      controller: _surnameController,
      readOnly: true,
      icon: const Icon(
        Icons.person_outline_sharp,
        color: Colors.white,
      ),
    );
  }

  Future<void> _resetPassword() async {
    bool res = await _settingsPageViewModel.sendPasswordResetMail(_user!.email);
    if (res) {
      customAlertDialogSuccess(
        context,
        "Başarılı",
        "Şifre sıfırlama isteğiniz ${_user!.email} adresine gönderildi. Mail kutunuzu ve spam klasörünüzü kontrol edin",
      ).then((value) async => {await _logOut()});
    } else {
      await customAlertDialogError(
        context,
        "HATA",
        "Şifre sıfırlama isteğiniz alınırken hata oluştu. Daha sonra tekrar deneyiniz",
      );
    }
  }

  _updateProfilePhoto() async {
    try {
      bool res = await _settingsPageViewModel.updateProfilePhoto(image.value!);
      res
          ? await customAlertDialogSuccess(
              context,
              "İşlem başarılı",
              "Profil resminiz başarıyla güncellendi",
            )
          : null;
     await goPageAndClearStack(context, const HomePage());
    } on FirebaseException catch (e) {
      await customAlertDialogError(
        context,
        "HATA",
        "Hata oluştu ${e.message}",
      );
    }
  }
}
