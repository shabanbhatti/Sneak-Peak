import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/orders_modals.dart';
import 'package:sneak_peak/provider/provider_objects.dart';


final adminOrdersStreamProvider = StreamProvider.autoDispose<List<OrdersModals>>((ref) {
  var productRepository= ref.read(productServiceRepositoryProviderObject);
  return productRepository.getOrders();
});