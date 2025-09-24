import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/provider/provider_objects.dart';
import 'package:sneak_peak/repository/user%20repository/user_cloud_db_repository.dart';

final productQuantityProvider =
    StateNotifierProvider<QuantityAddRemoveNotifier, String>((ref) {
      return QuantityAddRemoveNotifier(
        userRepository: ref.read(userCloudDbRepositoryProvider),
      );
    });

class QuantityAddRemoveNotifier extends StateNotifier<String> {
  final UserCloudDbRepository userRepository;
  QuantityAddRemoveNotifier({required this.userRepository}) : super('init');

  Future<bool> increment(String id, int currentQuantity, int price) async {
    try {
      state = 'loading';

      await userRepository.productQuantityBtnInCart(
        id,
        price,
        currentQuantity,
        true,
      );
      state = 'done';
      return true;
    } catch (e) {
      state = e.toString();
      return false;
    }
  }

  Future<bool> decrement(String id, int currentQuantity, int price) async {
    try {
      state = 'loading';

      await userRepository.productQuantityBtnInCart(
        id,
        price,
        currentQuantity,
        false,
      );

      state = 'done';
      return true;
    } catch (e) {
      state = e.toString();
      return false;
    }
  }
}
