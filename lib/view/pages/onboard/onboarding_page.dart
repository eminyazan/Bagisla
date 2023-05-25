import 'package:bagisla/service/db/local_db_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../../view/pages/login/login_page.dart';

class OnBoardingPage extends StatefulWidget {

  const OnBoardingPage({
    Key? key,

  }) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return _OnBoardingPageState();
  }
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  final LocalDBService _localDBService=LocalDBService();

  Future<void> _onIntroEnd(context) async {
    await _localDBService.saveOnBoardPageVisited(true);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) =>  const LoginPage(),
      ),
      (route) => false,
    );
  }

  Widget _buildImage(String assetName) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SvgPicture.asset('assets/images/$assetName.svg', width: 250.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Zor zamanlarınızda yanınızda olan uygulama",
          body:
              "Hayat inişlerle çıkışlarla dolu bir serüvendir. Hepimiz kimi zaman zor zamanlar geçiririz. Zor zamanlarınızda gerçekten yanınızda olmak için buradayız.",
          image: _buildImage('receipt'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Peki ama nasıl?",
          body:
              "Ödeyemediğiniz faturaları, kredi borçlarınızı, haciz ve icra belgelerinizi uygulamamıza yükleyin. Yardımsever insanların size ulaşmasını kolaylaştıralım.",
          image: _buildImage('credit-card'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Yardımsever Topluluk",
          body:
              "Gerçek ihtiyaç sahipleri ve yardımsever insanları bir araya getirme umuduyla bu uygulamayı kurduk. Sende aramıza katıl ve iyilik bir adım daha genişlesin.",
          image: _buildImage('help'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: true,
      nextFlex: 0,
      skip: const Text("Atla"),
      next: const Icon(Icons.arrow_forward),
      done: const Text(
        "Hemen Başlayın",
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(25.0),
          ),
        ),
      ),
    );
  }
}
