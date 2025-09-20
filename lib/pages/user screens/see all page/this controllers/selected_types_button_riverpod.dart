
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedButtonProvider =
    StateNotifierProvider.autoDispose<SelectedButtonNotifier, String>((ref) {
      return SelectedButtonNotifier();
    });

class SelectedButtonNotifier extends StateNotifier<String> {
  SelectedButtonNotifier() : super('All');

  void toggeled(String title) {
    state = title;
  }
}
