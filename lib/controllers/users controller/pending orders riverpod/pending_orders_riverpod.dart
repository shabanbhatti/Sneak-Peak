import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/cart_poduct_modal.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';

final pendingOrdersProvider =
    StateNotifierProvider<PendingOrdersNotifier, int>((ref) {
      return PendingOrdersNotifier();
    });

class PendingOrdersNotifier extends StateNotifier<int> {
  PendingOrdersNotifier() : super(0);

  Future<void> addToPendingPayments(
    List<CartProductModal> list,
    BuildContext context,
  ) async {
    var auth = FirebaseAuth.instance.currentUser;
    var db = FirebaseFirestore.instance.collection('users').doc(auth!.uid);
    loadingDialog(context, 'Adding to pending payments', );
    try {
      for (var index in list) {
       
        await db
            .collection('pending_payment')
            .doc(index.id)
            .set(index.toMapFromPendingPayment(index.id!, index.img!, []));
        Navigator.pop(context);

       
      }
    } on FirebaseException catch (e) {
      Navigator.pop(context);
      SnackBarHelper.show(e.code, color: Colors.red);
    }
  }


  
  Future<void> deletePendingOrder(
    CartProductModal cartModal,
    BuildContext context,
  ) async {
    var auth = FirebaseAuth.instance.currentUser;
    var db = FirebaseFirestore.instance.collection('users').doc(auth!.uid);
    
    
    Navigator.pop(context);
    loadingDialog(context, 'Cancelling your order...');



    await db.collection('cancelled_orders').doc(cartModal.id).set(cartModal.toMap(cartModal.id??'', cartModal.img??[], [],int.parse(cartModal.quantity.toString()) , int.parse(cartModal.price.toString())));

    try {
      

      await db.collection('pending_payment').doc(cartModal.id).delete();

      Navigator.pop(context);
      SnackBarHelper.show('Order cancel successfuly');
    } on FirebaseException catch (e) {
      Navigator.pop(context);
      SnackBarHelper.show(e.code, color: Colors.red);
    }
  }
}
