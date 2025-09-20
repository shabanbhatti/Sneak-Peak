import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/controllers/users%20controller/cancellation%20order%20riverpod/cancellation_order_riverpod.dart';
import 'package:sneak_peak/pages/user%20screens/cancellation%20page/this%20controller/cancellation_stream_riverpod.dart';
import 'package:sneak_peak/pages/user%20screens/user_main.dart';
import 'package:sneak_peak/widgets/custom%20btn/custom_button.dart';

class NoCancellationWidget extends ConsumerWidget {
  const NoCancellationWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var auth= FirebaseAuth.instance.currentUser;
    print('NO cancellation WIDGET BUILD CALLED');
    var list = ref.watch(cancellationStreamProvider(auth!.uid)).value??[];
    var stream = ref.watch(cancellationStreamProvider(auth!.uid));
    
      if (list.isEmpty && !stream.isLoading) {
        return SliverFillRemaining(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.close, color: Colors.orange),
                    const Text(
                      '  No cancellations found',
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
        );
      } else {
        return const SliverToBoxAdapter();
      }
    } 
  }

