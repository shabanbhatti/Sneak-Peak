import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileCircleAvatarWidget extends StatelessWidget {
  const ProfileCircleAvatarWidget({
    super.key,
    required this.imgUrl,
    required this.onTap,
    this.fit = BoxFit.contain,
  });
  final String imgUrl;
  final void Function() onTap;
  final BoxFit? fit;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: ShapeDecoration(
          shape: CircleBorder(
            // side: BorderSide(color: Colors.white, width: 1),
          ),
          color: Colors.grey,
        ),
        child: CachedNetworkImage(
          imageUrl: imgUrl,
          fit: fit,
          height: double.infinity,
          width: double.infinity,
          progressIndicatorBuilder:
                  (context, url, progress) => Skeletonizer(
                    enabled: true,
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.grey,
                    ),
                  ),
        ),
      ),
    );
  }
}
