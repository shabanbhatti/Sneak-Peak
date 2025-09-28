import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/pages/user%20screens/notifications%20page/controllers/notification_stream.dart';

class NoNotificationsWidget extends ConsumerWidget {
  const NoNotificationsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var list = ref.watch(notificationStreamProvider).value ?? [];
    if (list.isEmpty) {
      return const SliverFillRemaining(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications, color: Colors.orange),
            Text(
              ' No notifications yet',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    } else {
      return const SliverToBoxAdapter();
    }
  }
}
