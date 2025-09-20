import 'package:flutter/material.dart';

class ListTileProfileWidget extends StatelessWidget {
  const ListTileProfileWidget({
    super.key,
    required this.leadingIcon,
    required this.onTap,
    required this.title,
    this.trailingWidget
  });
  final IconData leadingIcon;
  final String title;
  final void Function() onTap;
  final Widget? trailingWidget;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          radius: 17,
          backgroundColor: Colors.orange,
          child: Icon(leadingIcon, color: Colors.white, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing:(trailingWidget==null)? const Icon(Icons.arrow_forward_ios_outlined):trailingWidget,
      ),
    );
  }
}
