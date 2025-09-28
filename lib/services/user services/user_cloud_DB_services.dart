import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sneak_peak/models/address_modal.dart';
import 'package:sneak_peak/models/auth_modal.dart';
import 'package:sneak_peak/models/cart_poduct_modal.dart';
import 'package:sneak_peak/models/notifications_model.dart';
import 'package:sneak_peak/models/orders_modals.dart';
import 'package:sneak_peak/models/products_modals.dart';

class UserCloudDbServices {
  final FirebaseFirestore firestore;
  final FirebaseStorage firebaseStorage;
  UserCloudDbServices({required this.firestore, required this.firebaseStorage});

  Future<void> addUserImg(String uid, String imgUrl, String imgPath) async {
    var db = firestore.collection('users');
    await db.doc(uid).update({
      'userProfileImg': imgUrl,
      'userImgStoragePath': imgPath,
    });
  }

Future<List<({String uid, String token})>> getAllUsersFcmTokenAndUid() async {
  var db = firestore.collection('users');
  var get = await db.get();
  var docs = get.docs;

  List<({String uid, String token})> users = [];

  for (var doc in docs) {
    
    if (doc.data().containsKey('fcm_token')) {
    String token = doc['fcm_token'] ?? '';  
    String uid = doc['uid'] ?? '';
      if (token.isNotEmpty && uid.isNotEmpty) {
      users.add((uid: uid, token: token));
    }
    }
  }
  return users;
}

Future<String> getUserImgPath(String uid)async{
  var db= firestore.collection('users').doc(uid);
  var get=await db.get();
  var data= get.data()??{};
  String path='';
  if (data.containsKey('userImgStoragePath')) {
    path= data['userImgStoragePath']??'';
  }
  return path;
}

Future<void> deleteAccount(String uid)async{
  await firestore.collection('users').doc(uid).delete();
}

  Future<String> getFcmToken(String uid) async {
    var doc = firestore.collection('users').doc(uid);
    var getUser = await doc.get();
    String fcmToken = getUser['fcm_token'] ?? '';
    return fcmToken;
  }

Future<void> deleteFcmToken(String uid)async{
  var doc = firestore.collection('users').doc(uid);
  doc.update({
'fcm_token':FieldValue.delete()
  });
}

  Future<void> addNotifications(
    String uid,
    int id,
    NotificationsModel notificationModel,
  ) async {
    var db = firestore.collection('users').doc(uid);
    await db
        .collection('notifications')
        .doc(id.toString())
        .set(notificationModel.toMap(id));
  }

  Future<void> deleteNotification(String uid, String id) async {
    var db = firestore.collection('users').doc(uid);
    await db.collection('notifications').doc(id.toString()).delete();
  }

  Future<void> deleteAllNotifications(String uid) async {
    var db = firestore.collection('users').doc(uid).collection('notifications');
    var get = await db.get();
    for (var value in get.docs) {
      await value.reference.delete();
    }
    
  }

  Stream<List<OrdersModals>> toShipStream(String uid) {
    var db = firestore.collection('users').doc(uid);
    return db.collection('to_ship').snapshots().asyncMap((event) async {
      var list = event.docs.map((e) => OrdersModals.fromMap(e.data())).toList();

      List<OrdersModals>? data = await Future.wait(
        list.map((e) async {
          List<CartProductModal> newList = [];
          for (var index in e.productsList!) {
            bool productExists = true;
            try {
              for (var element in index.img ?? []) {
                var ref = firebaseStorage.refFromURL(element);
                await ref.getDownloadURL();
              }
            } catch (e) {
              productExists = false;
              // break;
            }
            newList.add(index.copyWith(isProductExist: productExists));
          }
          print('$newList----------((((((((((()))))))))))');
          return e.copyWith(productsList: newList);
        }),
      );
      // log('${data[0].productsList}');
      return data;
    });
  }

  Stream<List<NotificationsModel>> getNotifications(String uid) {
    var db = firestore.collection('users').doc(uid).collection('notifications');
    return db.snapshots().map((event) {
      return event.docs
          .map((e) => NotificationsModel.fromMap(e.data()))
          .toList();
    });
  }

  Stream<List<CartProductModal>> pendingOrdersStream(String uid) {
    var db = firestore.collection('users').doc(uid);
    return db.collection('pending_payment').snapshots().asyncMap((event) async {
      var list =
          event.docs.map((e) => CartProductModal.fromMap(e.data())).toList();

      var product = await Future.wait(
        list.map((e) async {
          try {
            for (var index in e.img ?? []) {
              var ref = FirebaseStorage.instance.refFromURL(index);
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

  Stream<List<CartProductModal>> cartProductsStream(String uid) {
    var db = firestore.collection('users').doc(uid).collection('carts');
    return db.snapshots().asyncMap((event) async {
      var list =
          event.docs.map((e) => CartProductModal.fromMap(e.data())).toList();

      var product = await Future.wait(
        list.map((e) async {
          try {
            for (var element in e.img ?? []) {
              var ref = firebaseStorage.refFromURL(element);
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

  Future<Map<String, dynamic>> getUserFromDB(String uid) async {
    var db = firestore.collection('users');
    var snapshot = await db.doc(uid).get();
    var data = snapshot.data() as Map<String, dynamic>;
    return data;
  }

  Future<String> getImgPath(String uid)async{
    var db = firestore.collection('users');
    var snapshot = await db.doc(uid).get();
    var data = snapshot.data()??{};
    return data['userImgStoragePath']??'';
  }

  Future<void> deleteUserImg(String uid)async{
    var db = firestore.collection('users');
   await db.doc(uid).update({
'userProfileImg':FieldValue.delete(),
'userImgStoragePath':FieldValue.delete(),
    });
  }

  Future<Map<String, dynamic>?> getAddress(String uid) async {
    var db = firestore.collection('users').doc(uid);
    var address = await db.collection('home_addresses').doc(uid).get();
    var data = address.data();
    return data;
  }

  Future<void> removeAddress(String uid) async {
    var db = firestore.collection('users').doc(uid);
    await db.collection('home_addresses').doc(uid).delete();
  }

  Future<void> saveAddress(String uid, AddressModal addressModel) async {
    var db = firestore.collection('users').doc(uid);
    await db.collection('home_addresses').doc(uid).set(addressModel.toMap(uid));
  }

  Future<void> buyProduct(
    String id,
    String uid,
    OrdersModals orderModal,
  ) async {
    await firestore.collection('orders').doc(id).set(orderModal.toMap(uid, id));
    await firestore
        .collection('users')
        .doc(uid)
        .collection('to_ship')
        .doc(id)
        .set(orderModal.toMap(uid, id));
    for (var element in orderModal.productsList!) {
      await firestore
          .collection('users')
          .doc(uid)
          .collection('carts')
          .doc(element.id)
          .delete();
    }
  }

  Future<void> removeCancelOrder(String uid, CartProductModal cartModal) async {
    var db = firestore.collection('users').doc(uid);
    await db.collection('cancelled_orders').doc(cartModal.id).delete();
  }

  Future<void> cancelOrder(
    String uid,
    String id,
    List<CartProductModal> cartModelList,
  ) async {
    var userDb = firestore.collection('users').doc(uid);
    var orderDb = firestore.collection('orders');
    for (var cartModel in cartModelList) {
      await userDb
          .collection('cancelled_orders')
          .doc(cartModel.id)
          .set(
            cartModel.toMap(
              cartModel.id ?? '',
              cartModel.img ?? [],
              cartModel.storageImgsPath ?? [],
              cartModel.quantity ?? 0,
              cartModel.originalPrice ?? 0,
            ),
          );
    }
    await userDb.collection('to_ship').doc(id).delete();
    await orderDb.doc(id).delete();
  }

  Stream<List<CartProductModal>> cancelledProducts(String uid) {
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

  Future<void> addToCartBtn(CartProductModal cartModel, String uid) async {
    var db = firestore
        .collection('users')
        .doc(uid)
        .collection('carts')
        .doc(cartModel.id);
    await db.set(
      cartModel.toMap(
        cartModel.id!,
        cartModel.img ?? [],
        [],
        cartModel.quantity!,
        int.parse(cartModel.price.toString()),
      ),
    );
  }

  Future<void> deleteCart(String uid, String id) async {
    var db = firestore.collection('users').doc(uid);
    await db.collection('carts').doc(id).delete();
  }

  Future<void> updateForProductExistance(
    String id,
    String uid,
    bool isExist,
  ) async {
    var db = firestore.collection('users').doc(uid);
    await db.collection('carts').doc(id).update({
      'isProductAvailaibe': isExist,
    });
  }

  Stream<List<CartProductModal>> wishlistsStream(String uid) {
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

  Stream<double> reviewStream(String uid, String id, String productId) {
    var db = firestore.collection('users').doc(uid).collection('to_ship');
    return db.doc(id).snapshots().map((event) {
      var data = event.data() ?? {};
      List<dynamic> value = data['products'] ?? [];
      var list = value.where((element) => element['id'] == productId).toList();
      var dataList = list[0]['reviews'] ?? {};
      var reviews = dataList[uid];
      return reviews ?? 0.0;
    });
  }

  Future<void> addReviews(
    String uid,
    double ratingByUser,
    String productId,
    OrdersModals orderModel,
  ) async {
    var db = firestore.collection('products');
    var userDb = firestore.collection('users');
    var get = await db.doc(productId).get();
    var data = get.data() ?? {};
    double totalRatingSum = data['totalRatingSum'] ?? 0.0;
    int totalUsersRated = (data['totalUsersRated'] ?? 0).toInt();
    Map<String, dynamic> reviews = data['reviews'] ?? {};
    bool userHasRated = reviews.containsKey(uid);
    double oldUserRating = userHasRated ? reviews[uid] : 0.0;

    if (userHasRated) {
      totalRatingSum = totalRatingSum - oldUserRating + ratingByUser;
      reviews[uid] = ratingByUser;
    } else {
      totalRatingSum += ratingByUser;
      totalUsersRated += 1;
      reviews[uid] = ratingByUser;
    }

    double averageRating =
        (totalUsersRated > 0) ? totalRatingSum / totalUsersRated : 0.0;

    await db.doc(productId).update({
      'totalRatingSum': totalRatingSum,
      'totalUsersRated': totalUsersRated,
      'averageRating': averageRating,
      'reviews': reviews,
    });

    var getUser =
        await userDb.doc(uid).collection('to_ship').doc(orderModel.id).get();
    var userData = getUser.data() ?? {};
    List<Map<String, dynamic>> list = List.from(userData['products'] ?? []);

    List<Map<String, dynamic>> newList = [];
    for (var element in list) {
      if (element['id'] == productId) {
        newList.add({
          ...element,
          'totalRatingSum': totalRatingSum,
          'totalUsersRated': totalUsersRated,
          'averageRating': averageRating,
          'reviews': reviews,
        });
      } else {
        newList.add(element);
      }
    }

    await userDb.doc(uid).collection('to_ship').doc(orderModel.id).update({
      'products': newList,
    });
  }

  Stream<List<ProductModal>> getProductByBrand(String brand) {
    var db = firestore.collection('products');
    if (brand == '') {
      return db.snapshots().map(
        (event) =>
            event.docs.map((e) => ProductModal.fromMap(e.data())).toList(),
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

  Future<void> addToPendingPayments(
    String uid,
    CartProductModal cartModel,
  ) async {
    var db = firestore.collection('users').doc(uid);
    await db
        .collection('pending_payment')
        .doc(cartModel.id)
        .set(
          cartModel.toMapFromPendingPayment(cartModel.id!, cartModel.img!, []),
        );
  }

  Future<void> deletePendingOrderAndThenAddToCancelOrders(
    String uid,
    CartProductModal cartModel,
  ) async {
    var db = firestore.collection('users').doc(uid);
    await db
        .collection('cancelled_orders')
        .doc(cartModel.id)
        .set(
          cartModel.toMap(
            cartModel.id ?? '',
            cartModel.img ?? [],
            [],
            int.parse(cartModel.quantity.toString()),
            int.parse(cartModel.price.toString()),
          ),
        );
    await db.collection('pending_payment').doc(cartModel.id).delete();
  }

  Future<void> productQuantityBtnInCart(
    String uid,
    String id,
    int price,
    int currentQuantity,
    bool isIncrement,
  ) async {
    var db = firestore.collection('users').doc(uid).collection('carts');
    if (isIncrement) {
      if (currentQuantity < 5) {
        var data = await db.doc(id).get();
        int originalPrice = data['original_price'];
        int number = currentQuantity + 1;
        String newPrice = (price + originalPrice).toString();
        await db.doc(id).update({'quantity': number, 'price': newPrice});
      }
    } else {
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

  Future<void> addToWishlist(
    String uid,
    bool isFav,
    ProductModal productModal,
  ) async {
    var db = firestore.collection('users');
    if (isFav) {
      await db
          .doc(uid)
          .collection('wishlists')
          .doc(productModal.id)
          .set(
            productModal.toMapForUser(
              productModal.id.toString(),
              productModal.img ?? [],
              [],
            ),
          );
    } else {
      await db.doc(uid).collection('wishlists').doc(productModal.id).delete();
    }
  }

  Future<void> removeFromWishlist(
    String uid,
    CartProductModal cartModel,
  ) async {
    var db = FirebaseFirestore.instance.collection('users').doc(uid);
    await db.collection('wishlists').doc(cartModel.id).delete();
  }

  // -----------------FOR auth side-----------------------
Future<({String name, String email})> getEmailAndName(String uid)async{
  var db= firestore.collection('users').doc(uid);
  var get= await db.get();
  var data= get.data()??{};
  String name='';
  String email='';
  if (data.containsKey('name')&&data.containsKey('email')) {
    name= data['name']??'';
    email=data['email']??'';
  }
  return (name: name, email: email);
}

  Future<void> updateFcmToken(String uid, String fcmToken) async {
    await firestore.collection('users').doc(uid).update({
      'fcm_token': fcmToken,
    });
  }

  Future<void> logout(String uid) async {
    await firestore.collection('users').doc(uid).update({
      'fcm_token': FieldValue.delete(),
    });
  }

  Future<void> createAccount(AuthModal authModal, String uid) async {
    await firestore.collection('users').doc(uid).set(authModal.toMapWithoutFCMToken(uid));
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
