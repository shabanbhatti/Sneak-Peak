import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CircleAvatarWidget extends StatelessWidget {
  const CircleAvatarWidget({
    super.key,
    required this.imgUrl,
    required this.onTap,
    this.fit= BoxFit.contain
  });
  final String imgUrl;
  final void Function() onTap;
final BoxFit fit;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      width: 170,
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            height: 150,
            width: 150,

            decoration: ShapeDecoration(
              shape: const CircleBorder(),
              color: Colors.grey.withAlpha(100),
            ),
            child: CachedNetworkImage(
              imageUrl: imgUrl,
              fit: fit,
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
          Align(
            alignment: Alignment(0.9, 0.8),
            child: CircleAvatar(
              backgroundColor: Colors.orange,
              child: IconButton(
                onPressed: onTap,
                icon: const Icon(CupertinoIcons.camera, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
