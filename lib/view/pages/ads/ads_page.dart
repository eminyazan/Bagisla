import 'package:bagisla/model/ad/ad_model.dart';
import 'package:bagisla/view/components/custom_ad_card.dart';
import 'package:bagisla/view/components/view_state.dart';
import 'package:bagisla/view/pages/loading/loading_page.dart';
import 'package:bagisla/viewmodel/ads/ads_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../view/pages/search/search_page.dart';
import '../../../view/pages/settings/settings_page.dart';

class AdsPage extends StatefulWidget {
  const AdsPage({Key? key}) : super(key: key);

  @override
  State<AdsPage> createState() => _AdsPageState();
}

class _AdsPageState extends State<AdsPage> {
  final AdsPageViewModel _adsPageViewModel = AdsPageViewModel();
  final List<AdModel> _myAds = [];

  _getAds() async {
    List<AdModel>? ads = await _adsPageViewModel.getAllAds();
    ads == null ? ads = _myAds : _myAds.addAll(ads);
  }

  @override
  void initState() {
    super.initState();
    _getAds();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Obx(
      () => _adsPageViewModel.getViewState == ViewState.idle
          ? Scaffold(
              appBar: AppBar(
                title: const Text('Ana Sayfa'),
                actions: [
                  IconButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const SearchPage(),
                      ),
                    ),
                    icon: const Icon(Icons.search),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const SettingsPage(),
                      ),
                    ),
                    icon: const Icon(Icons.settings),
                  ),
                ],
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
                        "Henüz ilan oluşturulmamış.",
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
