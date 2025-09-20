import 'package:flutter/material.dart';

void pricesLowOrHighBottomSheet(BuildContext context, {required void Function() hightToLow,required void Function() lowToHigh} ) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.arrow_upward),
            title: const Text("Price Low to High"),
            onTap: lowToHigh
          ),
          ListTile(
            leading: const Icon(Icons.arrow_downward),
            title: const Text("Price High to Low"),
            onTap: hightToLow
          ),
        ],
      );
    },
  );
}
