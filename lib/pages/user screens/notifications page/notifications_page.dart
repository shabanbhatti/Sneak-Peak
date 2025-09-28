import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/controllers/notifications_controllers.dart';
import 'package:sneak_peak/pages/user%20screens/notifications%20page/controllers/notification_stream.dart';
import 'package:sneak_peak/pages/user%20screens/notifications%20page/widgets/no_notifications_widget.dart';
import 'package:sneak_peak/pages/user%20screens/notifications%20page/widgets/notification_clear_all_btn_widget.dart';
import 'package:sneak_peak/services/shared%20pref%20service/shared_pref_service.dart';
import 'package:sneak_peak/utils/date_time_constant_formats.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';
import 'package:sneak_peak/widgets/animated%20loading/animated_loading_widget.dart';
import 'package:sneak_peak/widgets/custom%20sliver%20app%20bar/custom_sliverappbar.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});
  static const pageName = 'notification_page';

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    checkNotificationToggle();
  }

  void checkNotificationToggle() async {
    var isOn = await SPHelper.getBoolForSwitcher(SPHelper.switcher);
    if (isOn == false) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        SnackBarHelper.show(
          'Your notifications are disabled 🔕, turn it on from profile to receive updates 🚨',
          color: Colors.orange,
          duration: const Duration(seconds: 7),
        );
      });
    }
  }

  @override
  Widget build(BuildContext contextx) {
    print('notiication page build called');
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 5,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Center(
        child: Scrollbar(
          thickness: 5,
          radius: Radius.circular(20),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              CustomSliverAppBar(
                leadingOnTap: () {
                  GoRouter.of(contextx).pop();
                },
                leadingIcon: CupertinoIcons.back,
                title: 'Notifications',
                widget: const NotificationClearAllBtnWidget(),
              ),

              SliverToBoxAdapter(
                child: Center(
                  child: Consumer(
                    builder: (context, ref, child) {
                      var notificationStream = ref.watch(
                        notificationStreamProvider,
                      );
                      return notificationStream.when(
                        data: (data) {
                          return ListView.builder(
                            reverse: true,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return Slidable(
                                key: ValueKey(data[index]),
                                closeOnScroll: false,
                                endActionPane: ActionPane(
                                  motion: StretchMotion(),
                                  children: [
                                    SlidableAction(
                                      autoClose: true,
                                      flex: 1,

                                      onPressed: (context) async {
                                        loadingDialog(
                                          contextx,
                                          'Clearing all notifications...',
                                        );
                                        await ref
                                            .read(notificationProvider.notifier)
                                            .deleteNotification(
                                              data[index].id.toString(),
                                            );
                                        // ignore: use_build_context_synchronously
                                        Navigator.pop(contextx);
                                      },
                                      icon: CupertinoIcons.delete,
                                      backgroundColor: Colors.red,
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  shape: Border(
                                    bottom: BorderSide(color: Colors.orange),
                                  ),
                                  leading: const CircleAvatar(
                                    backgroundColor: Colors.orange,
                                    child: Icon(
                                      Icons.notifications,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text(
                                    data[index].metaDataTitle ?? '',
                                    maxLines: 3,
                                    overflow: TextOverflow.fade,
                                  ),
                                  subtitle: Text(
                                    data[index].metaDataBody ?? '',
                                  ),
                                  trailing: Text(
                                    dateFormat(data[index].date ?? ''),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        error: (error, stackTrace) => Text(error.toString()),
                        loading: () => const AnimatedLoadingWidget(),
                      );
                    },
                  ),
                ),
              ),
              const NoNotificationsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
