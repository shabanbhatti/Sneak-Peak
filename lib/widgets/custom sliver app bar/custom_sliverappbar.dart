import 'package:flutter/material.dart';
import 'package:sneak_peak/utils/constants_colors.dart';

class CustomSliverAppBar extends StatelessWidget {
  const CustomSliverAppBar({
    super.key,
    this.title,
    required this.leadingOnTap,
    required this.leadingIcon,
    this.bottom,
    this.pinned = false,
    this.isTrailing = false,
    this.onTrailing,
    this.trailingIcon,
    this.widget,
    this.titleWidget,
  });
  final String? title;
  final Widget? titleWidget;
  final void Function() leadingOnTap;
  final IconData leadingIcon;
  final PreferredSizeWidget? bottom;
  final bool? pinned;
  final bool? isTrailing;
  final IconData? trailingIcon;
  final void Function()? onTrailing;
  final Widget? widget;
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
          child: IconButton(
            onPressed: leadingOnTap,
            icon: Icon(leadingIcon, color: appGreyColor),
          ),
        ),
      ),
      centerTitle: true,
      title:
          (titleWidget == null)
              ? Text(title ?? '', style: TextStyle(fontSize: 18))
              : titleWidget,
      bottom: bottom,
      pinned: pinned!,
      actions: [
        Padding(padding: EdgeInsets.all(5), child: widget ?? const SizedBox()),
      ],
    );
  }
}
