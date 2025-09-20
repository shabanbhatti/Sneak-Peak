import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/pages/user%20screens/change%20password%20page/change_password_page.dart';
import 'package:sneak_peak/pages/user%20screens/settings%20page/widgets/settings_address_widget.dart';
import 'package:sneak_peak/pages/user%20screens/settings%20page/widgets/settings_listtile_widget.dart';
import 'package:sneak_peak/pages/user%20screens/update%20email%20page/update_email_page.dart';
import 'package:sneak_peak/pages/user%20screens/update%20username%20page/update_username_page.dart';
import 'package:sneak_peak/widgets/custom%20sliver%20app%20bar/custom_sliverappbar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  static const pageName = 'setting_page';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _appbar(context),
            const SettingsAddressWidget(),

            SettingsListtileWidget(
              leadingIcon: Icons.email,
              onTap: () => GoRouter.of(context).pushNamed(UpdateEmailPage.pageName),
              title: 'Update email',
            ),
            SettingsListtileWidget(
              leadingIcon: Icons.person,
              onTap: () => GoRouter.of(context).pushNamed(UpdateUsernamePage.pageName),
              title: 'Update username',
            ),
            SettingsListtileWidget(
              leadingIcon: Icons.lock,
              onTap: () => GoRouter.of(context).pushNamed(ChangePasswordPage.pageName),
              title: 'Change password',
            ),
            SettingsListtileWidget(
              leadingIcon: Icons.delete,
              onTap: () => '',
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
