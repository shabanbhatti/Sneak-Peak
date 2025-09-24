import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/cart_poduct_modal.dart';
import 'package:sneak_peak/provider/provider_objects.dart';
import 'package:sneak_peak/repository/user%20repository/user_cloud_db_repository.dart';


final removerCancelOrderProvider =
    StateNotifierProvider<CancellationNotifier, String>((ref) {
      return CancellationNotifier(userCloudDbRepository: ref.read(userCloudDbRepositoryProvider));
    });

class CancellationNotifier extends StateNotifier<String> {
  final UserCloudDbRepository userCloudDbRepository;
  CancellationNotifier({required this.userCloudDbRepository}) : super('init');

  Future<bool> removeCancelledOrders(CartProductModal cartModal,) async {
    
    try {
    
await userCloudDbRepository.removerCancelOrder(cartModal);
state='done';
return true;
    }  catch (e) {
      state=e.toString();
      return false;
    }
  }
}
