import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/products_modals.dart';

final getProductsProvider = StreamProvider<List<ProductModal>>((ref) {
  return FirebaseFirestore.instance
      .collection('products')
      .snapshots()
      .map(
        (event) =>
            event.docs.map((e) => ProductModal.fromMap(e.data(), )).toList(),
      );
});
