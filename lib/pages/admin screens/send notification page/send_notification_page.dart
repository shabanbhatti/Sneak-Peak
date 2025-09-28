import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/controllers/notifications_controllers.dart';
import 'package:sneak_peak/models/notifications_model.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';
import 'package:sneak_peak/utils/validations.dart';
import 'package:sneak_peak/widgets/custom%20btn/custom_button.dart';
import 'package:sneak_peak/widgets/custom%20sliver%20app%20bar/custom_sliverappbar.dart';
import 'package:sneak_peak/widgets/custom%20text%20fields/custom_textfields.dart';

class SendNotificationPage extends StatefulWidget {
  const SendNotificationPage({super.key});
  static const String pageName = 'noti_page';

  @override
  State<SendNotificationPage> createState() => _SendNotificationPageState();
}

class _SendNotificationPageState extends State<SendNotificationPage> {
  final titleController = TextEditingController();
  final titleKey = GlobalKey<FormState>();
  final bodyController = TextEditingController();
  final bodyKey = GlobalKey<FormState>();
  final metaDataTitleController = TextEditingController();
  final metadataTitleKey = GlobalKey<FormState>();
  final metaDataBodyController = TextEditingController();
  final metadataBodyKey = GlobalKey<FormState>();

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    metaDataTitleController.dispose();
    metaDataBodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          slivers: [
            CustomSliverAppBar(
              leadingOnTap: () => GoRouter.of(context).pop(),
              leadingIcon: CupertinoIcons.back,
              title: 'Send notifications',
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Form(
                      key: titleKey,
                      child: CustomTextfields(
                        controller: titleController,
                        title: 'Title',
                        focusNode: FocusNode(),
                        isObscure: false,
                        validator: (p0) => notNullValidation(p0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Form(
                      key: bodyKey,
                      child: CustomTextfields(
                        controller: bodyController,
                        title: 'Body',
                        focusNode: FocusNode(),
                        isObscure: false,
                        validator: (p0) => notNullValidation(p0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Form(
                      key: metadataTitleKey,
                      child: CustomTextfields(
                        controller: metaDataTitleController,
                        title: 'Metadata title',
                        focusNode: FocusNode(),
                        isObscure: false,
                        validator: (p0) => notNullValidation(p0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Form(
                      key: metadataBodyKey,
                      child: CustomTextfields(
                        controller: metaDataBodyController,
                        title: 'metadata body',
                        focusNode: FocusNode(),
                        isObscure: false,
                        validator: (p0) => notNullValidation(p0),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 10),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: Consumer(
                    builder: (context, ref, _) {
                      var notification = ref.watch(notificationProvider);
                      return CustomButton(
                        onTap: () async {
                          var titleValidation =
                              titleKey.currentState?.validate();
                          var bodyValidaton = bodyKey.currentState?.validate();
                          var metadataTitleValidation =
                              metadataTitleKey.currentState?.validate();
                          var metadataBodyValidation =
                              metadataBodyKey.currentState?.validate();
                          if (titleValidation! &&
                              metadataBodyValidation! &&
                              metadataTitleValidation! &&
                              bodyValidaton!) {
                            loadingDialog(context, 'Sending notification...');

                            var isSent = await ref
                                .read(notificationProvider.notifier)
                                .sendNotificatonToAll(
                                  NotificationsModel(
                                    title: titleController.text.trim(),
                                    body: bodyController.text.trim(),
                                    date: DateTime.now().toString(),
                                    isRead: false,
                                    metaDataTitle:
                                        metaDataTitleController.text.trim(),
                                    metaDataBody:
                                        metaDataBodyController.text.trim(),
                                  ),
                                );

                            Navigator.pop(context);
                            if (isSent) {
                              SnackBarHelper.show(
                                'Notification sent successfully',
                              );
                            } else {
                              SnackBarHelper.show(
                                'Something went wrong',
                                color: Colors.red,
                              );
                            }
                          }
                        },
                        btnTitleWidget:
                            (notification is LoadingNotification)
                                ? const CupertinoActivityIndicator(
                                  color: Colors.white,
                                )
                                : const Text(
                                  'Send notification',
                                  style: TextStyle(color: Colors.white),
                                ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
