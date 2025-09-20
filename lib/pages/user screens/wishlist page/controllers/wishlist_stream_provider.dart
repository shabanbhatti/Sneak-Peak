import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/cart_poduct_modal.dart';

final wishlistStreamProvider =
    StreamProvider.family<List<CartProductModal>, String>((ref, uid) {
      var db = FirebaseFirestore.instance.collection('users').doc(uid);
      return db
          .collection('wishlists')
          .snapshots()
          .asyncMap(
            (event)async{
var list=  event.docs
                    .map((e) => CartProductModal.fromMap(e.data()))
                    .toList();

var product= await Future.wait(list.map((e)async {
  try {
      for (var index in e.img??[]) {
    var ref= FirebaseStorage.instance.refFromURL(index);
      await ref.getDownloadURL();
  }
      
      return e;
    } catch (error) {
      return e.copyWith(isProductExist: false);
    }

},
));

return  product;

            }
               
          );
    });
