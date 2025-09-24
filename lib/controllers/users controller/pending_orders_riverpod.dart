import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/cart_poduct_modal.dart';
import 'package:sneak_peak/provider/provider_objects.dart';
import 'package:sneak_peak/repository/user%20repository/user_cloud_db_repository.dart';

final pendingOrdersProvider =
    StateNotifierProvider<PendingOrdersNotifier, String>((ref) {
      return PendingOrdersNotifier(
        userRepository: ref.read(userCloudDbRepositoryProvider),
      );
    });

class PendingOrdersNotifier extends StateNotifier<String> {
  UserCloudDbRepository userRepository;
  PendingOrdersNotifier({required this.userRepository}) : super('init');

  Future<bool> addToPendingPayments(List<CartProductModal> list) async {
    try {
      state = 'loading';
      await userRepository.addToPendingPayments(list);

      state = 'done';
      return true;
    } catch (e) {
      state = e.toString();
      return false;
    }
  }

  Future<bool> deletePendingOrder(CartProductModal cartModal) async {
    try {
      state = 'loading';
      await userRepository.deletePendingOrderAndThenAddToCancelOrders(
        cartModal,
      );

      state = 'done';
      return true;
    } catch (e) {
      state = e.toString();
      return false;
    }
  }
}
