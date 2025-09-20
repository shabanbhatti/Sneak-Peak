import 'package:flutter/material.dart';
import 'package:sneak_peak/utils/constants_colors.dart';

class MyOutlinedButton extends StatelessWidget {
  const MyOutlinedButton({
    super.key,
    required this.isSelected,
    required this.title,
    required this.onClicked,
  });
  final bool isSelected;
  final String title;
  final void Function() onClicked;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor:
            (isSelected) ? Colors.orange : Colors.grey.withAlpha(70),
        side: BorderSide(color: appGreyColor),
      ),
      onPressed: onClicked,
      child: Text(
        title,
        style: TextStyle(color: (isSelected) ? Colors.white : appGreyColor),
      ),
    );
  }
}
