import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/pages/user%20screens/to%20ship%20page/controllers/to_ship_stream_riverpod.dart';
import 'package:sneak_peak/pages/user%20screens/user_main.dart';
import 'package:sneak_peak/utils/constant_steps.dart';
import 'package:sneak_peak/widgets/custom%20btn/custom_button.dart';

class CompletedNoDataWidget extends ConsumerWidget {
  const CompletedNoDataWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var auth = FirebaseAuth.instance.currentUser;
    var stream = ref.watch(toShipStreamProvider(auth!.uid));
    var streamList = ref.watch(toShipStreamProvider(auth.uid)).value ?? [];
    var list =
        streamList
            .where((element) => element.deliveryStatus == delivered)
            .toList();
    return (list.isEmpty && !stream.isLoading)
        ? SliverFillRemaining(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.orange),
                    const Text(
                      '  No completed orders found',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                CustomButton(
                  btnTitle: 'Continue shopping',
                  onTap:
                      () => GoRouter.of(context).goNamed(UserMainPage.pageName),
                ),
              ],
            ),
          ),
        )
        : const SliverToBoxAdapter();
  }
}
