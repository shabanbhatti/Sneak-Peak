
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final crossFadeProvider =
    StateNotifierProvider.autoDispose<CrossFadeStateNotifier, CrossFadeState>((ref) {
      return CrossFadeStateNotifier();
    });

class CrossFadeStateNotifier extends StateNotifier<CrossFadeState> {
Timer? timer;
  CrossFadeStateNotifier() : super(CrossFadeState.showFirst);

  Future<void> toggeled() async {
    timer= Timer.periodic(const Duration(seconds: 2), (timer) {
      if (state == CrossFadeState.showFirst) {
        state = CrossFadeState.showSecond;
      } else {
        state = CrossFadeState.showFirst;
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}