import 'dart:developer';

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
    ref.listen(authProvider('change_password'), (previous, next) {
      if (next is AuthLoadedSuccessfulyState) {
        SnackBarHelper.show('Password update successfully');
      } else if (next is AuthErrorState) {
        var error = next.error;
        SnackBarHelper.show(error, color: Colors.red);
      }
    });
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 5,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
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
              sliver: SliverToBoxAdapter(
                child: Form(
                  key: oldPasswordkey,
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
              sliver: SliverToBoxAdapter(
                child: Form(
                  key: newPasswordkey,
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
                    var auth = x.watch(authProvider('change_password'));
                    return CustomButton(
                      btnTitleWidget:
                          (auth is AuthLoadingState)
                              ? CupertinoActivityIndicator(color: Colors.white)
                              : Text(
                                'Change password',
                                style: TextStyle(color: Colors.white),
                              ),
                      onTap: () async {
                        var isOldPasswordValidate =
                            oldPasswordkey.currentState!.validate();
                        var isNewPasswordValidate =
                            newPasswordkey.currentState!.validate();
                        if (isOldPasswordValidate && isNewPasswordValidate) {
                          log('Starting...');
                          loadingDialog(context, 'Changing to new password...');
                          var isChanged = await ref
                              .read(authProvider('change_password').notifier)
                              .changePassword(
                                newPasswordController.text.trim(),
                                oldPasswordController.text.trim(),
                              );
                          log('Ending...');
                          Navigator.pop(context);
                          if (isChanged) {
                            newPasswordController.clear();
                            oldPasswordController.clear();
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
