import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/controllers/auth%20riverpod/auth_riverpod.dart';
import 'package:sneak_peak/models/auth_modal.dart';
import 'package:sneak_peak/pages/auth%20pages/login%20page/login_page.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';
import 'package:sneak_peak/utils/validations.dart';
import 'package:sneak_peak/widgets/custom%20btn/custom_button.dart';
import 'package:sneak_peak/widgets/custom%20text%20fields/custom_textfields.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});
  static const pageName = 'signup_page';

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> slide;

  TextEditingController emailController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  GlobalKey<FormState> emailKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();
  GlobalKey<FormState> nameKey = GlobalKey<FormState>();

  TextEditingController confirmPassController = TextEditingController();
  FocusNode confirmPassFocusNode = FocusNode();
  GlobalKey<FormState> confirmPassKey = GlobalKey<FormState>();

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

    slide = Tween<Offset>(begin: Offset(0.0, -0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOutBack),
    );
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    nameController.dispose();
    nameFocusNode.dispose();
    confirmPassController.dispose();
    confirmPassFocusNode.dispose();
    emailController.dispose();
    emailFocusNode.dispose();
    passController.dispose();
    passFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Signup PAGE BUILD CALLED');
    ref.listen(authProvider('create'), (previous, next) {
      if (next is AuthErrorState) {
        var error = next.error;

        SnackBarHelper.show(error, color: Colors.red);
      } else if (next is AuthLoadedSuccessfulyState) {
        SnackBarHelper.show(
          'Verification link has to your email in the spam folder. Please verify!',
          duration: const Duration(seconds: 30),
        );
      }
    });
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).goNamed(LoginPage.pageName);
          },
          icon: const Icon(CupertinoIcons.back, size: 40),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: SlideTransition(
              position: slide,
              child: Column(
                children: [
                  _topTitle(),
                  const SizedBox(height: 30),
                  _nameField(nameKey, nameController, nameFocusNode),
                  const SizedBox(height: 30),
                  _emailField(emailKey, emailController, emailFocusNode),
                  const SizedBox(height: 30),
                  _passwordTextField(passKey, passController, passFocusNode),
                  const SizedBox(height: 30),
                  _confirmPasswordTextField(
                    confirmPassKey,
                    confirmPassController,
                    confirmPassFocusNode,
                    passController,
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      children: [
                        Text(
                          '* By clicking the register button, you agree\n   to public offer.',
                          style: TextStyle(color: Colors.orange, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Consumer(
                    builder: (context, authREF, child) {
                      var auth = authREF.watch(authProvider('create'));
                      return CustomButton(
                        btnTitleWidget:
                            (auth is AuthLoadingState)
                                ? const CupertinoActivityIndicator(
                                  color: Colors.white,
                                )
                                : const Text(
                                  'Register',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        onTap: () => onRegister(authREF),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onRegister(WidgetRef authREF) async {
    var nameValidation = nameKey.currentState!.validate();
    var emailValidation = emailKey.currentState!.validate();
    var passValidation = passKey.currentState!.validate();
    var confirmPassValidation = confirmPassKey.currentState!.validate();
    if (nameValidation &&
        emailValidation &&
        passValidation &&
        confirmPassValidation) {
      loadingDialog(context, 'Creating account...');
      var isCreated = await authREF
          .read(authProvider('create').notifier)
          .createAccount(
            AuthModal(
              name: nameController.text.trim(),
              email: emailController.text.trim(),
              createdAtDate: DateTime.now().toString(),
              fcmToken: ''
            ),
            passController.text.trim(),
          );
      if (mounted) {
        Navigator.pop(context);
        if (isCreated) {
          GoRouter.of(context).goNamed(LoginPage.pageName);
        }
      }
    }
  }
}

Widget _topTitle() {
  return Padding(
    padding: EdgeInsets.only(left: 17),
    child:const Row(
      children: [
        Text(
          'Create an\naccount!',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

Widget _nameField(
  GlobalKey<FormState> nameKey,
  TextEditingController nameController,
  FocusNode nameFocusNode,
) {
  return Form(
    key: nameKey,
    child: CustomTextfields(
      controller: nameController,
      title: 'Name',
      prefix: CupertinoIcons.person_fill,
      focusNode: nameFocusNode,
      isObscure: false,
      validator: (p0) {
        return nameValidation(p0);
      },
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
      title: 'Create Password',
      validator: (p0) {
        return passwordValidation(p0);
      },
      prefix: CupertinoIcons.lock_fill,
      focusNode: passFocusNode,
      isObscure: true,
    ),
  );
}

Widget _confirmPasswordTextField(
  GlobalKey<FormState> confirmPassKey,
  TextEditingController confirmPassController,
  FocusNode confirmFocusNode,
  TextEditingController passController,
) {
  return Form(
    key: confirmPassKey,

    child: CustomTextfields(
      controller: confirmPassController,
      title: 'Confirm password',
      validator: (value) {
        if (value!.isEmpty) {
          return "Confirm password shouldn't be empty";
        } else if (value != passController.text) {
          return "Both password should be the same";
        }
        return null;
      },
      prefix: CupertinoIcons.lock_fill,
      focusNode: confirmFocusNode,
      isObscure: true,
    ),
  );
}
