import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

void loadingDialog(BuildContext context, String title, {Color? color}) {
  showCupertinoDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: color,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingAnimationWidget.flickr(
              leftDotColor: Colors.orange,
              rightDotColor: Colors.blue,
              size: 35,
            ),
          ],
        ),
        content: Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      );
    },
  );
}
