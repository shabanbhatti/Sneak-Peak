import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/cart_poduct_modal.dart';
import 'package:sneak_peak/models/orders_modals.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';

final ordersProvider = StateNotifierProvider<OrderStateNotifier, String>((ref) {
  return OrderStateNotifier();
});

class OrderStateNotifier extends StateNotifier<String> {
  OrderStateNotifier(): super('');
  

Future<void> cancelOrder(BuildContext context, String id, List<CartProductModal> cartModelList )async{
Navigator.pop(context);
var auth= FirebaseAuth.instance.currentUser;
var userDb= FirebaseFirestore.instance.collection('users').doc(auth!.uid);
var orderDb= FirebaseFirestore.instance.collection('orders');
loadingDialog(context, 'Cancelling your order...');
try {
  
  for (var index in cartModelList) {
    await userDb.collection('cancelled_orders').doc(index.id).set(index.toMap(index.id??'', index.img??[], index.storageImgsPath??[], index.quantity??0, index.originalPrice??0));
  }


await userDb.collection('to_ship').doc(id).delete();
await orderDb.doc(id).delete();
Navigator.pop(context);
SnackBarHelper.show('Order cancel successfuly');
}on FirebaseException catch (e) {
  Navigator.pop(context);
  SnackBarHelper.show(e.code, color: Colors.red);
}
}



Future<void> updateOrderThatDeletedByAdmin(OrdersModals orderModel,)async{
  var auth= FirebaseAuth.instance.currentUser;
var db= FirebaseFirestore.instance.collection('users').doc(auth!.uid);

try {
  
  
db.collection('to_ship').doc(orderModel.id).update(orderModel.toMap(orderModel.userUid??'', orderModel.id??''));


}on FirebaseException catch (e) {
  SnackBarHelper.show(e.code, color: Colors.red);
}


}

}