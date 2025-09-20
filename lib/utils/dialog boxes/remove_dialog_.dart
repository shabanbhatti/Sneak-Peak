import 'package:flutter/material.dart';

void deleteDialog(BuildContext context,{required void Function() onDel,required String title,required String descripton,required String btnTitle}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children:  [
            const Icon(Icons.warning, color: Colors.red, size: 30),
            const SizedBox(width: 8),
            Text(title, style:const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content:  Text(
          descripton,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: onDel,
            child: Text(btnTitle, style:const TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}