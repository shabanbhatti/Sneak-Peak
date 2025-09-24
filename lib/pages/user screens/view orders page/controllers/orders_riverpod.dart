import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/cart_poduct_modal.dart';
import 'package:sneak_peak/provider/provider_objects.dart';
import 'package:sneak_peak/repository/user%20repository/user_cloud_db_repository.dart';

final ordersProvider = StateNotifierProvider<OrderStateNotifier, String>((ref) {
  return OrderStateNotifier(userRepo: ref.read(userCloudDbRepositoryProvider));
});

class OrderStateNotifier extends StateNotifier<String> {
  final UserCloudDbRepository userRepo;
  OrderStateNotifier({required this.userRepo}) : super('init');

  Future<bool> cancelOrder(
    String id,
    List<CartProductModal> cartModelList,
  ) async {
  
    try {
      state = 'loading';
      await userRepo.cancelorder(id, cartModelList);
      state = 'done';
      return true;
     
    } catch (e) {
      state = e.toString();
      return false;
    }
  }

}
