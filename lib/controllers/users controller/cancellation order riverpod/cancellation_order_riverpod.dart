import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/cart_poduct_modal.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';

final cancellationProvider =
    StateNotifierProvider<CancellationNotifier, String>((ref) {
      return CancellationNotifier();
    });

class CancellationNotifier extends StateNotifier<String> {
  CancellationNotifier() : super('');

  Future<void> removeCancelledOrders(
    BuildContext context,
    CartProductModal cartModal,
  ) async {
    var auth = FirebaseAuth.instance.currentUser;
    var db = FirebaseFirestore.instance.collection('users').doc(auth?.uid);

    
    try {
      loadingDialog(context, 'Deleting cancelled item...', );
      await db.collection('cancelled_orders').doc(cartModal.id).delete();
     
      
Navigator.pop(context);
      SnackBarHelper.show('Deleted successfully');
    } on FirebaseException catch (e) {
     Navigator.pop(context);

      SnackBarHelper.show(e.code, color: Colors.red);
    }
  }
}
