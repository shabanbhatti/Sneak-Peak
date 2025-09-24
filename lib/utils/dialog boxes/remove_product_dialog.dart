

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/controllers/admin%20controllers/add_colors_riverpod.dart';
import 'package:sneak_peak/controllers/admin%20controllers/product_db_riverpod.dart';

void showRemoveItemDialog(BuildContext context, void Function() onDel) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.warning, color: Colors.red, size: 30),
            SizedBox(width: 8),
            Text('Remove Item', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          'Are you sure you want to remove this item?\n'
          'This action will also remove it for all users.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: onDel,
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}

void removeAllItemsDialog(BuildContext context, void Function() onDel) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Consumer(
          builder: (context, ref, child) {
            var product = ref.watch(addProductColorProvider);
            return (product is ProductLoadingState)
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [CupertinoActivityIndicator()],
                )
                : Row(
                  children: const [
                    Icon(Icons.warning, color: Colors.red, size: 30),
                    SizedBox(width: 8),
                    Text(
                      'Remove all Item',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                );
          },
        ),
        content: Consumer(
          builder: (context, ref, child) {
            var product = ref.watch(addProductColorProvider);
            return (product is ProductLoadingState)
                ? Text('Deleting....')
                : const Text(
                  'Are you sure you want to remove all items?\n'
                  'This action will also remove them for all users.',
                  style: TextStyle(fontSize: 16),
                );
          },
        ),
        actions: [
          Consumer(
            builder: (context, ref, child) {
              var product = ref.watch(addProductColorProvider);
              return (product is ProductLoadingState)
                  ? const SizedBox()
                  : TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  );
            },
          ),

          Consumer(
            builder: (context, ref, child) {
              var product = ref.watch(addProductColorProvider);
              return (product is ProductLoadingState)
                  ? const SizedBox()
                  : TextButton(
                    onPressed: onDel,
                    child: const Text(
                      'Remove',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
            },
          ),
        ],
      );
    },
  );
}
