import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/cart_poduct_modal.dart';
import 'package:sneak_peak/models/products_modals.dart';
import 'package:sneak_peak/provider/provider_objects.dart';
import 'package:sneak_peak/repository/user%20repository/user_cloud_db_repository.dart';

final wishlistProvider =
    StateNotifierProvider.family<WishlistStateNotifier, bool, String>((
      ref,
      dataTitle,
    ) {
      return WishlistStateNotifier(
        userRepository: ref.read(userCloudDbRepositoryProvider),
      );
    });

class WishlistStateNotifier extends StateNotifier<bool> {
  final UserCloudDbRepository userRepository;
  WishlistStateNotifier({required this.userRepository}) : super(false);

  Future<bool> addToWishlist(ProductModal productModal) async {
    state = !state;
    try {
      await userRepository.addToWishlist(state, productModal);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeFromWishlist(CartProductModal cartModal) async {
    try {
      await userRepository.removeFromWishlist(cartModal);

      state = false;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> isFav(bool isTrue) async {
    state = isTrue;
  }

  Future<void> setToFalse() async {
    state = true;
  }
}
