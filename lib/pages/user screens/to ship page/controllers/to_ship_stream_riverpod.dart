import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/cart_poduct_modal.dart';
import 'package:sneak_peak/models/orders_modals.dart';

final toShipStreamProvider = StreamProvider.family<List<OrdersModals>, String>((ref, uid) {
  var db= FirebaseFirestore.instance.collection('users').doc(uid);
  return db.collection('to_ship').snapshots().asyncMap((event) async{
    
    var list= event.docs.map((e) => OrdersModals.fromMap(e.data()),).toList();
    
   List<OrdersModals>? data= await Future.wait(list.map((e) async{
    List<CartProductModal> newList= [];
        for (var index in e.productsList!) {
          bool productExists= true;
       try {
          for (var element in index.img??[]) {
          var ref= FirebaseStorage.instance.refFromURL(element);
          await ref.getDownloadURL();
        }
         
       } catch (e) {
        productExists=false;
        // break;
       }
       newList.add(index.copyWith(isProductExist: productExists));
      }
      print('$newList----------((((((((((()))))))))))');
     return e.copyWith(productsList: newList);
      
    },));
    // log('${data[0].productsList}');
return data;
  },);
});