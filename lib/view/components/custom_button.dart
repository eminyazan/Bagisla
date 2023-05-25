import 'package:flutter/material.dart';

import '../../view/colors/app_colors.dart';

class CustomButton extends StatelessWidget {

  const CustomButton({
    Key? key,
    required this.text,
    required this.press,
    this.color = AppColors.appBarColor,
    this.textColor = Colors.white,
    this.radius=7,
  }) : super(key: key);

  final String text;
  final VoidCallback press;
  final Color color, textColor;
  final double radius;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: press,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        width: size.width * 0.8,
        height: size.height * 0.07,
        decoration: BoxDecoration(
          color: color,
          borderRadius:  BorderRadius.all(
            Radius.circular(
              radius,
            ),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
