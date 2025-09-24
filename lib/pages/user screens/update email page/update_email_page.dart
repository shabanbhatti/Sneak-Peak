import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/controllers/auth%20riverpod/auth_riverpod.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';
import 'package:sneak_peak/utils/validations.dart';
import 'package:sneak_peak/widgets/custom%20btn/custom_button.dart';
import 'package:sneak_peak/widgets/custom%20sliver%20app%20bar/custom_sliverappbar.dart';
import 'package:sneak_peak/widgets/custom%20text%20fields/custom_textfields.dart';

class UpdateEmailPage extends ConsumerStatefulWidget {
  const UpdateEmailPage({super.key});
  static const pageName = 'update_email';

  @override
  ConsumerState<UpdateEmailPage> createState() => _UpdateEmailPageState();
}

class _UpdateEmailPageState extends ConsumerState<UpdateEmailPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> emailKey = GlobalKey<FormState>();
  GlobalKey<FormState> passwordkey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider('update_email'),(previous, next) {
      if (next is AuthErrorState) {
        var error= next.error;
        SnackBarHelper.show(error, color: Colors.red);
      }
    },);
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            CustomSliverAppBar(
              leadingOnTap: () => GoRouter.of(context).pop(),
              leadingIcon: CupertinoIcons.back,
              title: 'Update email',
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              sliver: SliverToBoxAdapter(
                child: Form(
                  key: emailKey,
                  child: CustomTextfields(
                    controller: emailController,
                    title: 'Enter new email',
                    focusNode: FocusNode(),
                    isObscure: false,
                    prefix: CupertinoIcons.mail,
                    validator: (p0) => emailValidation(p0),
                  ),
                ),
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              sliver: Form(
                key: passwordkey,
                child: SliverToBoxAdapter(
                  child: CustomTextfields(
                    controller: passwordController,
                    title: 'Enter your password',
                    focusNode: FocusNode(),
                    isObscure: true,
                    prefix: CupertinoIcons.lock,
                    validator: (p0) => passwordValidation(p0),
                  ),
                ),
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              sliver: const SliverToBoxAdapter(
                child: Text(
                  '* We will send you a email verification link\n  in the spam folder to your new email.',
                  style: TextStyle(fontSize: 12, color: Colors.orange),
                ),
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              sliver: SliverToBoxAdapter(
                child: Consumer(
                  builder: (context, x, _) {
                    var auth = x.watch(authProvider('update_email'));
                    return CustomButton(
                      btnTitleWidget:
                          (auth is AuthLoadingState)
                              ? CupertinoActivityIndicator(color: Colors.white)
                              : Text(
                                'Update email',
                                style: TextStyle(color: Colors.white),
                              ),
                      onTap: ()async {
                        var isEmailValidate = emailKey.currentState!.validate();
                        var isPasswordValidate =
                            passwordkey.currentState!.validate();
                        if (isEmailValidate && isPasswordValidate) {
   var isUpdated=await ref.read(authProvider('update_email').notifier).updateEmail(emailController.text.trim(),passwordController.text.trim(),);
if (mounted) {
  if (isUpdated) {
  loadingDialog(context,'Verification link has sent to ${emailController.text} in the spam folder, please verify!',);
   await Future.delayed(const Duration(seconds: 10), () {
        Navigator.pop(context);
      });
}
}
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
