import 'package:flutter/material.dart';

import '../../view/colors/app_colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    this.bgColor = AppColors.signInColor,
    this.hintTextColor = Colors.white,
    this.radius = 17,
    this.width = 0.8,
    this.minValue = 3,
    this.maxLines = 1,
    this.inputType = TextInputType.text,
    this.errorMessage = "Bu alanın girilmesi zorunludur",
    this.obscureText = false,
    this.readOnly = false,
    this.isRequired = true,
    this.textColor = Colors.white,
    required this.hintText,
    required this.icon,
    required this.controller,
  }) : super(key: key);

  final Color bgColor;
  final Color hintTextColor;
  final String hintText;
  final String errorMessage;
  final Widget icon;
  final double radius;
  final double width;
  final int minValue;
  final int maxLines;
  final TextEditingController controller;
  final TextInputType inputType;
  final bool obscureText;
  final bool readOnly;
  final Color textColor;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      width: size.width * width,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(
          radius,
        ),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        obscureText: obscureText,
        readOnly: readOnly,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        validator: (value) {
          if (isRequired) {
            if (value!.isEmpty) {
              return errorMessage;
            } else if (value.length < minValue) {
              return errorMessage;
            } else {
              return null;
            }
          } else {
            return null;
          }
        },
        onSaved: (input) => onSave(),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.black,
              width: 2.5,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(
                radius,
              ),
            ),
          ),
          errorStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          icon: icon,
          hintText: hintText,
          hintStyle: TextStyle(
            color: hintTextColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  String? onSave() {
    return controller.text.isNotEmpty ? controller.text.trim().toString() : null;
  }
}
