import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/controllers/notifications_controllers.dart';
import 'package:sneak_peak/pages/user%20screens/notifications%20page/controllers/notification_stream.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';

class NotificationClearAllBtnWidget extends StatelessWidget {
  const NotificationClearAllBtnWidget({super.key});

  @override
  Widget build(BuildContext contextx) {
    return Consumer(
      builder: (context, x, _) {
        var list =
            x.watch(notificationStreamProvider).value ?? [];
        return (list.isNotEmpty)
            ? TextButton(
              onPressed: () async {
                print('------------------');
                loadingDialog(contextx, 'Deleting...');
                await x
                    .read(notificationProvider.notifier)
                    .deleteAllNotification();
                // ignore: use_build_context_synchronously
                Navigator.pop(contextx);
                print('------------------');
              },
              child: const Text(
                'Clear all',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
            : const SizedBox();
      },
    );
  }
}