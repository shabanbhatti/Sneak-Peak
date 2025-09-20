import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/cart_poduct_modal.dart';
import 'package:sneak_peak/models/products_modals.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';

final cartProvider =
    StateNotifierProvider<CartNotifier, String>((ref) {
      return CartNotifier();
    });

class CartNotifier extends StateNotifier<String> {
  CartNotifier() : super('');

  Future<void> addToCartBtnClick(
    ProductModal productModal,
    BuildContext context,
  ) async {
    var auth = FirebaseAuth.instance.currentUser;
    var db = FirebaseFirestore.instance.collection('users').doc(auth!.uid);
    
    state = 'loading';
    loadingDialog(context, 'Adding to cart...');
    try {
      var cartModal = CartProductModal(
        id: productModal.id,
        brand: productModal.brand,
        colors: productModal.colors,
        description: productModal.description,
        genders: productModal.genders,
        price: productModal.price,
        img: productModal.img,
        quantity: 1,
        storageImgsPath: productModal.storageImgsPath,
        title: productModal.title,
        shoesSizes: productModal.shoesSizes,
        reviews: productModal.reviews,
        totalRatedUser: productModal.totalRatedUser
      );

      await db
          .collection('carts')
          .doc(cartModal.id)
          .set(
            cartModal.toMap(
              cartModal.id!,
              cartModal.img ?? [],
              [],
              cartModal.quantity!,
              int.parse(cartModal.price.toString()),
            ),
          );
      state = 'successful';
      SnackBarHelper.show('Add to cart successfuly');
      Navigator.pop(context);
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      Navigator.pop(context);
      SnackBarHelper.show('$e');
    }
  }


  Future<void> updateForExistance(String id, bool isExist)async{
var auth= FirebaseAuth.instance.currentUser;
var db= FirebaseFirestore.instance.collection('users').doc(auth!.uid);

try {
  
await db.collection('carts').doc(id).update({
  'isProductAvailaibe': isExist
});

} on FirebaseException catch (e) {
  SnackBarHelper.show(e.code, color: Colors.red);
}


  }

Future<void> deleteCart(BuildContext context, String id )async{
var auth = FirebaseAuth.instance.currentUser;
var db= FirebaseFirestore.instance.collection('users').doc(auth!.uid);
loadingDialog(context, 'Deleting...');
try {
  
await db.collection('carts').doc(id).delete();

Navigator.pop(context);

}on FirebaseException catch (e) {
  Navigator.pop(context);
  SnackBarHelper.show(e.code, color: Colors.red);
}

}


}
