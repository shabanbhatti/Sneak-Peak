import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/pages/user%20screens/pending%20order%20page/this_controllers/pending_stream_provider.dart';
import 'package:sneak_peak/pages/user%20screens/user_main.dart';
import 'package:sneak_peak/widgets/custom%20btn/custom_button.dart';

class NoPendingWidget extends ConsumerWidget {
  const NoPendingWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    print('NO PENDING WIDGET BUILD CALLED');
    var auth = FirebaseAuth.instance.currentUser;
    var stream = ref.watch(pendingStreamProvider(auth!.uid));
    var list= stream.value??[];
      if (list.isEmpty&&!stream.isLoading) {
        return SliverFillRemaining(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   const Icon(Icons.alarm, color: Colors.orange),
                    const Text(
                      '  No pending payments found',
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
      }else if(stream.isLoading){
        return const SliverToBoxAdapter();
      }else{
        return const SliverToBoxAdapter();
      }
    }   }

