import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/models/auth_modal.dart';
import 'package:sneak_peak/pages/admin%20screens/admin_main.dart';
import 'package:sneak_peak/pages/auth%20pages/login%20page/login_page.dart';
import 'package:sneak_peak/pages/user%20screens/user_main.dart';
import 'package:sneak_peak/services/auth_service.dart';
import 'package:sneak_peak/services/shared%20pref%20service/shared_pref_service.dart';
import 'package:sneak_peak/utils/admin_email.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';

final authProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier();
});

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier() : super(AuthInitialState());
  AuthService authService = AuthService();

  Future<void> createAccount(
    AuthModal authModal,
    String password,
    BuildContext context,
  ) async {
    loadingDialog(context, 'Creating account.....');
    state = AuthLoadingState();
    try {
      await authService.createAccount(authModal, password);
      GoRouter.of(context).goNamed(LoginPage.pageName);
      state = AuthLoadedSuccessfulyState();
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      state = AuthErrorState();
      Navigator.pop(context);
      SnackBarHelper.show('$e', color: Colors.red);
    }
  }

  Future<void> loginAccount(
    String email,
    String password,
    BuildContext context,
  ) async {
    var auth = FirebaseAuth.instance;
    state = AuthLoadingState();
    loadingDialog(context, 'Signing you in...');
    try {
      var user = await authService.loginAccount(email, password);
      if (user.user!.emailVerified == true) {
        if (user.user!.email == adminEmail) {
          GoRouter.of(context).goNamed(AdminMain.pageName);
          // await afterLoginMeth();
        } else {
          GoRouter.of(context).goNamed(UserMainPage.pageName);
          // await afterLoginMeth();
        }
        SPHelper.setDeciding(SPHelper.logged, true);
      } else {
        await auth.signOut();

        SnackBarHelper.show(
          'Verify your email (Spam folder) before login',
          color: Colors.red,
          duration: const Duration(seconds: 4),
        );
      }

      state = AuthLoadedSuccessfulyState();
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      state = AuthErrorState();
      SnackBarHelper.show(e.code, color: Colors.red);
    }
  }

  Future<void> updateEmail(
    String newEmail,
    String password,
    BuildContext context,
  ) async {
    state = AuthLoadingState();

    try {
      await authService.updateEmail(newEmail, password);
      loadingDialog(
        context,
        'Verification link has sent to $newEmail in the spam folder, please verify!',
      );
      await Future.delayed(const Duration(seconds: 10), () {
        state = AuthInitialState();
        Navigator.pop(context);
      });
    } on FirebaseException catch (e) {
      state = AuthErrorState();
      SnackBarHelper.show(e.code, color: Colors.red);
    }
  }

  Future<void> syncEmailAfterVerification(BuildContext context) async {
    try {
      await authService.syncEmailAfterVerification(context);

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-token-expired') {
        await FirebaseAuth.instance.signOut();
        await SPHelper.setDeciding(SPHelper.logged, false);
  await SPHelper.removeNameEmailImgFromSharedPref(
        SPHelper.userName,
        SPHelper.email,
        SPHelper.userImg,
      );
        GoRouter.of(context).pushReplacementNamed(LoginPage.pageName);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Verified! Login again using your new email."),
          ),
        );
      } else {
        print("FirebaseAuthException: ${e.message}");
      }
    } catch (e) {
      print("General Error: $e");
    }
  }


  Future<void> updateUsername(String newName, BuildContext context)async{
try {
  state= AuthLoadingState();
loadingDialog(context, 'Updating username...');

await authService.updateUsername(newName);
state=AuthInitialState();
Navigator.pop(context);


}on FirebaseException catch (e) {
  state=AuthErrorState();
  Navigator.pop(context);
  SnackBarHelper.show(e.code, color: Colors.red);
}
  }


  Future<void> changePassword(String newPass, String oldPass, BuildContext context )async{
try {
loadingDialog(context, 'Changing to new password...');
  state= AuthLoadingState();
await authService.changePassword(newPass, oldPass);
state= AuthInitialState();
Navigator.pop(context);

}on FirebaseException catch (e) {
  state= AuthErrorState();
  Navigator.pop(context);
  SnackBarHelper.show(e.code, color: Colors.red);
}


  }

  Future<void> logout(BuildContext context) async {
    loadingDialog(context, 'Logging out....');
    try {
      await authService.logout();
      await SPHelper.removeNameEmailImgFromSharedPref(
        SPHelper.userName,
        SPHelper.email,
        SPHelper.userImg,
      );
      Navigator.pop(context);
      GoRouter.of(context).goNamed(LoginPage.pageName);
    } catch (e) {
      Navigator.pop(context);
      SnackBarHelper.show(e.toString(), color: Colors.red);
    }
  }

  Future<void> signInGoogle(BuildContext context) async {
    state = AuthLoadingState();
    loadingDialog(context, 'Signing you in...');
    try {
      var user = await authService.signInWithGoogle();
      if (user == null) {
        state = AuthInitialState();
        Navigator.pop(context);
      } else {
        if (user.user!.email == adminEmail) {
          GoRouter.of(context).goNamed(AdminMain.pageName);
        } else {
          GoRouter.of(context).goNamed(UserMainPage.pageName);
        }
        SPHelper.setDeciding(SPHelper.logged, true);
        state = AuthLoadedSuccessfulyState();
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      state = AuthErrorState();
      SnackBarHelper.show(e.code, color: Colors.red);
    }
  }

  Future<void> forgetPassword(String email, BuildContext context) async {
    state = AuthLoadingState();
    loadingDialog(context, 'Reseting your password....');
    try {
      await authService.forgotPass(email);
      SnackBarHelper.show(
        'Password reset email sent! Check your inbox.',
        duration: const Duration(seconds: 10),
      );
      state = AuthLoadedSuccessfulyState();
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      state = AuthErrorState();
      SnackBarHelper.show('$e', color: Colors.red);
    }
  }
}

sealed class AuthState {
  const AuthState();
}

class AuthInitialState extends AuthState {
  const AuthInitialState();
}

class AuthLoadingState extends AuthState {
  const AuthLoadingState();
}

class AuthLoadedSuccessfulyState extends AuthState {
  const AuthLoadedSuccessfulyState();
}

class AuthErrorState extends AuthState {
  const AuthErrorState();
}
