import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sneak_peak/controllers/get%20shared%20pref%20data%20riverpod/get_sp_data_riverpod.dart';
import 'package:sneak_peak/controllers/user_img_riverpod.dart';
import 'package:sneak_peak/pages/user%20screens/profile%20page/widgets/profile_circle_avatar_widget.dart';
import 'package:sneak_peak/pages/user%20screens/view%20user%20img%20page/view_user_img_page.dart';
import 'package:sneak_peak/utils/constant_imgs.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/model%20bottom%20sheets/bottom_sheet_for_img.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';

class TopProfileBar extends StatelessWidget {
  const TopProfileBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: Container(
          height: 130,
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.transparent),

          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 7, vertical: 0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Consumer(
                    builder: (context, x, child) {
                      var userimg = x.watch(userImgProvider('user_img'));

                      if (userimg is LoadedSuccessfulyUserImg) {
                        return ProfileCircleAvatarWidget(
                          imgUrl: userimg.imgUrl,
                          fit: BoxFit.cover,
                          onLongPress: () {
                            GoRouter.of(context).pushNamed(
                              ViewUserImgPage.pageName,
                              extra: userimg.imgUrl,
                            );
                          },
                          onTap: () async {
                            print(userimg.imgUrl);
                            showImageOptionsBottomSheet(
                              context,
                              userimg.imgUrl,
                              onViewImage: () {
                                Navigator.pop(context);
                                GoRouter.of(context).pushNamed(
                                  ViewUserImgPage.pageName,
                                  extra: userimg.imgUrl,
                                );
                              },
                              onChangeImage: () async {
                                Navigator.pop(context);
                                loadingDialog(context, 'Uploading image...');
                                var isDone = await x
                                    .read(userImgProvider('user_img').notifier)
                                    .takeImage(ImageSource.gallery);
                                Navigator.pop(context);
                                if (isDone == 'done') {
                                  SnackBarHelper.show(
                                    'Image uploaded successfully',
                                  );
                                }
                              },
                              onDeleteImage: () async {
                                Navigator.pop(context);
                                loadingDialog(context, 'Deleting image...');
                                var isDone =
                                    await x
                                        .read(
                                          userImgProvider('user_img').notifier,
                                        )
                                        .deleteUserImg();
                                Navigator.pop(context);
                                if (isDone) {
                                  x
                                      .read(
                                        userImgProvider('user_img').notifier,
                                      )
                                      .getUserImg();
                                  SnackBarHelper.show(
                                    'Image deleted successfully',
                                  );
                                }
                              },
                            );
                          },
                        );
                      } else {
                        return ProfileCircleAvatarWidget(
                          imgUrl: profileIconUrl,
                          onLongPress: () {},
                          onTap: (){
                             showImageOptionsBottomSheet(
                              context,
                              profileIconUrl,
                              onViewImage: () {
                               
                              },
                              onChangeImage: () async {
                                Navigator.pop(context);
                                loadingDialog(context, 'Uploading image...');
                                var isDone = await x
                                    .read(userImgProvider('user_img').notifier)
                                    .takeImage(ImageSource.gallery);
                                Navigator.pop(context);
                                if (isDone == 'done') {
                                  SnackBarHelper.show(
                                    'Image uploaded successfully',
                                  );
                                }
                              },
                              onDeleteImage: () async {
                              
                              },
                            );
                          },
                          fit: BoxFit.cover,
                        );
                      }
                    },
                  ),
                ),

                Expanded(
                  flex: 6,
                  child: Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 7),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Consumer(
                                builder: (context, x, child) {
                                  var name = x.watch(getSharedPrefDataProvider);
                                  return Text(
                                    name.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 15),
                              child: Consumer(
                                builder: (context, x, child) {
                                  var mail = x.watch(getSharedPrefDataProvider);
                                  return Text(
                                    mail.email,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
