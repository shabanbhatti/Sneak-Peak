import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/controllers/auth%20riverpod/auth_riverpod.dart';
import 'package:sneak_peak/controllers/fcm_token_riverpod.dart';
import 'package:sneak_peak/pages/admin%20screens/admin_main.dart';
import 'package:sneak_peak/pages/auth%20pages/login%20page/login_page.dart';
import 'package:sneak_peak/pages/initial%20pages/splash_page.dart';
import 'package:sneak_peak/pages/user%20screens/user_main.dart';


import 'package:sneak_peak/utils/snack_bar_helper.dart';

class DecidePage extends ConsumerStatefulWidget {
  const DecidePage({super.key});
  static const pageName = 'decide_page';
  @override
  ConsumerState<DecidePage> createState() => _DecidePageState();
}

class _DecidePageState extends ConsumerState<DecidePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      
      decideNewPage();
    },);
  }

  void decideNewPage() async {

    var decide = await ref.read(authProvider('decide').notifier).decide();
    if (mounted) {
      if (decide == 'admin') {
         await ref.read(fcmTokenProvider.notifier).updateFcm();
        GoRouter.of(context).goNamed(AdminMain.pageName);
      } else if (decide == 'login') {
        
        GoRouter.of(context).goNamed(LoginPage.pageName);
      } else if (decide == 'user') {
        await ref.read(fcmTokenProvider.notifier).updateFcm();
        GoRouter.of(context).goNamed(UserMainPage.pageName);
      } else {
        GoRouter.of(context).goNamed(SplashPage.pageName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider('decide'), (previous, next) {
      if (next is AuthErrorState) {
        var e = next.error;
        SnackBarHelper.show(e, color: Colors.red);
      }
    });
    return const Scaffold(body: Center());
  }
}
