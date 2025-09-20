import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/products_modals.dart';

final streamsProductDataProvider = StreamProvider.family<
  List<ProductModal>,
  String
>((ref, brand) {
  var db = FirebaseFirestore.instance.collection('products');
  if (brand == '') {
    return db.snapshots().map(
      (event) => event.docs.map((e) => ProductModal.fromMap(e.data())).toList(),
    );
  } else {
    return db
        .where('brand', isEqualTo: brand)
        .snapshots()
        .map(
          (event) =>
              event.docs.map((e) => ProductModal.fromMap(e.data())).toList(),
        );
  }
});