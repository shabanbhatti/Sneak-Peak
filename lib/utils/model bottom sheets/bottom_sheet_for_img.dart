import 'package:flutter/material.dart';
import 'package:sneak_peak/utils/constant_imgs.dart';

void showImageOptionsBottomSheet(
  BuildContext context,
  String path, {
  required void Function() onViewImage,
  required void Function() onChangeImage,
  required void Function() onDeleteImage,
}) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children:
              (path != profileIconUrl)
                  ? [
                    ListTile(
                      leading: const Icon(Icons.visibility),
                      title: const Text('View Image'),
                      onTap: onViewImage,
                    ),
                    ListTile(
                      leading: const Icon(Icons.image),
                      title: const Text('Change Image'),
                      onTap: onChangeImage,
                    ),
                    ListTile(
                      leading: const Icon(Icons.delete, color: Colors.red),
                      title: const Text(
                        'Delete Image',
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: onDeleteImage,
                    ),
                  ]
                  : [
                    ListTile(
                      leading: const Icon(Icons.image),
                      title: const Text('Upload Image'),
                      onTap: onChangeImage,
                    ),
                  ],
        ),
      );
    },
  );
}
