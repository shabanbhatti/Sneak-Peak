import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/controllers/auth%20riverpod/auth_riverpod.dart';
import 'package:sneak_peak/controllers/user%20img%20riverpod/user_img_riverpod.dart';
import 'package:sneak_peak/pages/admin%20screens/theme%20page/admin_theme_page.dart';
import 'package:sneak_peak/pages/user%20screens/cancellation%20page/cancellation_page.dart';
import 'package:sneak_peak/pages/user%20screens/completed%20orders%20page/completed_orders_page.dart';
import 'package:sneak_peak/pages/user%20screens/pending%20order%20page/pending_orders_page.dart';
import 'package:sneak_peak/pages/user%20screens/profile%20page/widgets/icons_widget.dart';
import 'package:sneak_peak/pages/user%20screens/profile%20page/widgets/list_tile_widget.dart';
import 'package:sneak_peak/pages/user%20screens/profile%20page/widgets/top_profile_bar.dart';
import 'package:sneak_peak/pages/user%20screens/settings%20page/settings_page.dart';
import 'package:sneak_peak/pages/user%20screens/to%20ship%20page/to_ship_page.dart';
import 'package:sneak_peak/pages/user%20screens/wishlist%20page/wishlist_page.dart';

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
      ref.read(userImgProvider.notifier).getUserImg(context);
      ref.read(authProvider.notifier).syncEmailAfterVerification(context);
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              leadingIcon: Icons.favorite,
              onTap: () => '',
              trailingWidget: Switch(
                activeColor: Colors.white,
                activeTrackColor: Colors.grey.withAlpha(150),
                value: false,
                onChanged: (value) => '',
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
        onPressed: () {
          ref.read(authProvider.notifier).logout(context);
        },
        child: Text(
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
