import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/controllers/auth%20riverpod/auth_riverpod.dart';
import 'package:sneak_peak/controllers/get%20shared%20pref%20data%20riverpod/get_sp_data_riverpod.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';
import 'package:sneak_peak/utils/validations.dart';
import 'package:sneak_peak/widgets/custom%20btn/custom_button.dart';
import 'package:sneak_peak/widgets/custom%20sliver%20app%20bar/custom_sliverappbar.dart';
import 'package:sneak_peak/widgets/custom%20text%20fields/custom_textfields.dart';

class UpdateUsernamePage extends ConsumerStatefulWidget {
  const UpdateUsernamePage({super.key});
  static const pageName = 'update_username';

  @override
  ConsumerState<UpdateUsernamePage> createState() => _UpdateUsernamePageState();
}

class _UpdateUsernamePageState extends ConsumerState<UpdateUsernamePage> {
  TextEditingController nameController = TextEditingController();
  GlobalKey<FormState> nameKey = GlobalKey<FormState>();
  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider('update_name'), (previous, next) {
      if (next is AuthErrorState) {
        var error= next.error;
        SnackBarHelper.show(error, color: Colors.red);
      }else if(next is AuthLoadedSuccessfulyState){
        SnackBarHelper.show('Name update successfuly');
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
              title: 'Update username',
            ),

            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              sliver: SliverToBoxAdapter(
                child: Form(
                  key: nameKey,
                  child: CustomTextfields(
                    controller: nameController,
                    title: 'Enter new username',
                    focusNode: FocusNode(),
                    isObscure: false,
                    prefix: CupertinoIcons.person,
                    validator: (p0) => nameValidation(p0),
                  ),
                ),
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              sliver: const SliverToBoxAdapter(
                child: Text(
                  '* After hitting the update btn your name\n   will be updated.',
                  style: TextStyle(fontSize: 12, color: Colors.orange),
                ),
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              sliver: SliverToBoxAdapter(
                child: Consumer(
                  builder: (context, x, _) {
                    var auth = x.watch(authProvider('update_name'));
                    return CustomButton(
                      btnTitleWidget:
                          (auth is AuthLoadingState)
                              ? CupertinoActivityIndicator(color: Colors.white)
                              : Text(
                                'Update username',
                                style: TextStyle(color: Colors.white),
                              ),
                      onTap: () async {
                        var isNameValidate = nameKey.currentState!.validate();

                        if (isNameValidate) {
                          loadingDialog(context, 'Updating username...');
                          await x.read(authProvider('update_name').notifier).updateUsername(nameController.text.trim(),);

                          await x.read(getSharedPrefDataProvider.notifier).getNameEmailDataFromSP();
                          Navigator.pop(context);
                          nameController.clear();
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
