

import 'package:flutter_riverpod/flutter_riverpod.dart';

final addProductColorProvider = StateNotifierProvider.autoDispose<AddProductColorStateNotifier, List<String>>((ref) {
  return  AddProductColorStateNotifier();
});

class AddProductColorStateNotifier extends StateNotifier<List<String>> {
  AddProductColorStateNotifier(): super([]);
  
Future<void> addColors(String color)async{

state= [...state, color];
// print(state);
}


Future<void> deleteColor(String color)async{
state= state.where((element) => element!=color,).toList();
// print(state);
}


}