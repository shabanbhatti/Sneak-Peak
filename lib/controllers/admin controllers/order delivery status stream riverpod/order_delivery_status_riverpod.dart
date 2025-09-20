import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final orderDeliveryStatusStreamProvider = StreamProvider.family.autoDispose<String, String>((ref, id) {
  var db= FirebaseFirestore.instance.collection('orders').doc(id);
  return db.snapshots().map((event) {
    var data= event.data()??{};
    return data['deliveryStatus'];
  },);
});