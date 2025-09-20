import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/pages/user%20screens/cart%20page/this%20controllers/cart_stream_provider.dart';

class NoCartAddedWidget extends ConsumerWidget {
  const NoCartAddedWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
     var auth= FirebaseAuth.instance.currentUser;
     var stream = ref.watch(cartStreamProvider(auth!.uid));
var streamList = ref.watch(cartStreamProvider(auth.uid)).value ?? [];
    return (streamList.isEmpty&&!stream.isLoading)
        ? const SliverFillRemaining(
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_bag, color: Colors.orange),
                Text(' No cart added yet'),
              ],
            ),
          ),
        )
        : const SliverToBoxAdapter();
  }
}
