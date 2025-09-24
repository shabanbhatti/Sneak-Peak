import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/products_modals.dart';
import 'package:sneak_peak/provider/provider_objects.dart';

final productModelStreamProviderForUpdateAdminPage = StreamProvider.family<ProductModal, String>((ref,id,) {
var productRepository= ref.read(productServiceRepositoryProviderObject);
return productRepository.productModelStream(id);
});