import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sneak_peak/models/address_modal.dart';
import 'package:sneak_peak/models/auth_modal.dart';
import 'package:sneak_peak/models/cart_poduct_modal.dart';
import 'package:sneak_peak/models/orders_modals.dart';
import 'package:sneak_peak/models/products_modals.dart';

class UserCloudDbServices {
  final FirebaseFirestore firestore;
final FirebaseStorage firebaseStorage;
  UserCloudDbServices({required this.firestore, required this.firebaseStorage});


Future<void> addUserImg(String uid, String imgUrl, String imgPath)async{
  var db = firestore.collection('users');
   await db.doc(uid).update({
          'userProfileImg': imgUrl,
          'userImgStoragePath': imgPath,
        });
}

Stream<List<OrdersModals>> toShipStream(String uid){
  var db= firestore.collection('users').doc(uid);
  return  db.collection('to_ship').snapshots().asyncMap((event) async{
    
    var list= event.docs.map((e) => OrdersModals.fromMap(e.data()),).toList();
    
   List<OrdersModals>? data= await Future.wait(list.map((e) async{
    List<CartProductModal> newList= [];
        for (var index in e.productsList!) {
          bool productExists= true;
       try {
          for (var element in index.img??[]) {
          var ref= firebaseStorage.refFromURL(element);
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
}

Stream<List<CartProductModal>> pendingOrdersStream(String uid){
var db = firestore.collection('users').doc(uid);
return  db
          .collection('pending_payment')
          .snapshots()
          .asyncMap(
            (event)async{
              var list=  event.docs
                    .map((e) => CartProductModal.fromMap(e.data()))
                    .toList();

                   var product= await Future.wait(list.map((e) async{
                     try {
                        for (var index in e.img??[]) {
                        var ref= FirebaseStorage.instance.refFromURL(index);
                        await ref.getDownloadURL();
                      }
                      return e;
                     } catch (error) {
                       return e.copyWith(isProductExist: false);
                     }
                      
                      },));

                      return product;

            } 
          );
}


Stream<List<CartProductModal>> cartProductsStream(String uid){
    var db = firestore.collection('users').doc(uid).collection('carts');
return  db.snapshots().asyncMap(
    (event) async{
      var list= event.docs.map((e) => CartProductModal.fromMap(e.data())).toList();

    var product=  await Future.wait(list.map((e) async{
        
        try {
          for (var element in e.img??[]) {
            var ref= firebaseStorage.refFromURL(element);
            await ref.getDownloadURL();

          }
          return e;

        } catch (error) {
         return e.copyWith(isProductExist: false);
        }

      },));
return product;
    }
        
  );
}

Future<Map<String, dynamic>> getUserFromDB(String uid)async{
  var db= firestore.collection('users');
  var snapshot= await db.doc(uid).get();
var data= snapshot.data() as Map<String, dynamic>;
return data;
}


Future<Map<String, dynamic>?> getAddress(String uid)async{
  var db= firestore.collection('users').doc(uid);
  var address= await db.collection('home_addresses').doc(uid).get();
var data= address.data();
return data;
}

Future<void> removeAddress(String uid)async{
  var db= firestore.collection('users').doc(uid);
  await db.collection('home_addresses').doc(uid).delete();
}

Future<void> saveAddress(String uid, AddressModal addressModel)async{
  var db= firestore.collection('users').doc(uid);
  await db.collection('home_addresses').doc(uid).set(addressModel.toMap(uid));
}


Future<void> buyProduct(String id,String uid ,OrdersModals orderModal )async{
  log(id);
  await firestore.collection('orders').doc(id).set(orderModal.toMap(uid, id));
  await firestore.collection('users').doc(uid).collection('to_ship').doc(id).set(orderModal.toMap(uid, id));
for (var element in orderModal.productsList!) {
   await firestore.collection('users').doc(uid).collection('carts').doc(element.id).delete();
}
}

Future<void> removeCancelOrder(String uid, CartProductModal cartModal )async{
  var db= firestore.collection('users').doc(uid);
  await db.collection('cancelled_orders').doc(cartModal.id).delete();
}

Future<void>cancelOrder(String uid,String id,List<CartProductModal> cartModelList)async{
  var userDb= firestore.collection('users').doc(uid);
  var orderDb= firestore.collection('orders');
  for (var cartModel in cartModelList) {
    await userDb.collection('cancelled_orders').doc(cartModel.id).set(cartModel.toMap(cartModel.id??'', cartModel.img??[], cartModel.storageImgsPath??[], cartModel.quantity??0, cartModel.originalPrice??0));
  }
  await userDb.collection('to_ship').doc(id).delete();
await orderDb.doc(id).delete();
}

Stream<List<CartProductModal>> cancelledProducts(String uid){
  var db = firestore.collection('users').doc(uid);
  return db.collection('cancelled_orders').snapshots().asyncMap((
        event,
      ) async {
        var list =
            event.docs.map((e) => CartProductModal.fromMap(e.data())).toList();

        var product = await Future.wait(
          list.map((e) async {
            try {
              for (var index in e.img ?? []) {
                var ref = firebaseStorage.refFromURL(index);
                await ref.getDownloadURL();
              }
              return e;
            } catch (error) {
              return e.copyWith(isProductExist: false);
            }
          }),
        );

        return product;
      });
}

Future<void> addToCartBtn(CartProductModal cartModel, String uid )async{
  var db = firestore.collection('users').doc(uid).collection('carts').doc(cartModel.id);
   await db.set(cartModel.toMap(cartModel.id!,cartModel.img ?? [],[],cartModel.quantity!,int.parse(cartModel.price.toString()),),);
}


Future<void> deleteCart(String uid, String id)async{
  var db= firestore.collection('users').doc(uid);
  await db.collection('carts').doc(id).delete();
}

Future<void> updateForProductExistance(String id, String uid, bool isExist)async{
  var db= firestore.collection('users').doc(uid);
  await db.collection('carts').doc(id).update({'isProductAvailaibe': isExist});
}

Stream<List<CartProductModal>> wishlistsStream(String uid){
  var db = firestore.collection('users').doc(uid);
  return db.collection('wishlists').snapshots().asyncMap((event) async {
        var list =
            event.docs.map((e) => CartProductModal.fromMap(e.data())).toList();

        var product = await Future.wait(
          list.map((e) async {
            try {
              for (var index in e.img ?? []) {
                var ref = firebaseStorage.refFromURL(index);
                await ref.getDownloadURL();
              }

              return e;
            } catch (error) {
              return e.copyWith(isProductExist: false);
            }
          }),
        );

        return product;
      });
}

Stream<List<ProductModal>> getProductByBrand(String brand){
  var db = firestore.collection('products');
 if (brand == '') {
    return db.snapshots().map(
      (event) => event.docs.map((e) => ProductModal.fromMap(e.data())).toList(),
    );
  } else {
    return db
        .where('brand', isEqualTo: brand)
        .snapshots()
        .map(
          (event) =>
              event.docs.map((e) => ProductModal.fromMap(e.data())).toList(),
        );
  }
}

Future<void> addToPendingPayments(String uid, CartProductModal cartModel)async{
  var db = firestore.collection('users').doc(uid);
   await db.collection('pending_payment').doc(cartModel.id).set(cartModel.toMapFromPendingPayment(cartModel.id!, cartModel.img!, []));
}

Future<void> deletePendingOrderAndThenAddToCancelOrders(String uid, CartProductModal cartModel )async{
  var db = firestore.collection('users').doc(uid);
  await db.collection('cancelled_orders').doc(cartModel.id).set(cartModel.toMap(cartModel.id??'', cartModel.img??[], [],int.parse(cartModel.quantity.toString()) , int.parse(cartModel.price.toString())));
  await db.collection('pending_payment').doc(cartModel.id).delete();
}


Future<void> productQuantityBtnInCart(String uid, String id,int price, int currentQuantity, bool isIncrement)async{
   var db = firestore.collection('users').doc(uid).collection('carts');
  if (isIncrement) {
    if (currentQuantity < 5) {
     var data = await db.doc(id).get();
        int originalPrice = data['original_price'];
        int number = currentQuantity + 1;
        String newPrice = (price + originalPrice).toString();
        await db.doc(id).update({'quantity': number, 'price': newPrice});}
  }else{
    if (currentQuantity > 1) {
       var data = await db.doc(id).get();
        int originalPrice = data['original_price'];
        int number = currentQuantity - 1;
        int x = price - originalPrice;
        String newPrice = x.toString();
        await db.doc(id).update({'quantity': number, 'price': newPrice});
    }

  }
}


Future<void> addToWishlist(String uid, bool isFav, ProductModal productModal )async{
  var db = firestore.collection('users');
  if (isFav) {
     await db.doc(uid).collection('wishlists').doc(productModal.id).set(productModal.toMapForUser(productModal.id.toString(), productModal.img??[], []),);
  }else{
    await db.doc(uid).collection('wishlists').doc(productModal.id).delete();
  }
}

Future<void> removeFromWishlist(String uid, CartProductModal cartModel )async{
  var db= FirebaseFirestore.instance.collection('users').doc(uid);
  await db.collection('wishlists').doc(cartModel.id).delete();
}


// -----------------FOR auth side-----------------------
  Future<void> createAccount(AuthModal authModal, String uid) async {
    await firestore.collection('users').doc(uid).set(authModal.toMap(uid));
  }

  Future<void> updateName(String uid, String newName) async {
    await firestore.collection('users').doc(uid).update({'name': newName});
  }

  Future<void> updateEmail(String newEmail, String uid) async {
    await firestore.collection('users').doc(uid).update({
      'pending_email': newEmail,
    });
  }

  Future<void> syncEmailAfterVerification(String uid, String email) async {
    await firestore.collection('users').doc(uid).update({
      'email': email,
      'pending_email': FieldValue.delete(),
    });
  }
}
