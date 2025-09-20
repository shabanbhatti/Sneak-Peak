import 'package:flutter_riverpod/flutter_riverpod.dart';

final confirmOrderProvider = StateNotifierProvider<ConfirmOrderNotifier, String>((ref) {
  return ConfirmOrderNotifier();
});

class ConfirmOrderNotifier extends StateNotifier<String> {
  ConfirmOrderNotifier(): super('');


Future<void> confirmOrder()async{




}

  
}