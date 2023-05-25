// ignore_for_file: use_build_context_synchronously

import 'package:bagisla/model/ad/ad_model.dart';
import 'package:bagisla/model/user/user_model.dart';
import 'package:bagisla/service/db/local_db_service.dart';
import 'package:bagisla/util/copy_clipboard.dart';
import 'package:bagisla/util/human_readable_date.dart';
import 'package:bagisla/view/colors/app_colors.dart';
import 'package:bagisla/view/components/custom_alert_dialogs.dart';
import 'package:bagisla/view/components/custom_button.dart';
import 'package:bagisla/view/components/custom_navigation.dart';
import 'package:bagisla/view/components/view_state.dart';
import 'package:bagisla/view/pages/chats/chat_page.dart';
import 'package:bagisla/view/pages/home/home_page.dart';
import 'package:bagisla/view/pages/loading/loading_page.dart';
import 'package:bagisla/viewmodel/my-ads/ad_detail_page_view_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdDetailPage extends StatefulWidget {
  final AdModel ad;

  const AdDetailPage({Key? key, required this.ad}) : super(key: key);

  @override
  State<AdDetailPage> createState() => _AdDetailPageState();
}

class _AdDetailPageState extends State<AdDetailPage> {
  final AdDetailPageViewModel _adDetailPageViewModel = AdDetailPageViewModel();
  final LocalDBService _localDBService = LocalDBService();
  UserModel? _user;
  bool isSameUser = false;

  @override
  void initState() {
    super.initState();
    _getUserInfo(widget.ad.ownerUid!);
  }

  void _getUserInfo(String ownerUid) async {
    _user = await _adDetailPageViewModel.getUserInfo(ownerUid);
    _user ??
        await customAlertDialogError(
          context,
          "HATA!",
          "Kullanıcı bilgileri getirilemedi daha sonra tekrar deneyin",
        );
    _user != null
        ? isSameUser = _localDBService.readUserFromLocalDB()!.uid == _user!.uid!
        : false;
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Obx(
      () => _adDetailPageViewModel.getViewState == ViewState.idle
          ? Scaffold(
              appBar: AppBar(
                title: const Text("İlan Detayı"),
                actions: [
                  IconButton(
                    onPressed: () async=> await copyToClipBoard(widget.ad.iban,"IBAN adresi"),
                    icon: const Icon(
                      Icons.copy,
                    ),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CarouselSlider(
                        options: CarouselOptions(
                          autoPlay: false,
                          enableInfiniteScroll: false,
                        ),
                        items: widget.ad.images!
                            .map(
                              (item) => Center(
                                child: Image.network(
                                  item,
                                  fit: BoxFit.cover,
                                  width: size.width * 0.65,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    SizedBox(height: (size.height * 0.01) * 1.5),
                    Container(
                      padding: EdgeInsets.fromLTRB(
                          (size.height * 0.01),
                          (size.height * 0.01) * 2,
                          (size.height * 0.01),
                          (size.height * 0.01)),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.ad.category,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: (size.height * 0.01)),
                              Text(
                                "${widget.ad.amount} ₺",
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: (size.height * 0.01)),
                            child: Text(
                              widget.ad.description!,
                            ),
                          ),
                          const Divider(
                            thickness: 2,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: (size.height * 0.01)),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Ödenme Durumu",
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    widget.ad.payed
                                        ? Text(
                                            "ÖDENDİ",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              decoration:
                                                  TextDecoration.underline,
                                              color:
                                                  Colors.greenAccent.shade700,
                                            ),
                                          )
                                        : const Text(
                                            "ÖDENMEDİ",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Colors.red,
                                            ),
                                          )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "İlan Tarihi",
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      humanReadableDate(widget.ad.date!),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onLongPress: () async=> await copyToClipBoard(widget.ad.iban,"IBAN adresi"),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "IBAN",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        widget.ad.iban,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Container(
                              color: Colors.grey.shade100,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            _user!.photoUrl!,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(_user!.name),
                                        ),
                                      ],
                                    ),
                                    isSameUser
                                        ? const SizedBox()
                                        : ElevatedButton(
                                            onPressed: () async {
                                              UserModel? user =
                                                  await _adDetailPageViewModel
                                                      .getUserInfo(
                                                widget.ad.ownerUid!,
                                              );
                                              user != null
                                                  ? goPage(
                                                      context,
                                                      ChatPage(
                                                        chattedUserUid: widget.ad.ownerUid!,
                                                      ),
                                                    )
                                                  : await customAlertDialogError(
                                                      context,
                                                      "HATA!",
                                                      "Kullanıcı bilgisi alınamadı!",
                                                    );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: AppColors.buttonColor,
                                              shape: const StadiumBorder(),
                                            ),
                                            child: const Text("Mesaj Gönder"),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          isSameUser && !widget.ad.payed
                              ? Center(
                                  child: CustomButton(
                                    text: "Ödendi olarak işaretle",
                                    press: () {
                                      _checkPaymentRequest();
                                    },
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          : const LoadingPage(),
    );
  }

  _checkPaymentRequest() {
    return showDialog(
      context: (context),
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Onay"),
          content: const Text(
              "Faturanız ödendi olarak işaretlenecek onaylıyor musunuz?"),
          actions: [
            TextButton(
              onPressed: () async {
                goBack(context);
                _updatePaymentStatus();
              },
              child: const Text("Onayla"),
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

  void _updatePaymentStatus() async {
    bool res = await _adDetailPageViewModel.updatePaymentStatus(widget.ad.uid!);
    if (res) {
      await customAlertDialogSuccess(
        context,
        "BAŞARILI",
        "Faturanız ödendi olarak güncellendi",
      );
      goPageAndClearStack(context, const HomePage());
    } else {
      await customAlertDialogError(
        context,
        "HATA!",
        "Faturanızgüncellenirken hata oluştu",
      );
      goPageAndClearStack(context, const HomePage());
    }
  }
}
