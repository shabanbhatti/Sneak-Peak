import 'package:flutter/material.dart';

class IconsWidget extends StatelessWidget {
  const IconsWidget({
    super.key,
    required this.onTap,
    required this.title,
    required this.icon,
  });
  final void Function() onTap;
  final String title;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.orange,
              child: IconButton(
                onPressed: onTap,
                icon: Icon(icon, color: Colors.white),
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                title,
                maxLines: 2,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
