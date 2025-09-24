import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sneak_peak/models/address_modal.dart';
import 'package:sneak_peak/models/cart_poduct_modal.dart';
import 'package:sneak_peak/models/orders_modals.dart';
import 'package:sneak_peak/models/products_modals.dart';
import 'package:sneak_peak/services/auth%20service/auth_service.dart';
import 'package:sneak_peak/services/shared%20pref%20service/shared_pref_service.dart';
import 'package:sneak_peak/services/user%20services/user_cloud_DB_services.dart';
import 'package:sneak_peak/services/user%20services/user_storage_service.dart';
import 'package:sneak_peak/utils/constant_imgs.dart';

class UserCloudDbRepository {
  final AuthService authService;
  final UserCloudDbServices userDbServices;
  final UserStorageService userStrgService;

  UserCloudDbRepository({
    required this.authService,
    required this.userDbServices,
    required this.userStrgService,
  });

  Future<String> addUserImage(File imgFile) async {
    String uid = authService.firebaseAuth.currentUser!.uid;
    try {
      var data = await userStrgService.addUserImage(imgFile, uid);
      await userDbServices.addUserImg(uid, data.imgUrl, data.imgPath);
      await SPHelper.setString(SPHelper.userImg, data.imgUrl);
      return data.imgUrl;
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

Future<void> buyProduct(OrdersModals orderModel )async{
  String id = DateTime.now().microsecondsSinceEpoch.toString();
  String uid = authService.firebaseAuth.currentUser!.uid;
  try {
    await userDbServices.buyProduct(id, uid, orderModel);
  }on FirebaseException catch (e) {
    throw Exception(e.code);
  }
}
Future<void> removerCancelOrder(CartProductModal cartModal )async{
  String uid = authService.firebaseAuth.currentUser!.uid;
  try {
    await userDbServices.removeCancelOrder(uid, cartModal);
  }on FirebaseException catch (e) {
    throw Exception(e.code);
  }
}


Future<void> addToCartBtn( CartProductModal cartModel )async{
  String uid = authService.firebaseAuth.currentUser!.uid;
  try {
    await userDbServices.addToCartBtn(cartModel, uid);
  }on FirebaseException catch (e) {
    throw Exception(e.code);
  }
}

Future<void> deleteCart(String id)async{
  String uid = authService.firebaseAuth.currentUser!.uid;
  try {
    await userDbServices.deleteCart(uid, id);
  }on FirebaseException catch (e) {
    throw Exception(e.code);
  }
}



Stream<List<CartProductModal>> cartProductsStream(){
  String uid = authService.firebaseAuth.currentUser!.uid;
  try {
    return userDbServices.cartProductsStream(uid);
  }on FirebaseException catch (e) {
    throw Exception(e.code);
  }
}

Stream<List<CartProductModal>> pendingOrdersStream(){
  String uid = authService.firebaseAuth.currentUser!.uid;
  try {
    return userDbServices.pendingOrdersStream(uid);
  }on FirebaseException catch (e) {
    throw Exception(e.code);
  }
}

Stream<List<OrdersModals>> toShipStream(){
  String uid = authService.firebaseAuth.currentUser!.uid;
  try {
    return userDbServices.toShipStream(uid);
  }on FirebaseException catch (e) {
    throw Exception(e.code);
  }
}
Future<void> deletePendingOrderAndThenAddToCancelOrders(CartProductModal cartModel )async{
  try {
    String uid = authService.firebaseAuth.currentUser!.uid;
    await userDbServices.deletePendingOrderAndThenAddToCancelOrders(uid, cartModel);
  }on FirebaseException catch (e) {
    throw Exception(e.code);
  }
}

Future<void> addToPendingPayments(List<CartProductModal> cartModelList)async{
try {
  String uid = authService.firebaseAuth.currentUser!.uid;
  for (var index in cartModelList) {
    await userDbServices.addToPendingPayments(uid, index);
  }
}on FirebaseException catch (e) {
  throw Exception(e.code);
}
}

Stream<List<CartProductModal>> wishlistStream(){
  String uid = authService.firebaseAuth.currentUser!.uid;
  try {
    return userDbServices.wishlistsStream(uid);
  }on FirebaseException catch (e) {
    throw Exception(e.code);
  }
}

Future<void> cancelorder(String id ,List<CartProductModal> cartList)async{
  String uid = authService.firebaseAuth.currentUser!.uid;
try{
await userDbServices.cancelOrder(uid, id, cartList);  
}on FirebaseException catch(e){
  throw Exception(e.code);
}
}

Stream<List<ProductModal>> getProductByBrand(String brand){
  try {
    return userDbServices.getProductByBrand(brand);
  }on FirebaseException catch (e) {
    throw Exception(e.code);
  }
}

Future<void> updateForExistance(bool isExist, String id)async{
  try {
    String uid = authService.firebaseAuth.currentUser!.uid;
    await userDbServices.updateForProductExistance(id, uid, isExist);
  }on FirebaseException catch (e) {
    throw Exception(e.code);
  }
}

Future<void> productQuantityBtnInCart(String id, int price, int currentQuantity, bool isIncrement)async{
  try {
    String uid = authService.firebaseAuth.currentUser!.uid;
    await userDbServices.productQuantityBtnInCart(uid, id, price, currentQuantity, isIncrement);
  }on FirebaseException catch (e) {
    throw Exception(e.code);
  }
}

Future<void> addToWishlist(bool isFav, ProductModal productModal)async{
  try {
    String uid = authService.firebaseAuth.currentUser!.uid;
    await userDbServices.addToWishlist(uid, isFav, productModal);
  }on FirebaseException catch (e) {
    throw Exception(e.code);
  }
}
Future<void> removeFromWishlist(CartProductModal cartModel )async{
  try {
    String uid = authService.firebaseAuth.currentUser!.uid;
    await userDbServices.removeFromWishlist(uid, cartModel);
  }on FirebaseException catch (e) {
    throw Exception(e.code);
  }
}

Stream<List<CartProductModal>> cancelledProducts(){
  try {
    String uid = authService.firebaseAuth.currentUser!.uid;
    return userDbServices.cancelledProducts(uid);
  }on FirebaseException catch (e) {
    throw Exception(e.code);
  }
}
  Future<Map<String, dynamic>?> getAddress({String? userUid})async{
    String uid = authService.firebaseAuth.currentUser!.uid;
    try {
      if (userUid==null) {
        var data= await userDbServices.getAddress(uid);
        return data;
      }else{
        var userAddressData= await userDbServices.getAddress(userUid);
        log('$userAddressData');
        return userAddressData;
      }
     
    }on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> removeAddress()async{
    String uid = authService.firebaseAuth.currentUser!.uid;
    try {
      await userDbServices.removeAddress(uid);
    }on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> saveAddress(AddressModal addressModel)async{
    String uid = authService.firebaseAuth.currentUser!.uid;
    try {
      await userDbServices.saveAddress(uid, addressModel);
    }on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<String> getUserFromDB() async {
    String uid = authService.firebaseAuth.currentUser!.uid;
    try {
      var data = await userDbServices.getUserFromDB(uid);
      String imgUrl = await SPHelper.getString(SPHelper.userImg);

      if (imgUrl == '') {
        if (data.containsKey('userProfileImg')) {
          String firebaseImgUrl = data['userProfileImg'];

          await SPHelper.setString(SPHelper.userImg, firebaseImgUrl);
          return firebaseImgUrl;
        } else {
          return profileIconUrl;
        }
      } else {
        return imgUrl;
      }
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }
}
