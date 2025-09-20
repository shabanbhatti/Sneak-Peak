import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/pages/admin%20screens/admin_main.dart';
import 'package:sneak_peak/pages/auth%20pages/login%20page/login_page.dart';
import 'package:sneak_peak/pages/initial%20pages/splash_page.dart';
import 'package:sneak_peak/pages/user%20screens/home%20page/home_page.dart';
import 'package:sneak_peak/pages/user%20screens/user_main.dart';
import 'package:sneak_peak/services/shared%20pref%20service/shared_pref_service.dart';
import 'package:sneak_peak/utils/admin_email.dart';


class DecidePage extends StatefulWidget {
  const DecidePage({super.key});
  static const pageName = 'decide_page';
  @override
  State<DecidePage> createState() => _DecidePageState();
}

class _DecidePageState extends State<DecidePage> {
  @override
  void initState() {
    super.initState();
    
    decideNewPage();
  }

  void decideNewPage() async {
    var splash = await SPHelper.getDecidings(SPHelper.splash);
    var logged= await SPHelper.getDecidings(SPHelper.logged);
   
    if (mounted) {
      if (splash) {
        if (logged && FirebaseAuth.instance.currentUser!=null) {
          if (FirebaseAuth.instance.currentUser!.email==adminEmail   ) {
            GoRouter.of(context).goNamed(AdminMain.pageName);
          }else{
            GoRouter.of(context).goNamed(UserMainPage.pageName);
          }
        }else{
          GoRouter.of(context).goNamed(LoginPage.pageName);
        }
      } else {
        GoRouter.of(context).goNamed(SplashPage.pageName);
      }
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center());
  }
}
