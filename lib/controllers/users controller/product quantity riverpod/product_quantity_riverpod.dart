
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';

final quantityAddRemoveProvider =
    StateNotifierProvider<QuantityAddRemoveNotifier, int>((ref) {
      return QuantityAddRemoveNotifier();
    });

class QuantityAddRemoveNotifier extends StateNotifier<int> {
  QuantityAddRemoveNotifier() : super(1);

  Future<void> addNumber(
    String id,
    int currentQuantity,
    int price,
    BuildContext context,
  ) async {
    var auth = FirebaseAuth.instance.currentUser;
    var db = FirebaseFirestore.instance
        .collection('users')
        .doc(auth!.uid)
        .collection('carts');

    try {
      if (currentQuantity < 5) {
        loadingDialog(context, '', color: Colors.transparent);
         var data = await db.doc(id).get();
        int originalPrice = data['original_price'];
        int number = currentQuantity + 1;
        String newPrice = (price + originalPrice).toString();
        await db.doc(id).update({'quantity': number, 'price': newPrice});
        Navigator.pop(context);
      }
    } on FirebaseException catch (e) {
      SnackBarHelper.show(e.code.toString());
    }
  }

  Future<void> decreaseNumber(
    String id,
    int currentQuantity,
    int price,
    BuildContext context,
  ) async {
    var auth = FirebaseAuth.instance.currentUser;
    var db = FirebaseFirestore.instance
        .collection('users')
        .doc(auth!.uid)
        .collection('carts');

    try {
      if (currentQuantity > 1) {
        loadingDialog(context, '', color: Colors.transparent);
        var data = await db.doc(id).get();
        int originalPrice = data['original_price'];
        log('original: $originalPrice');
        log('existing: $price');
        int number = currentQuantity - 1;
        int x = price - originalPrice;
        
        log('new price $x');
       
        String newPrice = x.toString();
      log('String formatted $newPrice');
        await db.doc(id).update({'quantity': number, 'price': newPrice});
        Navigator.pop(context);
      }
    } on FirebaseException catch (e) {
      SnackBarHelper.show(e.code.toString());
    }
  }
}
