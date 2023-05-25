import 'package:bagisla/view/colors/app_colors.dart';
import 'package:flutter/material.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget>? actions;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        5,
      ),
      decoration: const BoxDecoration(
        color: AppColors.appBarColor,
        border: Border(
          bottom: BorderSide(
            color: AppColors.greyColor,
            width: 1.4,
            style: BorderStyle.solid,
          ),
        ),
      ),
      child: AppBar(
        backgroundColor: AppColors.appBarColor,
        elevation: 0,
        actions: actions,
        title: title,
      ),
    );
  }

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight + 10);
}
