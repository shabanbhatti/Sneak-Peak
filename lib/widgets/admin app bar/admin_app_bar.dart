import 'package:flutter/material.dart';
import 'package:sneak_peak/utils/constants_imgs_paths.dart';

PreferredSizeWidget adminAppBar(String title) {
  return AppBar(
    backgroundColor: Colors.transparent,

    leading: Padding(padding: EdgeInsets.all(8), child: Image.asset(imgLogo,)),
    centerTitle: true,

    title: Text(title, style: const TextStyle()),
  );
}
