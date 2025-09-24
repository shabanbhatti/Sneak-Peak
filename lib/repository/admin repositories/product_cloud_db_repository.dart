import 'dart:core';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sneak_peak/models/caraousels_banners_model.dart';
import 'package:sneak_peak/models/orders_modals.dart';
import 'package:sneak_peak/models/products_modals.dart';
import 'package:sneak_peak/services/admin%20services/product_storage_service.dart';
import 'package:sneak_peak/services/admin%20services/products_cloud_db_service.dart';

class ProductCloudDbRepository {
  final ProductsService productsService;
  final ProductStorageService productStorageService;
  ProductCloudDbRepository({required this.productsService, required this.productStorageService});


Stream<List<ProductModal>> getProductsStream(){
  try {
    return productsService.getProductsStream();
  }on FirebaseException catch (e) {
    throw Exception(e.code);
  }
}


Stream<String> orderDeliveryStatus(String id){
  try {
    return productsService.orderDeliveryStatus(id);
  }on FirebaseException catch (e) {
    throw Exception(e.code);
  }
}

Future<Map<String, dynamic>> getFlChartDataByBrand(String brand)async{
  try {
    return productsService.getFlChartDataByBrand(brand);
  }on FirebaseException catch (e) {
    throw Exception(e.code);
  }
}

Future<void> initializeFlChart()async{
  try {
    await productsService.initializeFlChart();
  }on FirebaseException catch (e) {
    throw Exception(e.toString());
  }
}

Stream<ProductModal> productModelStream(String id){
  try {
    return productsService.productModelStream(id);
  }on FirebaseException catch (e) {
    throw Exception(e.code);
  }
}
Stream<List<OrdersModals>> getOrders(){
  try {
    return productsService.ordersStream();
  }on FirebaseException catch (e) {
    throw Exception(e.code);
  }
}

Stream<List<CaraouselsBannersModel>> bannerStream(){
  try {
    return productsService.bannersStream();
  }on FirebaseException catch (e) {
    throw Exception(e.code);
  }
}

Stream<String> stepsStream(String id){
try {
  return productsService.stepsStream(id);
}on FirebaseException catch (e) {
  throw Exception(e.code);
}
}
Future<void> updateSteps(OrdersModals orderModel ,String step ,String uid,)async{
  try {
    await productsService.updateSteps(orderModel, step, uid);
  }on FirebaseException catch (e) {
    throw Exception(e.code);
  }
}

Future<void> addProduct(ProductModal productModal, List<File> fileList)async{
try {
  var lists= await productStorageService.addProductFileToStorage(fileList,'product_imgs');
  await productsService.addProduct(productModal, lists.imgLinks, lists.imgPaths);
}on FirebaseException catch (e) {
  throw Exception(e.code);
}
}

Future<void> updateProductImages(String id,List<File> imgFileList, List<String> imgLinks, List<String> imgPaths)async{
try {
  var lists= await productStorageService.updateProductImages(imgFileList, imgLinks, imgPaths);
  await productsService.updateProductsImage(id, lists.imgLinks, lists.imgPaths);
}on FirebaseException catch (e) {
  throw Exception(e.code);
}
}

Future<void> deleteProductImage(int index,String id,List<String> imgUrls, List<String> imgPaths )async{
try {
  await productStorageService.deleteImages(index, imgPaths);
  imgUrls.removeAt(index);
  imgPaths.removeAt(index);
  await productsService.updateProductsImage(id, imgUrls, imgPaths);
}on FirebaseException catch (e) {
  throw Exception(e.code);
}
}

Future<void> updateProduct(ProductModal productModel)async{
try {
  await productsService.updateProduct(productModel);
}on FirebaseException catch (e) {
  throw Exception(e.code);
}
}


Future<void> deleteProduct( String productId,List<String> storageImgPaths,)async{
try {
  await productsService.deleteProduct(productId);
  await productStorageService.deleteProduct(storageImgPaths);
}on FirebaseException catch (e) {
  throw Exception(e.code);
}
}

Future<void> addBanners(List<File> imgFileList)async{
  
  try {
    var lists= await productStorageService.addProductFileToStorage(imgFileList, 'banner_img/${DateTime.now().microsecondsSinceEpoch}');
    await Future.wait(lists.imgLinks.map((imgUrl)async{
      await Future.wait(lists.imgPaths.map((imgPath) async{
        String id=DateTime.now().microsecondsSinceEpoch.toString();
        await productsService.addBanners(id, imgUrl, imgPath);
      },));
    },));
  }on FirebaseException catch (e) {
    throw Exception(e.code);
  }
}

Future<void> deleteBanner(String id, String path)async{
  try {
    await productStorageService.deleteBanner(path);
    await productsService.deleteBanner(id);
  }on FirebaseException catch (e) {
    throw Exception(e.code);
  }
}

}