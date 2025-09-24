import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/orders_modals.dart';
import 'package:sneak_peak/provider/provider_objects.dart';

final toShipStreamProvider = StreamProvider<List<OrdersModals>>((ref) {
  var userRepo= ref.read(userCloudDbRepositoryProvider);
  return userRepo.toShipStream();
});