import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sneak_peak/models/caraousels_banners_model.dart';
import 'package:sneak_peak/models/cart_poduct_modal.dart';
import 'package:sneak_peak/models/orders_modals.dart';
import 'package:sneak_peak/models/products_modals.dart';
import 'package:sneak_peak/utils/constant_brands.dart';
import 'package:sneak_peak/utils/constant_steps.dart';

class ProductsService {

final FirebaseFirestore firebaseFirestore;
final FirebaseStorage firebaseStorage;

ProductsService({required this.firebaseFirestore, required this.firebaseStorage});

Future<void> addProduct(ProductModal productModal, List<String> imgList, List<String> imgPaths)async{

var db= firebaseFirestore.collection('products');

var id= DateTime.now().microsecondsSinceEpoch.toString();
await db.doc(id).set(productModal.toMap(id,imgList, imgPaths ));


}


Future<void> updateProductsImage(String id,List<String> imgUrls, List<String> imgPaths )async{
await firebaseFirestore.collection('products').doc(id).update({
          'images': imgUrls,
          'storage_imgs_paths': imgPaths,
        });

}

Stream<String> orderDeliveryStatus(String id){
  var db= firebaseFirestore.collection('orders').doc(id);
return  db.snapshots().map((event) {
    var data= event.data()??{};
    return data['deliveryStatus'];
  },);
}

Future<void> updateProduct(ProductModal productModal)async{

var db = firebaseFirestore.collection('products');

await db.doc(productModal.id).update(productModal.toMapForUpdate(productModal.id!));

}




Future<void> deleteProduct(String productId)async{
var db = firebaseFirestore.collection('products');
await db.doc(productId).delete();
}


Future<void> addBanners(String id, String imgUrl, String imgPath)async{
var db= firebaseFirestore.collection('banners');
db.doc(id).set({
       'bannerImages': imgUrl,
      'bannerImagesPathsID':imgPath,
      'id':id
    });
}

Stream<String> stepsStream(String id){
  var db = firebaseFirestore.collection('orders').doc(id);
  return db.snapshots().map((event) {
    var data = event.data() ?? {};
    return data['deliveryStatus'];
  });
}


Stream<List<CaraouselsBannersModel>> bannersStream(){
  var db = firebaseFirestore.collection('banners');
return db.snapshots().map(
    (event) =>
        event.docs
            .map((e) => CaraouselsBannersModel.fromMap(e.data()))
            .toList(),
  );
}


Future<void> updateSteps(OrdersModals orderModel,String step ,String uid,)async{
var userDb = firebaseFirestore.collection('users').doc(uid);
var orderDb = firebaseFirestore.collection('orders').doc(orderModel.id);
 await userDb.collection('to_ship').doc(orderModel.id).update({'deliveryStatus':step });
  await orderDb.update({'deliveryStatus':step});
  if (step==delivered) {
      for (var index in orderModel.productsList!) {
              var get= await firebaseFirestore.collection('products').doc(index.id).get();
              var data= get.data()??{};
              var solds= data['solds']??0;
              int totalSolds= solds+1;
               await firebaseFirestore.collection('products').doc(index.id).update({'solds':totalSolds});
            }
  }
}

Future<void> deleteBanner(String id)async{
var db= firebaseFirestore.collection('banners');
await db.doc(id).delete();
}


Stream<List<ProductModal>> getProductsStream(){
  return  firebaseFirestore
      .collection('products')
      .snapshots()
      .map(
        (event) =>
            event.docs.map((e) => ProductModal.fromMap(e.data(), )).toList(),
      );
}

Stream<ProductModal> productModelStream(String id){
  return  firebaseFirestore
      .collection('products')
      .doc(id)
      .snapshots()
      .map((event) {
        final data = event.data();
        
        return ProductModal.fromMap(data!);
      });
}

Stream<List<OrdersModals>> ordersStream(){
  var db= firebaseFirestore.collection('orders');
  return db.snapshots().asyncMap((event)async {
    
    List<OrdersModals> list= event.docs.map((e) => OrdersModals.fromMap(e.data()),).toList();

var data= await Future.wait(list.map((e) async{
  List<CartProductModal> cartList= [];
  for (var cartModel in e.productsList!) {
    bool isExist= true;
   try {
      for (var index in cartModel.img??[]) {
      
        var ref= firebaseStorage.refFromURL(index);
      await ref.getDownloadURL();
      isExist=true;
    }
   } catch (e) {
     isExist=false;
   }
   cartList.add(cartModel.copyWith(isProductExist: isExist));

  }
  return e.copyWith(productsList: cartList);
},));

return data;
  },);

}

Future<Map<String, dynamic>> getFlChartDataByBrand(String brand)async{
  var db= firebaseFirestore.collection('total_solds');
var ndureGet=await db.doc(brand).get();
return ndureGet.data()??{};
}

Future<void> initializeFlChart()async{
  var productsDb= firebaseFirestore.collection('products');
var totalSold= firebaseFirestore.collection('total_solds');
var get=await productsDb.get();
var data= get.docs;
int ndureSolds=0;
int styloSolds=0;
int bataSolds= 0;
int servisSolds=0;
for (var element in data) {
var brand= element['brand'].toString();
if (brand==ndure) {
  log('ndure---');
int solds= element['solds']??0;
ndureSolds+=solds;
await totalSold.doc(ndure).set({'total_solds': ndureSolds});
}else if (brand==stylo) {
  log('stylo---');
int solds= element['solds']??0;
styloSolds+=solds;
await totalSold.doc(stylo).set({'total_solds': styloSolds});
}else if (brand==bata) {
  log('bata---');
int solds= element['solds']??0;
bataSolds+=solds;
await totalSold.doc(bata).set({'total_solds': bataSolds});
}else if(brand==servis){
  log('servis---');
int solds= element['solds']??0;
servisSolds+=solds;
await totalSold.doc(servis).set({'total_solds': servisSolds});
}else{
  log('anonymous---');
int solds= element['solds']??0;
await totalSold.doc('ANONYMOUS').set({'total_solds': solds});
}
}


}

// Future<void> deleteAll()async{
// var db = firebaseFirestore.collection('products');
// var storage= firebaseFirestore;
// var data= await db.get();


// // await Future.wait(data.docs.map((e)async{
// // List<String> imgPaths= List.from(e['storage_imgs_paths']??[]);

// //  for (final path in imgPaths) {
// //           try {
// //             await storage.ref(path).delete();
// //             print('Deleted image: $path');
// //           } catch (e) {
// //             print('Error$path: $e');
// //           }
// //         }
// //   await db.doc(e.id).delete();
// // }));
// }


}
