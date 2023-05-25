import 'package:flutter/material.dart';


class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final Function press;
  const AlreadyHaveAnAccountCheck({
    Key? key,
    this.login = true,
    required this.press,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "Hesabınız yok mu?  Hemen " : "Hesabınız varsa hemen ",
          style: const TextStyle(color: Colors.black54,fontSize: 16),
        ),
        GestureDetector(
          onTap: ()=>press(),
          child: Text(
            login ? "Kaydolun" : "Giriş Yapın",
            style: TextStyle(
                color: Colors.green.shade600,
                fontWeight: FontWeight.bold,
                fontSize: 17
            ),
          ),
        )
      ],
    );
  }
}
