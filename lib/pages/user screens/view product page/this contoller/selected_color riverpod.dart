

import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedColorProvider = StateNotifierProvider.autoDispose<SelectedColorNotifier, String>((ref) {
  return SelectedColorNotifier();
});

class SelectedColorNotifier extends StateNotifier<String> {
  SelectedColorNotifier(): super('');
  
void addColor(String colorName){
state= colorName;
}

}