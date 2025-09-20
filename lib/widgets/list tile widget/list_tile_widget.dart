import 'package:flutter/material.dart';

class ListTileWidget extends StatelessWidget {
  const ListTileWidget({
    super.key,
    required this.leadingIcon,
    required this.title,
    required this.onTap,
    this.trailing = const Icon(Icons.arrow_forward),
  });
  final IconData leadingIcon;
  final String title;
  final void Function() onTap;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: Colors.orange,
        child: Icon(leadingIcon, color: Colors.white),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: trailing,
    );
  }
}
