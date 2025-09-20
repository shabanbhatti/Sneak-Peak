import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/controllers/auth%20riverpod/auth_riverpod.dart';
import 'package:sneak_peak/pages/auth%20pages/login%20page/login_page.dart';
import 'package:sneak_peak/utils/validations.dart';
import 'package:sneak_peak/widgets/custom%20btn/custom_button.dart';
import 'package:sneak_peak/widgets/custom%20text%20fields/custom_textfields.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  static const pageName = 'forgot_password';
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> slide;

  TextEditingController emailController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  GlobalKey<FormState> emailKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    slide = Tween<Offset>(begin: Offset(0.0, -0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOutBack),
    );
    // scale= Tween<double>(begin: 0.0, end: 1.0).animate(animationController);
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    emailController.dispose();
    emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,

        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).goNamed(LoginPage.pageName);
          },
          icon: Icon(CupertinoIcons.back, size: 40),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SlideTransition(
            position: slide,
            child: Column(
              children: [
                _topTitle(),
                const SizedBox(height: 30),
                _emailField(emailKey, emailController, emailFocusNode),
                const SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    children: [
                      Text(
                        '* We will send you a link to your email (spam)\n   to reset your new password.',
                        style: TextStyle(color: Colors.orange, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Consumer(
                  builder: (context, ref, child) {
                    var auth= ref.watch(authProvider);
                    return CustomButton(
                  btnTitleWidget:(auth is AuthLoadingState)?const CupertinoActivityIndicator(color: Colors.white,) :Text(
                    'Reset password',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    forgotPass(ref);
                  },
                );
                  },
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }


void forgotPass(WidgetRef authRef){

var emailValidation= emailKey.currentState!.validate();
if (emailValidation) {
  authRef.read(authProvider.notifier).forgetPassword(emailController.text.trim(), context);
}

}

}

Widget _topTitle() {
  return Padding(
    padding: EdgeInsets.only(left: 17),
    child: Row(
      children: [
        Text(
          'Forgot\npassword?',
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
