import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sneak_peak/pages/user%20screens/view%20user%20img%20page/view_user_img_page.dart';

class ProfileCircleAvatarWidget extends StatelessWidget {
  const ProfileCircleAvatarWidget({
    super.key,
    required this.imgUrl,
    required this.onTap,
    this.fit = BoxFit.contain,
    required this.onLongPress,
  });
  final String imgUrl;
  final void Function() onTap;
  final void Function() onLongPress;
  final BoxFit? fit;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      onTap: onTap,
      onLongPress: onLongPress,
      child: Hero(
        tag: ViewUserImgPage.pageName,
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
      ),
    );
  }
}
