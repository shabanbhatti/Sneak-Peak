import 'package:flutter/material.dart';
import 'package:sneak_peak/utils/constants_colors.dart';

class CustomSliverAppBar1 extends StatelessWidget {
  CustomSliverAppBar1({
    super.key,
    required this.title,
    required this.leadingOnTap,
    required this.leadingIcon,
    required this.trailingIcon,
    required this.onTrailingTap,
    this.trailingIconColor = Colors.orange,
    this.trailingIconSize = 30,
  });
  final String title;
  final void Function() leadingOnTap;
  final IconData leadingIcon;
  final IconData trailingIcon;
  final void Function() onTrailingTap;
  Color? trailingIconColor;
  double? trailingIconSize;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      snap: true,
      floating: true,
      backgroundColor: Colors.transparent,
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: CircleAvatar(
          backgroundColor: Colors.grey.withAlpha(70),
          child: IconButton(onPressed: leadingOnTap, icon: Icon(leadingIcon)),
        ),
      ),
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, color: appGreyColor),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: onTrailingTap,
                icon: Icon(
                  trailingIcon,
                  size: trailingIconSize,
                  color: trailingIconColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
