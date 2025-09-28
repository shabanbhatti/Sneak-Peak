import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/products_modals.dart';
import 'package:sneak_peak/provider/provider_objects.dart';

final getProductsProvider = StreamProvider<List<ProductModal>>((ref) {
  var productCloudDbRepository= ref.read(productServiceRepositoryProviderObject);
  return productCloudDbRepository.getProductsStream();
});
