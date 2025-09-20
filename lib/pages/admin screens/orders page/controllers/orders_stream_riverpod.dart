import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/cart_poduct_modal.dart';
import 'package:sneak_peak/models/orders_modals.dart';


final adminOrdersStreamProvider = StreamProvider.autoDispose<List<OrdersModals>>((ref) {
  var db= FirebaseFirestore.instance.collection('orders');
  return db.snapshots().asyncMap((event)async {
    
    List<OrdersModals> list= event.docs.map((e) => OrdersModals.fromMap(e.data()),).toList();

var data= await Future.wait(list.map((e) async{
  List<CartProductModal> l= [];
  for (var cartModel in e.productsList!) {
    bool isExist= true;
   try {
      for (var index in cartModel.img??[]) {
      
        var ref= FirebaseStorage.instance.refFromURL(index);
      await ref.getDownloadURL();
      isExist=true;
    }
   } catch (e) {
     isExist=false;
   }
   l.add(cartModel.copyWith(isProductExist: isExist));

  }
  return e.copyWith(productsList: l);
},));

return data;
  },);
});