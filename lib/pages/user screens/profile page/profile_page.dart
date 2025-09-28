import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/controllers/auth%20riverpod/auth_riverpod.dart';
import 'package:sneak_peak/controllers/fcm_token_riverpod.dart';
import 'package:sneak_peak/controllers/notifications_controllers.dart';
import 'package:sneak_peak/controllers/user_img_riverpod.dart';
import 'package:sneak_peak/controllers/users%20controller/wishlist_riverpod.dart';
import 'package:sneak_peak/models/notifications_model.dart';
import 'package:sneak_peak/pages/admin%20screens/theme%20page/theme_page.dart';
import 'package:sneak_peak/pages/auth%20pages/login%20page/login_page.dart';
import 'package:sneak_peak/pages/user%20screens/cancellation%20page/cancellation_page.dart';
import 'package:sneak_peak/pages/user%20screens/cancellation%20page/this%20controller/cancellation_stream_riverpod.dart';
import 'package:sneak_peak/pages/user%20screens/cart%20page/this%20controllers/cart_stream_provider.dart';
import 'package:sneak_peak/pages/user%20screens/completed%20orders%20page/completed_orders_page.dart';
import 'package:sneak_peak/pages/user%20screens/notifications%20page/controllers/notification_stream.dart';
import 'package:sneak_peak/pages/user%20screens/pending%20order%20page/pending_orders_page.dart';
import 'package:sneak_peak/pages/user%20screens/pending%20order%20page/this_controllers/pending_stream_provider.dart';
import 'package:sneak_peak/pages/user%20screens/profile%20page/controllers/profile_switcher_controller.dart';
import 'package:sneak_peak/pages/user%20screens/profile%20page/widgets/icons_widget.dart';
import 'package:sneak_peak/pages/user%20screens/profile%20page/widgets/list_tile_widget.dart';
import 'package:sneak_peak/pages/user%20screens/profile%20page/widgets/top_profile_bar.dart';
import 'package:sneak_peak/pages/user%20screens/settings%20page/settings_page.dart';
import 'package:sneak_peak/pages/user%20screens/to%20ship%20page/controllers/to_ship_stream_riverpod.dart';
import 'package:sneak_peak/pages/user%20screens/to%20ship%20page/to_ship_page.dart';
import 'package:sneak_peak/pages/user%20screens/wishlist%20page/wishlist_page.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(userImgProvider('user_img').notifier).getUserImg();
      ref
          .read(authProvider('sync_email').notifier)
          .syncEmailAfterVerification();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider('logout_user'), (previous, next) {
      if (next is AuthErrorState) {
        var error = next.error;
        Navigator.pop(context);
        SnackBarHelper.show(error, color: Colors.red);
      }
    });
    ref.listen(userImgProvider('user_img'), (previous, next) {
      if (next is ErrorStateUserImg) {
        var error = next.error;
        SnackBarHelper.show(error, color: Colors.red);
      }
    });
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 5,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Center(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _sliverAppBar(context),
            const TopProfileBar(),
            const SliverToBoxAdapter(child: Divider()),
            SliverPadding(
              padding: EdgeInsets.all(10),
              sliver: SliverToBoxAdapter(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    IconsWidget(
                      onTap:
                          () => GoRouter.of(
                            context,
                          ).pushNamed(PendingOrders.pageName),
                      title: 'Pending',
                      icon: Icons.alarm,
                    ),
                    IconsWidget(
                      onTap:
                          () => GoRouter.of(
                            context,
                          ).pushNamed(CompletedPage.pageName),
                      title: 'Completed',
                      icon: Icons.check_circle,
                    ),
                    IconsWidget(
                      onTap:
                          () => GoRouter.of(
                            context,
                          ).pushNamed(CancellationPage.pageName),
                      title: 'Cancellation',
                      icon: Icons.cancel,
                    ),
                    IconsWidget(
                      onTap:
                          () => GoRouter.of(
                            context,
                          ).pushNamed(ToShipPage.pageName),
                      title: 'To ship',
                      icon: Icons.fire_truck_sharp,
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: Divider()),

            ListTileProfileWidget(
              leadingIcon: Icons.favorite,
              onTap:
                  () => GoRouter.of(context).pushNamed(WishlistPage.pageName),
              title: 'Wishlist',
            ),

            ListTileProfileWidget(
              leadingIcon: Icons.settings,
              onTap:
                  () => GoRouter.of(context).pushNamed(SettingsPage.pageName),
              title: 'Settings',
            ),

            ListTileProfileWidget(
              leadingIcon: Icons.notifications,
              onTap: () {},
              trailingWidget: Consumer(
                builder: (context, v, _) {
                  var value = v.watch(switcherProvider);
                  return Switch(
                    activeColor: Colors.white,
                    activeTrackColor: Colors.grey.withAlpha(100),
                    value: value,
                    onChanged: (value) async {
                      v.read(switcherProvider.notifier).switchTogeled(value);
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
                                    'Now you are not able to receive new updates🥺 (please on kr lu na.)',
                              ),
                            );
                        v.read(fcmTokenProvider.notifier).deleteFcmToken();
                      } else {
                        await v.read(fcmTokenProvider.notifier).addFcmToken();
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
                                    'Now you are able to receive new updates😁 (shukriya bhae love you)',
                              ),
                            );
                      }
                    },
                  );
                },
              ),
              title: 'Notification',
            ),
            ListTileProfileWidget(
              leadingIcon: Icons.light_mode,
              onTap: () => GoRouter.of(context).pushNamed(ThemePage.pageName),
              title: 'Theme',
            ),

            const SliverToBoxAdapter(child: Divider()),
            _signOut(ref, context),
          ],
        ),
      ),
    );
  }
}

Widget _sliverAppBar(BuildContext context) {
  return SliverAppBar(
    title: const Text('Profile'),
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    floating: true,
    snap: true,
    centerTitle: true,
  );
}

Widget _signOut(WidgetRef ref, BuildContext context) {
  return SliverPadding(
    padding: EdgeInsets.symmetric(vertical: 5),
    sliver: SliverToBoxAdapter(
      child: TextButton(
        onPressed: () async {
          loadingDialog(context, 'Logging out....');
          var isLogout =
              await ref.read(authProvider('logout_user').notifier).logout();
          Navigator.pop(context);
          if (isLogout) {
            ref.invalidate(wishlistProvider);
            ref.invalidate(notificationStreamProvider);
            ref.invalidate(cartStreamProvider);
            ref.invalidate(toShipStreamProvider);
            ref.invalidate(cancellationStreamProvider);
            ref.invalidate(pendingStreamProvider);
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
    ),
  );
}
