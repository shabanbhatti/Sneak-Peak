import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/pages/admin%20screens/orders%20page/controllers/orders_stream_riverpod.dart';
import 'package:sneak_peak/utils/constant_steps.dart';

class NoCompletedOrdersWidget extends ConsumerWidget {
  const NoCompletedOrdersWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var stream = ref.watch(adminOrdersStreamProvider);
    var streamList = stream.value ?? [];
    var list =
        streamList
            .where((element) => element.deliveryStatus == delivered)
            .toList();
    return (list.isEmpty && !stream.isLoading)
        ? const SliverFillRemaining(
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.green,
                  child: Icon(Icons.check, color: Colors.white),
                ),
                Text(
                  '  No order completed yet ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        )
        : const SliverToBoxAdapter();
  }
}
