import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../colors/app_colors.dart';
import '../ads/ads_page.dart';
import '../chats/chats_page.dart';
import '../create_ad/create_ad_page.dart';
import '../my_ads/my_ads_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  late PageController pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();

    pageController = PageController();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_page == 0) {
          SystemNavigator.pop();
          return false;
        } else {
          onPageChanged(0);
          navigationTapped(0);
          return false;
        }
      },
      child: Scaffold(
        body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          children: const [
            Center(
              child: AdsPage(),
            ),
            Center(
              child: CreateAdPage(),
            ),
            Center(
              child: ChatsPage(),
            ),
            Center(
              child: MyAdsPage(),
            ),
          ],
        ),
        bottomNavigationBar: CupertinoTabBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: (_page == 0) ? AppColors.tabColor : AppColors.greyColor,
              ),
              label: "Ana Sayfa",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_box_outlined,
                color: (_page == 1) ? AppColors.tabColor : AppColors.greyColor,
              ),
              label: "İlan Ver",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.chat,
                color: (_page == 2) ? AppColors.tabColor : AppColors.greyColor,
              ),
              label: "Sohbet",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.apps,
                color: (_page == 3) ? AppColors.tabColor : AppColors.greyColor,
              ),
              label: "İlanlarım",
            ),
          ],
          onTap: navigationTapped,
          currentIndex: _page,
        ),
      ),
    );
  }
}
