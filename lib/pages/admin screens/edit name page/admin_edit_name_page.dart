import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/controllers/users%20controller/user_firebase_riverpod.dart';
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
                onTap: () {
                  ref
                      .read(userProvider.notifier)
                      .updateName(controller.text.trim(), context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
