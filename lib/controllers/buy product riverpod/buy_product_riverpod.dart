

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/orders_modals.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';

final buyProductProvider =
    StateNotifierProvider<BuyProductNotifier, BuyProductState>((ref) {
      return BuyProductNotifier();
    });

class BuyProductNotifier extends StateNotifier<BuyProductState> {
  BuyProductNotifier() : super(InitialBuyProductState());

  Future<void> buy(BuildContext context, OrdersModals orderModal) async {
    var db = FirebaseFirestore.instance;
    var auth = FirebaseAuth.instance.currentUser;
    state = LoadingBuyProductState();
    loadingDialog(context, 'Placing your order...');

    print(orderModal.productsList);
    try {
      try {
        String id = DateTime.now().microsecondsSinceEpoch.toString();
        await db
            .collection('orders')
            .doc(id)
            .set(orderModal.toMap(auth!.uid, id));

            await db.collection('users').doc(auth.uid).collection('to_ship').doc(id).set(orderModal.toMap(auth.uid, id));
            for (var index in orderModal.productsList!) {
              var get= await db.collection('products').doc(index.id).get();
              var data= get.data()??{};
              var solds= data['solds']??0;
              print(solds);
              
              int totalSolds= solds+1;
               await db.collection('products').doc(index.id).update({'solds':totalSolds});
            }
        state = LoadedSuccessfulyBuyProductState();
        Navigator.pop(context);
      } catch (e) {
        print(e.toString());
      }
    } on FirebaseException catch (e) {
      SnackBarHelper.show(e.code, color: Colors.red);
    }
  }
}

sealed class BuyProductState {
  const BuyProductState();
}

class InitialBuyProductState extends BuyProductState {
  const InitialBuyProductState();
}

class LoadingBuyProductState extends BuyProductState {
  const LoadingBuyProductState();
}

class LoadedSuccessfulyBuyProductState extends BuyProductState {
  const LoadedSuccessfulyBuyProductState();
}

class ErrorBuyProductState extends BuyProductState {
  final String error;
  const ErrorBuyProductState({required this.error});
}
