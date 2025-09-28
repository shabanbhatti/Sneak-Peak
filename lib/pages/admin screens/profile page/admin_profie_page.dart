import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sneak_peak/controllers/auth%20riverpod/auth_riverpod.dart';
import 'package:sneak_peak/controllers/fcm_token_riverpod.dart';
import 'package:sneak_peak/controllers/get%20shared%20pref%20data%20riverpod/get_sp_data_riverpod.dart';
import 'package:sneak_peak/controllers/notifications_controllers.dart';
import 'package:sneak_peak/controllers/user_img_riverpod.dart';
import 'package:sneak_peak/models/notifications_model.dart';
import 'package:sneak_peak/pages/admin%20screens/completed%20orders%20page/admin_completed_orders_page.dart';
import 'package:sneak_peak/pages/admin%20screens/edit%20name%20page/admin_edit_name_page.dart';
import 'package:sneak_peak/pages/admin%20screens/theme%20page/theme_page.dart';
import 'package:sneak_peak/pages/auth%20pages/login%20page/login_page.dart';
import 'package:sneak_peak/pages/user%20screens/notifications%20page/controllers/notification_stream.dart';
import 'package:sneak_peak/pages/user%20screens/notifications%20page/notifications_page.dart';
import 'package:sneak_peak/pages/user%20screens/profile%20page/controllers/profile_switcher_controller.dart';
import 'package:sneak_peak/utils/constant_imgs.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';
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
      ref.invalidate(notificationStreamProvider);
      ref.read(userImgProvider('admin_img').notifier).getUserImg();
      ref.read(getSharedPrefDataProvider.notifier).getNameEmailDataFromSP();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider('logout'), (previous, next) {
      if (next is AuthErrorState) {
        var error = next.error;
        Navigator.pop(context);
        SnackBarHelper.show(error, color: Colors.red);
      }
    });
    ref.listen(userImgProvider('admin_img'), (previous, next) {
      if (next is ErrorStateUserImg) {
        var error = next.error;
        SnackBarHelper.show(error, color: Colors.red);
      }
    });
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

                ListTile(
                  onTap: () {
                    GoRouter.of(context).pushNamed(NotificationsPage.pageName);
                  },
                  leading: Consumer(
                    builder: (context, x, _) {
                      var notifications =
                          x.watch(notificationStreamProvider).value ?? [];
                      return Badge(
                        label: Text('${notifications.length}'),
                        child: CircleAvatar(
                          backgroundColor: Colors.orange,
                          child: Icon(Icons.notifications, color: Colors.white),
                        ),
                      );
                    },
                  ),
                  title: Text(
                    'See notifications',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                ),
                ListTileWidget(
                  leadingIcon: Icons.check_circle,
                  title: 'Completed orders',
                  onTap:
                      () => GoRouter.of(
                        context,
                      ).pushNamed(AdminCompletedOrdersPage.pageName),
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
                  onTap:
                      () => GoRouter.of(context).pushNamed(ThemePage.pageName),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.notifications, color: Colors.white),
                  ),
                  onTap: () {},
                  trailing: Consumer(
                    builder: (context, v, _) {
                      var value = v.watch(switcherProvider);
                      return Switch(
                        activeColor: Colors.white,
                        activeTrackColor: Colors.grey.withAlpha(100),
                        value: value,
                        onChanged: (value) async {
                          v
                              .read(switcherProvider.notifier)
                              .switchTogeled(value);
                          String date = DateTime.now().toString();
                          if (value == false) {
                            await v
                                .read(notificationProvider.notifier)
                                .userSendNotification(
                                  NotificationsModel(
                                    title: 'Notification disabled 🔕',
                                    body:
                                        'You have disabled all the notifications 🥺',
                                    metaDataTitle: 'Notification disabled 🔕',
                                    isRead: false,
                                    date: date,
                                    metaDataBody:
                                        'Now you are not able to receive new orders updates🥺',
                                  ),
                                );
                            v.read(fcmTokenProvider.notifier).deleteFcmToken();
                          } else {
                            await v
                                .read(fcmTokenProvider.notifier)
                                .addFcmToken();
                            await v
                                .read(notificationProvider.notifier)
                                .userSendNotification(
                                  NotificationsModel(
                                    title: 'Notification enabled 🔔',
                                    body:
                                        'You have enabled all the notifications 😁',
                                    metaDataTitle: 'Notification enabled 🔔',
                                    isRead: false,
                                    date: date,
                                    metaDataBody:
                                        'Now you are able to receive new orders updates😁',
                                  ),
                                );
                          }
                        },
                      );
                    },
                  ),
                  title: const Text(
                    'Notification',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                TextButton(
                  onPressed: () async {
                    loadingDialog(context, 'Logging out....');
                    var isLogOut =
                        await ref
                            .read(authProvider('logout').notifier)
                            .logout();
                    Navigator.pop(context);
                    if (isLogOut) {
                      GoRouter.of(context).goNamed(LoginPage.pageName);
                    }
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
        var userImg = userImgRef.watch(userImgProvider('admin_img'));
        if (userImg is LoadedSuccessfulyUserImg) {
          return CircleAvatarWidget(
            imgUrl: userImg.imgUrl,
            onTap: () async {
              loadingDialog(context, 'Uploading image...');
              var isDone = await ref
                  .read(userImgProvider('admin_img').notifier)
                  .takeImage(ImageSource.gallery);
              Navigator.pop(context);
              if (isDone == 'done') {
                SnackBarHelper.show('Image uploaded successfully');
              }
            },
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
            onTap: () async {
              loadingDialog(context, 'Uploading image...');
              var isDone = await ref
                  .read(userImgProvider('admin_img').notifier)
                  .takeImage(ImageSource.gallery);
              Navigator.pop(context);
              if (isDone == 'done') {
                SnackBarHelper.show('Image uploaded successfully');
              }
            },
          );
        }
      },
    );
  }
}
