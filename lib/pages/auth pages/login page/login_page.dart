import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/controllers/auth%20riverpod/auth_riverpod.dart';
import 'package:sneak_peak/pages/admin%20screens/admin_main.dart';
import 'package:sneak_peak/pages/auth%20pages/forgot%20pass%20page/forgot_pass_page.dart';
import 'package:sneak_peak/pages/auth%20pages/login%20page/widgets/login_google_signin_widget.dart';
import 'package:sneak_peak/pages/auth%20pages/signup%20page/signup_page.dart';
import 'package:sneak_peak/pages/user%20screens/user_main.dart';
import 'package:sneak_peak/utils/constants_colors.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';
import 'package:sneak_peak/utils/validations.dart';
import 'package:sneak_peak/widgets/custom%20btn/custom_button.dart';
import 'package:sneak_peak/widgets/custom%20text%20fields/custom_textfields.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});
  static const pageName = 'login_page';

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> slide;

  TextEditingController emailController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  GlobalKey<FormState> emailKey = GlobalKey<FormState>();

  TextEditingController passController = TextEditingController();
  FocusNode passFocusNode = FocusNode();
  GlobalKey<FormState> passKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    slide = Tween<Offset>(
      begin: const Offset(0.0, -0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOutBack),
    );
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    emailController.dispose();
    emailFocusNode.dispose();
    passController.dispose();
    passFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Login BUILD CALLED');
    ref.listen(authProvider('login'), (previous, next) {
      if (next is AuthErrorState) {
        var error = next.error;

        SnackBarHelper.show(error, color: Colors.red);
      }
    });
    ref.listen(authProvider('google'), (previous, next) {
      if (next is AuthErrorState) {
        var error = next.error;
        SnackBarHelper.show(error, color: Colors.red);
      }
    });
    return Scaffold(
      appBar: AppBar(toolbarHeight: 10, backgroundColor: Theme.of(context).scaffoldBackgroundColor,),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: SlideTransition(
              position: slide,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _topTitle(),
                  const SizedBox(height: 30),
                  _emailField(emailKey, emailController, emailFocusNode),
                  const SizedBox(height: 30),
                  _passwordTextField(passKey, passController, passFocusNode),
                  _forgotPasswordButton(context),
                  const SizedBox(height: 10),
                  Consumer(
                    builder: (context, authRef, child) {
                      var loginAuth = authRef.watch(authProvider('login'));
                      var googleAuth = authRef.watch(authProvider('google'));
                      return CustomButton(
                        btnTitleWidget:
                            (loginAuth is AuthLoadingState ||
                                    googleAuth is AuthLoadingState)
                                ? const CupertinoActivityIndicator(
                                  color: Colors.white,
                                )
                                : const Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        onTap: () {
                          _onLogin(authRef);
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 65),
                  Text(
                    '-- Or continue with --',
                    style: TextStyle(color: appGreyColor),
                  ),
                  const SizedBox(height: 20),

                  const LoginGoogleSigninWidget(),
                  const SizedBox(height: 10),
                  _signUpByPage(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onLogin(WidgetRef authRef) async {
    var emailValidation = emailKey.currentState!.validate();
    var passwordValidation = passKey.currentState!.validate();

    if (emailValidation && passwordValidation) {
      loadingDialog(context, 'Signing you in...');
      var isLogin = await authRef
          .read(authProvider('login').notifier)
          .loginAccount(
            emailController.text.trim(),
            passController.text.trim(),
          );
      if (mounted) {
        Navigator.pop(context);
        if (isLogin == 'admin') {
          GoRouter.of(context).goNamed(AdminMain.pageName);
        } else if (isLogin == 'user') {
          GoRouter.of(context).goNamed(UserMainPage.pageName);
        } else {
          // SnackBarHelper.show(
          //   'Something went wrong! please check, is your email verified?.',
          //   color: Colors.red,
          //   duration:const Duration(seconds: 10)
          // );
        }
      }
    }
  }
}

Widget _topTitle() {
  return Padding(
    padding: EdgeInsets.all(17),
    child: const Row(
      children: [
        Text(
          'Login\naccount!',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

Widget _emailField(
  GlobalKey<FormState> emailKey,
  TextEditingController emailController,
  FocusNode emailFocusNode,
) {
  return Form(
    key: emailKey,
    child: CustomTextfields(
      controller: emailController,
      title: 'Email',
      prefix: CupertinoIcons.mail_solid,
      focusNode: emailFocusNode,
      isObscure: false,
      validator: (p0) {
        return emailValidation(p0);
      },
    ),
  );
}

Widget _passwordTextField(
  GlobalKey<FormState> passKey,
  TextEditingController passController,
  FocusNode passFocusNode,
) {
  return Form(
    key: passKey,

    child: CustomTextfields(
      controller: passController,
      title: 'Password',
      validator: (p0) {
        return passwordValidation(p0);
      },
      prefix: CupertinoIcons.lock_fill,
      focusNode: passFocusNode,
      isObscure: true,
    ),
  );
}

Widget _forgotPasswordButton(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Padding(
        padding: EdgeInsets.only(right: 5),
        child: TextButton(
          onPressed: () {
            GoRouter.of(context).goNamed(ForgotPasswordPage.pageName);
          },
          child: Text(
            'Forgot password?',
            style: TextStyle(color: Colors.orange),
          ),
        ),
      ),
    ],
  );
}

Widget _signUpByPage(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text('Create an account', style: TextStyle(color: appGreyColor)),
      TextButton(
        onPressed: () {
          GoRouter.of(context).goNamed(SignupPage.pageName);
        },
        child: const Text(
          'Signup',
          style: TextStyle(
            decoration: TextDecoration.underline,
            color: Colors.orange,
            fontSize: 17,
            fontWeight: FontWeight.bold,
            decorationColor: Colors.orange,
            decorationThickness: 2,
          ),
        ),
      ),
    ],
  );
}
