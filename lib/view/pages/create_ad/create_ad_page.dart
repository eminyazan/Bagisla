import 'dart:io';

import 'package:bagisla/consts/consts.dart';
import 'package:bagisla/model/ad/ad_model.dart';
import 'package:bagisla/model/ad_category/ad_categories.dart';
import 'package:bagisla/view/colors/app_colors.dart';
import 'package:bagisla/view/components/custom_alert_dialogs.dart';
import 'package:bagisla/view/components/custom_button.dart';
import 'package:bagisla/view/components/custom_image_picker.dart';
import 'package:bagisla/view/components/custom_navigation.dart';
import 'package:bagisla/view/components/custom_text_field.dart';
import 'package:bagisla/view/components/view_state.dart';
import 'package:bagisla/view/pages/home/home_page.dart';
import 'package:bagisla/view/pages/loading/loading_page.dart';
import 'package:bagisla/viewmodel/create-ad/create_ad_page_view_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateAdPage extends StatefulWidget {
  const CreateAdPage({Key? key}) : super(key: key);

  @override
  State<CreateAdPage> createState() => _CreateAdPageState();
}

class _CreateAdPageState extends State<CreateAdPage> {
  late CustomTextField _descriptionTextField, _amountTextField, _ibanTextField;

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _ibanController = TextEditingController();
  final CustomImagePicker _customImagePicker = CustomImagePicker();
  final CreateAdPageViewModel _createAdPageViewModel = CreateAdPageViewModel();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File? image;
  List<File> fileImages = [];
  String? _description, _amount, _iban;

  Map<AdCategory, String>? _adCategory;

  @override
  void initState() {
    super.initState();
    _initializeTextFields();
  }

  _initializeTextFields() {
    _descriptionTextField = CustomTextField(
      hintText: "Açıklama",
      controller: _descriptionController,
      isRequired: false,
      maxLines: 3,
      width: 0.95,
      icon: const Icon(
        Icons.description,
        color: Colors.white,
      ),
    );
    _amountTextField = CustomTextField(
      hintText: "Tutar",
      inputType: TextInputType.number,
      controller: _amountController,
      width: 0.95,
      minValue: 2,
      icon: const Icon(
        Icons.price_change_rounded,
        color: Colors.white,
      ),
    );
    _ibanTextField = CustomTextField(
      hintText: "IBAN numaranız",
      controller: _ibanController,
      inputType: TextInputType.number,
      width: 0.95,
      minValue: 24,
      icon: const Text(
        "TR",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      ),
    );
  }

  Future<void> _formSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _description = _descriptionTextField.onSave();
      _amount = _amountTextField.onSave();
      _iban = _ibanTextField.onSave();
      if (_adCategory == null) {
        await customAlertDialogError(
          context,
          "Eksik Bilgi!",
          "İlan kategorisi seçtiğinizden emin olun",
        );
      } else if (fileImages.isEmpty && image == null) {
        await customAlertDialogError(
          context,
          "Eksik Bilgi!",
          "Fatura resmi yüklediğinizden emin olun",
        );
      } else {
        AdModel ad = AdModel(
          description: _description,
          iban: _iban!,
          amount: int.parse(_amount!),
          category: _adCategory!.values.first,
        );

        bool? res = fileImages.isEmpty
            ? await _createAdPageViewModel.saveAdToDB(
                ad,
                [image!],
              )
            : await _createAdPageViewModel.saveAdToDB(
                ad,
                fileImages,
              );
        if (res == true) {
          await customAlertDialogSuccess(
            context,
            "İşlem Başarılı!",
            "İlanınız başarıyla oluşturuldu.",
          );

          goPageAndClearStack(context, const HomePage());
        } else {
          await customAlertDialogError(
            context,
            "HATA!",
            "İlanınız oluşturulamadı. Daha sonra tekrar deneyin.",
          );

          goPageAndClearStack(context, const HomePage());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Obx(
      () => _createAdPageViewModel.getViewState == ViewState.idle
          ? Scaffold(
              appBar: AppBar(
                title: const Text("İlan Ver"),
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          fileImages.isEmpty
                              ? GestureDetector(
                                  onTap: () async {
                                    await _openBottomSheet(size);
                                  },
                                  child: Column(
                                    children: [
                                      Stack(
                                        alignment: AlignmentDirectional.bottomEnd,
                                        children: [
                                          CircleAvatar(
                                            radius: size.width * 0.2,
                                            backgroundColor: AppColors.appBarColor,
                                            backgroundImage: (image != null)
                                                ? FileImage(
                                                    image!,
                                                  )
                                                : null,
                                            child: image == null
                                                ? const Icon(
                                                    Icons.camera_alt,
                                                    size: 45,
                                                    color: Colors.white,
                                                  )
                                                : null,
                                          ),
                                          image != null
                                              ? const Icon(Icons.camera_alt, color: AppColors.signInColor)
                                              : const SizedBox()
                                        ],
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        child: Text(
                                          "Fotoğraf ekleyin",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () async => await _openBottomSheet(size),
                                  child: Column(
                                    children: [
                                      Container(
                                        color: Colors.grey.shade200,
                                        child: CarouselSlider(
                                          options: CarouselOptions(
                                            autoPlay: true,
                                            enableInfiniteScroll: false,
                                          ),
                                          items: fileImages
                                              .map(
                                                (item) => Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(
                                                      8.0,
                                                    ),
                                                    child: Image.file(
                                                      item,
                                                      width: size.width * 0.75,
                                                      height: size.height * 0.25,
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        child: Text(
                                          "Fatura resimleriniz",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          SizedBox(
                            height: size.height * 0.075,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: AppColors.appBarColor,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: ButtonTheme(
                                    alignedDropdown: true,
                                    child: DropdownButton<Map<AdCategory, String>>(
                                      isDense: true,
                                      isExpanded: true,
                                      hint: const Text(
                                        "Kategori Seçin",
                                      ),
                                      value: _adCategory,
                                      onChanged: (Map<AdCategory, String>? newValue) async {
                                        setState(() {
                                          _adCategory = newValue;
                                        });
                                        _adCategory?.keys.first == AdCategory.debt
                                            ? await customAlertDialogWarning(
                                                context,
                                                "UYARI",
                                                "Faturanızın ödenebilmesi için mukavele, hesap numarası ve benzeri bilgilerin fotoğrafta gözükmesine dikkat edin",
                                              )
                                            : _adCategory?.keys.first == AdCategory.credit
                                                ? await customAlertDialogWarning(
                                                    context,
                                                    "UYARI!",
                                                    "Ekran görüntüsü alırken son ödeme tarihi ve borcunuzun gözükmesine dikkat edin",
                                                  )
                                                : null;
                                      },
                                      items: adCategories.map((Map<AdCategory, String> map) {
                                        return DropdownMenuItem<Map<AdCategory, String>>(
                                          value: map,
                                          child: Text(
                                            map.values.first,
                                            softWrap: false,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          _amountTextField,
                          _ibanTextField,
                          _descriptionTextField,
                          CustomButton(
                            text: "İlan Oluştur",
                            press: () => _formSubmit(),
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

  _openBottomSheet(Size size) {
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
                      image = value;
                      setState(() {});
                      goBack(context);
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.image),
                  title: const Text("Galeriden Seç"),
                  onTap: () async {
                    await _customImagePicker.chooseMultipleImage().then((List<File>? images) {
                      fileImages = images!;
                      setState(() {});
                      goBack(context);
                    });
                  },
                ),
              ],
            ),
          );
        });
  }
}
