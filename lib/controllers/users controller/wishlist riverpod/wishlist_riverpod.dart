import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/cart_poduct_modal.dart';
import 'package:sneak_peak/models/products_modals.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';


final wishlistProvider =
    StateNotifierProvider.family<WishlistStateNotifier, bool, String>((
      ref,
      dataTitle,
    ) {
      return WishlistStateNotifier();
    });

class WishlistStateNotifier extends StateNotifier<bool> {
  WishlistStateNotifier() : super(false);



  Future<void> addToWishlist(ProductModal productModal,BuildContext context ) async {
    var db = FirebaseFirestore.instance.collection('users');
    var auth = FirebaseAuth.instance.currentUser;
    
    state = !state;
    try {
      if (state) {
       
        loadingDialog(context, 'Adding to wishlist...');
        
        
        await db
            .doc(auth!.uid)
            .collection('wishlists')
            .doc(productModal.id)
            .set(
              productModal.toMapForUser(productModal.id.toString(), productModal.img??[], []),
            );
Navigator.pop(context);
      } else {
        loadingDialog(context, 'Removing from wishlist');
        var userDb = db
            .doc(auth!.uid)
            .collection('wishlists')
            .doc(productModal.id);
        

        await userDb.delete();
        Navigator.pop(context);
      }
    } catch (e) {
      Navigator.pop(context);
      SnackBarHelper.show(e.toString(), color: Colors.red);
    }
  }



  Future<void> removeFromWishlist(CartProductModal cartModal, BuildContext context)async{
    var auth = FirebaseAuth.instance.currentUser;
var db= FirebaseFirestore.instance.collection('users').doc(auth!.uid);

loadingDialog(context, 'Removing from wishlist');
try {


await db.collection('wishlists').doc(cartModal.id).delete();
  
Navigator.pop(context);

}on FirebaseException catch (e) {
  Navigator.pop(context);
  SnackBarHelper.show(e.code, color: Colors.red);
}


  }


  Future<void> isFav(bool isTrue)async{
state= isTrue;
  }



  Future<void> setToFalse()async{
state = true;

  }
}
