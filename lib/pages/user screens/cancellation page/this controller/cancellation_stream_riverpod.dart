import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/cart_poduct_modal.dart';
import 'package:sneak_peak/provider/provider_objects.dart';

final cancellationStreamProvider =
    StreamProvider<List<CartProductModal>>((ref) {
      var userRepository= ref.read(userCloudDbRepositoryProvider);
      return userRepository.cancelledProducts();
    });
