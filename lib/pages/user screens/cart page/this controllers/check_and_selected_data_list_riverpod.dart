import 'dart:developer' show log;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/cart_poduct_modal.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';

final itemCheckProvider = StateProvider.family<bool, String>(
  (ref, id) => false,
);

final selectedDataList =
    StateNotifierProvider<SelectedDataListStateNotifier, CheckSelectedClass>((
      ref,
    ) {
      return SelectedDataListStateNotifier();
    });

class SelectedDataListStateNotifier extends StateNotifier<CheckSelectedClass> {
  SelectedDataListStateNotifier()
    : super(CheckSelectedClass(totalPrice: 0, cartList: [], disableProductList: []));

  Future<void> toggeled(bool value, CartProductModal cartProductModal) async {
    log('${cartProductModal.id}');

   if (cartProductModal.isProductExist!) {
      if (value) {
      List<CartProductModal> list = [...state.cartList, cartProductModal];

      int totalPrice = list
          .map((e) => int.parse(e.price!))
          .reduce((value, element) => value + element);
      state = state.copyWith(cartListX: list, totalPriceX: totalPrice, disableproductListX: []);
      print(state.cartList);
    } else {
      List<CartProductModal> list =
          state.cartList
              .where((element) => element.id != cartProductModal.id)
              .toList();
      if (state.cartList.length > 1) {
        int totalPrice = list
            .map((e) => int.parse(e.price!))
            .reduce((value, element) => value + element);
        state = state.copyWith(cartListX: list, totalPriceX: totalPrice, disableproductListX: []);
      } else {
        state = state.copyWith(cartListX: list, totalPriceX: 0, disableproductListX: []);
      }
    }
   }else{
    state= state.copyWith(disableproductListX: [...state.disableProductList, cartProductModal]);
   }
  }

  Future<void> deleteCartProducts(BuildContext context ) async {
    var auth = FirebaseAuth.instance.currentUser;
    var db = FirebaseFirestore.instance
        .collection('users')
        .doc(auth!.uid)
        .collection('carts');
  
    if (state.cartList.isNotEmpty) {
      try {
        loadingDialog(context, 'Deleting selected carts...');

     
        for (var element in state.cartList) {
          await db.doc(element.id).delete();
        }

        state = state.copyWith(cartListX: [], totalPriceX: 0);
        Navigator.pop(context);
      } on FirebaseException catch (e) {
        SnackBarHelper.show(e.code, color: Colors.red);
      }
    }else if (state.disableProductList.isNotEmpty) {
      try {
        loadingDialog(context, 'Deleting...');

        Future.wait(
          state.disableProductList.map((e) async {

            await db.doc(e.id).delete();
          }),
          
        );

        state = state.copyWith(cartListX: [], totalPriceX: 0);
        Navigator.pop(context);
      } on FirebaseException catch (e) {
        SnackBarHelper.show(e.code, color: Colors.red);
      }
    } else {
      SnackBarHelper.show('Please select item', color: Colors.red);
    }
  }
}

class CheckSelectedClass {
  final int totalPrice;

  final List<CartProductModal> cartList;

  final List<CartProductModal> disableProductList;

  const CheckSelectedClass({required this.totalPrice, required this.cartList, required this.disableProductList});

  CheckSelectedClass copyWith({
    int? totalPriceX,
    List<CartProductModal>? cartListX,
    List<CartProductModal>? disableproductListX
  }) {
    return CheckSelectedClass(
      totalPrice: totalPriceX ?? totalPrice,
      cartList: cartListX ?? cartList,
      disableProductList: disableproductListX??disableProductList
    );
  }
}
