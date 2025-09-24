import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/provider/provider_objects.dart';

final orderDeliveryStatusStreamProvider = StreamProvider.family.autoDispose<String, String>((ref, id) {
  var productRepository= ref.read(productServiceRepositoryProviderObject);
  return productRepository.orderDeliveryStatus(id);
});