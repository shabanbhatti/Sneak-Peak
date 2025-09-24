import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/controllers/auth%20riverpod/auth_riverpod.dart';
import 'package:sneak_peak/pages/admin%20screens/admin_main.dart';
import 'package:sneak_peak/pages/user%20screens/user_main.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';

class LoginGoogleSigninWidget extends StatelessWidget {
  const LoginGoogleSigninWidget({super.key});

  @override
  Widget build(BuildContext contextx) {
    
    return Consumer(
      builder: (context, authRef, _) {
        
        return GestureDetector(
            onTap: () async{
              loadingDialog(context, 'Signing you in...');
            var signIn= await authRef.read(authProvider('google').notifier).signInGoogle();
            Navigator.pop(contextx);
            if (signIn=='admin') {
              GoRouter.of(contextx).goNamed(AdminMain.pageName);
            }else if(signIn=='user'){
              GoRouter.of(contextx).goNamed(UserMainPage.pageName);
            }},
            child: Container(
              height: 50,
              width: 50,
              decoration: const ShapeDecoration(
                shape: CircleBorder(side: BorderSide(color: Colors.orange, width: 2)),
                image: DecorationImage(image: AssetImage('assets/images/go_ogle.png')),
              ),
            ),
          );
      }
    );
  }
}