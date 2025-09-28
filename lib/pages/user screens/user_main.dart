import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/controllers/get%20shared%20pref%20data%20riverpod/get_sp_data_riverpod.dart';
import 'package:sneak_peak/controllers/location_riverpod.dart';
import 'package:sneak_peak/controllers/notifications_controllers.dart';
import 'package:sneak_peak/pages/user%20screens/cart%20page/cart_page.dart';
import 'package:sneak_peak/pages/user%20screens/cart%20page/this%20controllers/cart_stream_provider.dart';
import 'package:sneak_peak/pages/user%20screens/home%20page/home_page.dart';
import 'package:sneak_peak/pages/user%20screens/notifications%20page/notifications_page.dart';
import 'package:sneak_peak/pages/user%20screens/profile%20page/controllers/profile_switcher_controller.dart';
import 'package:sneak_peak/pages/user%20screens/profile%20page/profile_page.dart';
import 'package:sneak_peak/pages/user%20screens/search%20page/search_page.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';


class UserMainPage extends ConsumerStatefulWidget {
  const UserMainPage({super.key});

  static const pageName = 'user_main';

  @override
  ConsumerState<UserMainPage> createState() => _UserMainPageState();
}

class _UserMainPageState extends ConsumerState<UserMainPage> {

@override
void initState() {
  super.initState();
ref.read(getSharedPrefDataProvider.notifier).getNameEmailDataFromSP();
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    ref.read(locationProvider.notifier).getLocation();
    ref.read(switcherProvider.notifier).getSwitcher();
    ref.read(notificationProvider.notifier).notificationPermission();
    ref.read(notificationProvider.notifier).getFcmToken();
    ref.read(notificationProvider.notifier).onForegroundNotification((message) {
      log('ON FOREGROUND');
     
      GoRouter.of(context).pushNamed(NotificationsPage.pageName);
    },);
    ref.read(notificationProvider.notifier).onBackgroundNotification((p0) {
      log('ON BACKGROND');
      GoRouter.of(context).pushNamed(NotificationsPage.pageName);
    },);
    ref.read(notificationProvider.notifier).onKilledAppNotification((p0) {
      log('ON KILLED');
      GoRouter.of(context).pushNamed(NotificationsPage.pageName);
    },);
       
    },);
}



  final List<Widget> pages = const [
    HomePage(),
    SearchPage(),
    CartPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    print('ADMIN MAIN BUILD CALLED');
    ref.listen(notificationProvider, (previous, next) {
      if (next is ErrorNotification) {
        var error= next.error;
        SnackBarHelper.show(error, color: Colors.red);
      }
    },);
    return Scaffold(
      bottomNavigationBar: Consumer(
        builder: (context, ref, child) {
          return CupertinoTabBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            currentIndex: ref.watch(naviProvider),
            onTap: (index) {
              ref.read(naviProvider.notifier).naviPage(index);
            },
            border: const Border(top: BorderSide.none),
            inactiveColor: Colors.grey,
            activeColor: Colors.orange,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.home),
                activeIcon: Icon(CupertinoIcons.house_fill),
                label: null,
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.search),
                activeIcon: Icon(CupertinoIcons.search),
                label: null,
              ),
              BottomNavigationBarItem(
                icon: ShoppingCartIcon(),
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person),
                activeIcon: Icon(CupertinoIcons.person_fill),
                label: null,
              ),
            ],
          );
        },
      ),
      body: Consumer(
        builder: (context, naviRef, child) {
          var navi = naviRef.watch(naviProvider);
          return Center(child: pages[navi]);
        },
      ),
    );
  }
}

final naviProvider = StateNotifierProvider<NaviStateNotifier, int>((ref) {
  return NaviStateNotifier();
});

class NaviStateNotifier extends StateNotifier<int> {
  NaviStateNotifier() : super(0);

  Future<void> naviPage(int index) async {
    state = index;
  }
}

class ShoppingCartIcon extends ConsumerWidget {
  const ShoppingCartIcon({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Badge(
      label: Consumer(
        builder: (context, ref, child) {
              var streamList = ref.watch(cartStreamProvider);

          return streamList.when(
            data: (list) => Text(list.length.toString()),
            loading: () => const Text('0'),
            error: (error, stackTrace) => Text('0'),
          );
        },
      ),
      child:const Icon(Icons.shopping_bag_rounded),
    );
  }
}
