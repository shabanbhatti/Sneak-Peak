import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/controllers/auth%20riverpod/auth_riverpod.dart';
import 'package:sneak_peak/utils/validations.dart';
import 'package:sneak_peak/widgets/custom%20btn/custom_button.dart';
import 'package:sneak_peak/widgets/custom%20sliver%20app%20bar/custom_sliverappbar.dart';
import 'package:sneak_peak/widgets/custom%20text%20fields/custom_textfields.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});
  static const pageName = 'change_password';

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPage();
}

class _ChangePasswordPage extends ConsumerState<ChangePasswordPage> {
  
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  
  GlobalKey<FormState> oldPasswordkey = GlobalKey<FormState>();
  GlobalKey<FormState> newPasswordkey = GlobalKey<FormState>();

  @override
  void dispose() {
    newPasswordController.dispose();
    oldPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            CustomSliverAppBar(
              leadingOnTap: () => GoRouter.of(context).pop(),
              leadingIcon: CupertinoIcons.back,
              title: 'Change password',
            ),
          

            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              sliver: Form(
                key: oldPasswordkey,
                child: SliverToBoxAdapter(
                  child: CustomTextfields(
                    controller: oldPasswordController,
                    title: 'Old password',
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
              sliver: Form(
                key: newPasswordkey,
                child: SliverToBoxAdapter(
                  child: CustomTextfields(
                    controller: newPasswordController,
                    title: 'New password',
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
                  '* After hitting the change password btn, your\n   password will be updated.',
                  style: TextStyle(fontSize: 12, color: Colors.orange),
                ),
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              sliver: SliverToBoxAdapter(
                child: Consumer(
                  builder: (context, x, _) {
                    var auth = x.watch(authProvider);
                    return CustomButton(
                      btnTitleWidget:
                          (auth is AuthLoadingState)
                              ? CupertinoActivityIndicator(color: Colors.white)
                              : Text(
                                'Change password',
                                style: TextStyle(color: Colors.white),
                              ),
                      onTap: ()async {
                        
                        var isOldPasswordValidate =
                            oldPasswordkey.currentState!.validate();
                        var isNewPasswordValidate =
                            newPasswordkey.currentState!.validate();
                        if (
                            isOldPasswordValidate &&
                            isNewPasswordValidate) {
                         await ref.read(authProvider.notifier).changePassword(newPasswordController.text.trim(), oldPasswordController.text.trim(), context);
                         newPasswordController.clear();
                         oldPasswordController.clear();
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
