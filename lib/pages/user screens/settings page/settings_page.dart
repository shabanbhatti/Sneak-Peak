import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/controllers/auth%20riverpod/auth_riverpod.dart';
import 'package:sneak_peak/pages/auth%20pages/login%20page/login_page.dart';
import 'package:sneak_peak/pages/user%20screens/change%20password%20page/change_password_page.dart';
import 'package:sneak_peak/pages/user%20screens/settings%20page/widgets/settings_address_widget.dart';
import 'package:sneak_peak/pages/user%20screens/settings%20page/widgets/settings_listtile_widget.dart';
import 'package:sneak_peak/pages/user%20screens/update%20email%20page/update_email_page.dart';
import 'package:sneak_peak/pages/user%20screens/update%20username%20page/update_username_page.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/dialog%20boxes/password_dialog.dart';
import 'package:sneak_peak/utils/dialog%20boxes/remove_dialog_.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';
import 'package:sneak_peak/widgets/custom%20sliver%20app%20bar/custom_sliverappbar.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});
  static const pageName = 'setting_page';

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  TextEditingController passwordController = TextEditingController();
  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('setting page build called');
    ref.listen(authProvider('delete_account'), (previous, next) {
      if (next is AuthErrorState) {
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
            _appbar(context),
            const SettingsAddressWidget(),

            SettingsListtileWidget(
              leadingIcon: Icons.email,
              onTap:
                  () =>
                      GoRouter.of(context).pushNamed(UpdateEmailPage.pageName),
              title: 'Update email',
            ),
            SettingsListtileWidget(
              leadingIcon: Icons.person,
              onTap:
                  () => GoRouter.of(
                    context,
                  ).pushNamed(UpdateUsernamePage.pageName),
              title: 'Update username',
            ),
            SettingsListtileWidget(
              leadingIcon: Icons.lock,
              onTap:
                  () => GoRouter.of(
                    context,
                  ).pushNamed(ChangePasswordPage.pageName),
              title: 'Change password',
            ),
            SettingsListtileWidget(
              leadingIcon: Icons.delete,
              onTap: () {
                deleteDialog(
                  context,
                  onDel: () async {
                    Navigator.pop(context);
                    showPasswordDialog(context, passwordController, () async {
                      print(passwordController.text);
                      loadingDialog(context, 'Deleting account...');
                      var isDeleted = await ref
                          .read(authProvider('delete_account').notifier)
                          .deleteAccount(passwordController.text.trim());
                      Navigator.pop(context);
                      if (isDeleted) {
                        SnackBarHelper.show('Account deleted successfully');
                        GoRouter.of(context).goNamed(LoginPage.pageName);
                      }
                    });
                  },
                  title: 'Delete account.',
                  descripton: 'Are you sure you wanna delete your account.',
                  btnTitle: 'Delete anyways',
                );
              },
              title: 'Delete account',
            ),
            SettingsListtileWidget(
              leadingIcon: Icons.clear,
              onTap: () => '',
              title: 'Clear cache',
            ),
          ],
        ),
      ),
    );
  }
}

Widget _appbar(BuildContext context) {
  return CustomSliverAppBar(
    leadingOnTap: () => GoRouter.of(context).pop(),
    leadingIcon: CupertinoIcons.back,
    title: 'Settings',
  );
}
