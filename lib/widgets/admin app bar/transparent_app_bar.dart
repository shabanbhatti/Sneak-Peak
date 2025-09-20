import 'package:flutter/material.dart';
import 'package:sneak_peak/utils/constants_colors.dart';

PreferredSizeWidget transparentAppBar({
  required String title,
  required void Function() leadingOnTap,
  required IconData leadingIcon,
  required BuildContext context,
}) {
  return AppBar(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    leading: CircleAvatar(
      backgroundColor: Colors.transparent,
      child: CircleAvatar(
        backgroundColor: Colors.grey.withAlpha(70),
        child: IconButton(
          onPressed: leadingOnTap,
          icon: Icon(leadingIcon, color: appGreyColor),
        ),
      ),
    ),
    centerTitle: true,
    title: Text(title, style: const TextStyle()),
  );
}
