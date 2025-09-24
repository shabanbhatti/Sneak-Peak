import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/products_modals.dart';
import 'package:sneak_peak/provider/provider_objects.dart';

final streamsProductDataProvider = StreamProvider.family<
  List<ProductModal>,
  String
>((ref, brand) {
  var userRepository = ref.read(userCloudDbRepositoryProvider);
  return userRepository.getProductByBrand(brand);
});
