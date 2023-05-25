import 'package:bagisla/model/ad/ad_model.dart';
import 'package:bagisla/view/components/custom_ad_card.dart';
import 'package:bagisla/view/components/view_state.dart';
import 'package:bagisla/view/pages/loading/loading_page.dart';
import 'package:bagisla/viewmodel/my-ads/my_ads_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyAdsPage extends StatefulWidget {
  const MyAdsPage({Key? key}) : super(key: key);

  @override
  State<MyAdsPage> createState() => _MyAdsPageState();
}

class _MyAdsPageState extends State<MyAdsPage> {
  final List<AdModel> _myAds = [];

  final MyAdsPageViewModel _myAdsPageViewModel = MyAdsPageViewModel();

  @override
  void initState() {
    super.initState();
    _getMyAds();
  }

  _getMyAds() async {
    List<AdModel>? ads = await _myAdsPageViewModel.getAdsFromDB();
    ads == null ? ads = _myAds : _myAds.addAll(ads);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Obx(
      () => _myAdsPageViewModel.getViewState == ViewState.idle
          ? Scaffold(
              appBar: AppBar(
                title: const Text("İlanlarım"),
              ),
              body: _myAds.isNotEmpty
                  ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: size.width / size.height / 0.9,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      padding: const EdgeInsets.all(10),
                      itemCount: _myAds.length,
                      itemBuilder: (context, index) =>
                          AdCard(ad: _myAds[index]),
                      shrinkWrap: true,
                      primary: false,
                    )
                  : const Center(
                      child: Text(
                        "Henüz ilan oluşturmadınız.",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                        ),
                      ),
                    ),
            )
          : const LoadingPage(),
    );
  }
}
