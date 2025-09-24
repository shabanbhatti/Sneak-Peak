import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/cart_poduct_modal.dart';
import 'package:sneak_peak/provider/provider_objects.dart';

final cartStreamProvider = StreamProvider<List<CartProductModal>>((ref) {
  var userRepo= ref.read(userCloudDbRepositoryProvider);
  return userRepo.cartProductsStream();
});