import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/pages/admin%20screens/home%20page/admin_home.dart';
import 'package:sneak_peak/pages/admin%20screens/orders%20page/controllers/orders_stream_riverpod.dart';
import 'package:sneak_peak/pages/admin%20screens/orders%20page/orders_page.dart';
import 'package:sneak_peak/pages/admin%20screens/profile%20page/admin_profie_page.dart';
import 'package:sneak_peak/pages/admin%20screens/sales%20chart%20page/admin_sales_chart_page.dart';
import 'package:sneak_peak/utils/constant_steps.dart';

class AdminMain extends StatelessWidget {
  const AdminMain({super.key});

  static const pageName = 'admin_main';

  final List<Widget> pages = const [
    AdminHome(),
    AdminSalesChart(),
    AdminOrdersPage(),
    AdminProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    print('ADMIN MAIN BUILD CALLED');
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
                icon: Icon(CupertinoIcons.chart_bar),
                activeIcon: Icon(CupertinoIcons.chart_bar_fill),
                label: null,
              ),
              BottomNavigationBarItem(
                icon: _OrderIconWithBadge(),
                activeIcon: _OrderIconWithBadge(),
                label: null,
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

class _OrderIconWithBadge extends StatelessWidget {
  const _OrderIconWithBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Badge(
      label: Consumer(
        builder: (context, ref, child) {
          var stream = ref.watch(adminOrdersStreamProvider);
          var streamList = stream.value ?? [];
          var list =
              streamList
                  .where((element) => element.deliveryStatus != delivered)
                  .toList();
          return stream.when(
            data: (data) => Text(list.length.toString()),
            loading: () => const Text('0'),
            error: (error, stackTrace) => Text('0'),
          );
        },
      ),
      child: const Icon(CupertinoIcons.doc_plaintext),
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
