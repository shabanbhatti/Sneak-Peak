import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/pages/admin%20screens/orders%20page/controllers/orders_stream_riverpod.dart';
import 'package:sneak_peak/utils/constant_steps.dart';

class NoOrdersWidget extends ConsumerWidget {
  const NoOrdersWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var stream = ref.watch(adminOrdersStreamProvider);
    var streamList = stream.value ?? [];
    var list =
        streamList
            .where((element) => element.deliveryStatus != delivered)
            .toList();
    return (list.isEmpty && !stream.isLoading)
        ?const SliverFillRemaining(
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.doc_plaintext, color: Colors.orange),
                Text(
                  ' No orders yet',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        )
        :const SliverToBoxAdapter();
  }
}
