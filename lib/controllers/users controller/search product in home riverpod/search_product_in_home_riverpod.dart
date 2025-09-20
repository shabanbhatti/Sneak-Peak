import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/products_modals.dart';

final userHomeSearchProductProvider = StateNotifierProvider.autoDispose
    .family<UserHomeSearchProductStateNotifier, List<ProductModal>, String>((
      ref,
      dataTitle,
    ) {
      return UserHomeSearchProductStateNotifier();
    });

class UserHomeSearchProductStateNotifier
    extends StateNotifier<List<ProductModal>> {
  UserHomeSearchProductStateNotifier() : super([]);

  Future<void> addProducts(List<ProductModal> data) async {
    state = data;
    print(state);
  }

  Future<void> onChanged(String value, List<ProductModal> list) async {
    if (value.isNotEmpty) {
      state =
          list
              .where(
                (element) =>
                    element.title!.toLowerCase().trim().contains(
                      value.toLowerCase().trim(),
                    ) ||
                    element.brand!.toLowerCase().trim().contains(
                      value.toLowerCase().trim(),
                    ),
              )
              .toList();
      print('IS NOT EMPTY');
    } else {
      state = list;
    }
  }
}
