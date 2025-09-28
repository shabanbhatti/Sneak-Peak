import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/products_modals.dart';

final searchProductProvider = StateNotifierProvider.autoDispose<
  SearchProductStateNotifier,
  List<ProductModal>
>((ref) {
  return SearchProductStateNotifier();
});

class SearchProductStateNotifier extends StateNotifier<List<ProductModal>> {
  SearchProductStateNotifier() : super([]);

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
                    element.title!.toLowerCase().trim().startsWith(
                      value.toLowerCase().trim(),
                    ) ||
                    element.brand!.toLowerCase().trim().startsWith(
                      value.toLowerCase().trim(),
                    ) ||
                    element.genders!.any(
                      (gender) => gender.toLowerCase().startsWith(
                        value.toLowerCase().trim(),
                      ),
                    ),
              )
              .toList();
      print('IS NOT EMPTY');
    } else {
      state = [];
    }
  }

  Future<void> highToLow() async {
    final sortedList = [...state];
    sortedList.sort((a, b) {
      final aPrice = int.tryParse(a.price ?? '0') ?? 0;
      final bPrice = int.tryParse(b.price ?? '0') ?? 0;
      return aPrice.compareTo(bPrice);
    });
    state = sortedList;
  }

  void lowToHigh() {
    final sortedList = [...state];
    sortedList.sort((a, b) {
      final aPrice = int.tryParse(a.price ?? '0') ?? 0;
      final bPrice = int.tryParse(b.price ?? '0') ?? 0;
      return bPrice.compareTo(aPrice);
    });
    state = sortedList;
  }
}

final searchValueProvider =
    StateNotifierProvider.autoDispose<SearchValueNotifier, String>((ref) {
      return SearchValueNotifier();
    });

class SearchValueNotifier extends StateNotifier<String> {
  SearchValueNotifier() : super('');

  void addValue(String value) async {
    state = value;
  }
}
