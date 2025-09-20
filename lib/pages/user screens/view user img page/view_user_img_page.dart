import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sneak_peak/pages/user%20screens/user_main.dart';

class ViewUserImgPage extends StatelessWidget {
  const ViewUserImgPage({super.key, required this.imgUrl});
  static const pageName = 'view_img';
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    print('img view build called');
    return Scaffold(
      body: InkWell(
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        onTap: () {
          GoRouter.of(context).goNamed(UserMainPage.pageName);
        },
        child: Container(
          color: Colors.transparent,
          child: Center(child: _circleAvatarWidget(imgUrl, () {}, context)),
        ),
      ),
    );
  }
}

Widget _circleAvatarWidget(
  String imgUrl,
  void Function()? onTap,
  BuildContext context,
) {
  return InkWell(
    overlayColor: WidgetStatePropertyAll(Colors.transparent),
    onTap: onTap,
    child: Hero(
      tag: ViewUserImgPage.pageName,
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.height * 0.3,
      
        decoration: ShapeDecoration(shape:const CircleBorder(),),
        child: CachedNetworkImage(imageUrl: imgUrl, fit: BoxFit.cover,progressIndicatorBuilder:
                  (context, url, progress) => Skeletonizer(
                    enabled: true,
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.grey,
                    ),
                  ),),
      ),
    ),
  );
}
