import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/controllers/auth%20riverpod/auth_riverpod.dart';
import 'package:sneak_peak/controllers/get%20shared%20pref%20data%20riverpod/get_sp_data_riverpod.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';
import 'package:sneak_peak/widgets/admin%20app%20bar/transparent_app_bar.dart';
import 'package:sneak_peak/widgets/custom%20btn/custom_button.dart';
import 'package:sneak_peak/widgets/custom%20text%20fields/custom_textfields.dart';

class AdminEditNamePage extends ConsumerStatefulWidget {
  const AdminEditNamePage({super.key});
  static const pageName = 'edit_name';

  @override
  ConsumerState<AdminEditNamePage> createState() => _EditNamePageState();
}

class _EditNamePageState extends ConsumerState<AdminEditNamePage> {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  GlobalKey<FormState> fieldKey = GlobalKey<FormState>();


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('edit name pag build called');
     ref.listen(authProvider('update_name_admin'), (previous, next) {
      if (next is AuthErrorState) {
        var error= next.error;
        SnackBarHelper.show(error, color: Colors.red);
      }else if(next is AuthLoadedSuccessfulyState){
        SnackBarHelper.show('Name update successfuly');
      }
    },);
    return Scaffold(
      appBar: transparentAppBar(
        context: context,
        title: 'Edit your name',
        leadingOnTap: () => GoRouter.of(context).pop(),
        leadingIcon: CupertinoIcons.back,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Form(
                key: fieldKey,
                child: CustomTextfields(
                  controller: controller,
                  title: 'Update your name',
                  focusNode: focusNode,
                  isObscure: false,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Field should not be empty';
                    }
                    return null;
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  Text(
                    '* After clicking the update button your\n   name will be updated.',
                    style: TextStyle(color: Colors.orange, fontSize: 13),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: CustomButton(
                btnTitle: 'Update name',
                onTap: ()async{
                  loadingDialog(context, 'Updating username...');
                          await ref.read(authProvider('update_name_admin').notifier).updateUsername(controller.text.trim(),);

                          await ref.read(getSharedPrefDataProvider.notifier).getNameEmailDataFromSP();
                          Navigator.pop(context);
                          controller.clear();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
