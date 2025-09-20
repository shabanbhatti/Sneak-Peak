import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sneak_peak/controllers/auth%20riverpod/auth_riverpod.dart';
import 'package:sneak_peak/controllers/get%20shared%20pref%20data%20riverpod/get_sp_data_riverpod.dart';
import 'package:sneak_peak/controllers/user%20img%20riverpod/user_img_riverpod.dart';
import 'package:sneak_peak/pages/admin%20screens/completed%20orders%20page/admin_completed_orders_page.dart';
import 'package:sneak_peak/pages/admin%20screens/edit%20name%20page/admin_edit_name_page.dart';
import 'package:sneak_peak/pages/admin%20screens/theme%20page/admin_theme_page.dart';
import 'package:sneak_peak/utils/constant_imgs.dart';
import 'package:sneak_peak/widgets/admin%20app%20bar/admin_app_bar.dart';
import 'package:sneak_peak/widgets/circle%20avatar%20widget/circle_avatar_widget.dart';
import 'package:sneak_peak/widgets/list%20tile%20widget/list_tile_widget.dart';

class AdminProfilePage extends ConsumerStatefulWidget {
  const AdminProfilePage({super.key});

  @override
  ConsumerState<AdminProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<AdminProfilePage> {
  @override
  void initState() {
    super.initState();
    print('INIT CALLED');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(userImgProvider.notifier).getUserImg(context);
      ref.read(getSharedPrefDataProvider.notifier).getNameEmailDataFromSP();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: adminAppBar('Profile'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: SafeArea(
            minimum: EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                _profilePic(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Consumer(
                  builder: (context, spRef, child) {
                    var name = spRef.watch(getSharedPrefDataProvider);
                    return Text(
                      name.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    );
                  },
                ),
                // SizedBox(height: MediaQuery.of(context).size.height * 0.0),
                Consumer(
                  builder: (context, spRef, child) {
                    var email = spRef.watch(getSharedPrefDataProvider);
                    return Text(
                      email.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey),
                    );
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                ListTileWidget(
                  leadingIcon: Icons.check_circle,
                  title: 'Completed orders',
                  onTap: () => GoRouter.of(context).pushNamed(AdminCompletedOrdersPage.pageName),
                ),
                Consumer(
                  builder: (context, spRef, child) {
                    var name = spRef.watch(getSharedPrefDataProvider);
                    return ListTileWidget(
                      leadingIcon: Icons.person,
                      title: 'Change username',
                      onTap: () {
                        GoRouter.of(context).pushNamed(
                          AdminEditNamePage.pageName,
                          pathParameters: {'username': name.name},
                        );
                      },
                    );
                  },
                ),
                ListTileWidget(
                  leadingIcon: Icons.dark_mode,
                  title: 'Theme',
                  onTap: () => GoRouter.of(context).pushNamed(ThemePage.pageName),
                ),

                ListTileWidget(
                  leadingIcon: Icons.notifications,
                  title: 'Notifications',
                  onTap: () => '',
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                TextButton(
                  onPressed: () {
                    ref.read(authProvider.notifier).logout(context);
                  },
                  child: const Text(
                    'Sign out',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.orange,
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

  Widget _profilePic() {
    return Consumer(
      builder: (context, userImgRef, child) {
        var userImg = userImgRef.watch(userImgProvider);
        if (userImg is LoadedSuccessfulyUserImg) {
          return CircleAvatarWidget(
            imgUrl: userImg.imgUrl,
            onTap:
                () => ref
                    .read(userImgProvider.notifier)
                    .takeImage(ImageSource.gallery, context),
          );
        } else if (userImg is LoadingUserImg) {
          return CircleAvatarWidget(
            imgUrl: loadingGifUrl,
            fit: BoxFit.cover,
            onTap: () {},
          );
        } else {
          return CircleAvatarWidget(
            imgUrl: profileIconUrl,
            onTap:
                () => ref
                    .read(userImgProvider.notifier)
                    .takeImage(ImageSource.gallery, context),
          );
        }
      },
    );
  }
}
