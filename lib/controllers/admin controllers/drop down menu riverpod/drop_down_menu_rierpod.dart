import 'package:flutter_riverpod/flutter_riverpod.dart';

final dropDownMenuProvider =
    StateNotifierProvider.autoDispose<DropDownMenuNotifier, String?>((ref) {
      return DropDownMenuNotifier();
    });

class DropDownMenuNotifier extends StateNotifier<String?> {
  DropDownMenuNotifier() : super(null);

  Future<void> addValue(String value) async {
    state = value;
    print(state);
  }
}
