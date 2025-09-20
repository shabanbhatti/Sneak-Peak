import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sneak_peak/models/caraousels_banners_model.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';

final caraouselSliderImagesProvider = StateNotifierProvider<CaraouselSliderImagesNotifier, CarauselSliderState>((ref) {
  return CaraouselSliderImagesNotifier();
});

class CaraouselSliderImagesNotifier extends StateNotifier<CarauselSliderState> {
  CaraouselSliderImagesNotifier(): super(InitialCaraouselState());
  
ImagePicker imagePicker= ImagePicker();

 Future<void> takeBanners(BuildContext context)async{
var db= FirebaseFirestore.instance.collection('banners');
var storage= FirebaseStorage.instance;
var result = await imagePicker.pickImage(source: ImageSource.gallery);

if (result!=null) {
  loadingDialog(context, 'Uploading image...');
  state= LoadingCaraouselState();
  File imgPickerFile= File(result.path);

  try {
   


  
var puttingFile= await storage.ref('banner_img/${DateTime.now().microsecondsSinceEpoch}');
 await puttingFile.putFile(imgPickerFile);
String url= await puttingFile.getDownloadURL();
 String path= await puttingFile.fullPath;

String id=DateTime.now().microsecondsSinceEpoch.toString();

CaraouselsBannersModel carouselBanners= CaraouselsBannersModel(caraouselImages: url,caraouselImagesPaths: path);

await db.doc(id).set(carouselBanners.toMap(id));
Navigator.pop(context);
SnackBarHelper.show('Image uploaded successfuly');

  } catch (e) {
    Navigator.pop(context);
    // throw Exception(e);
    SnackBarHelper.show(e.toString());
  }


}
}


Future<void> deleteBanners(String id, BuildContext context)async{

var db= FirebaseFirestore.instance.collection('banners');
var storage= FirebaseStorage.instance;
loadingDialog(context, 'Deleting...');
try {

var data=await db.doc(id).get();

var path= data['bannerImagesPathsID'];


await storage.ref(path).delete();
await db.doc(id).delete();



Navigator.pop(context);
SnackBarHelper.show('Deleted successfuly');

} catch (e) {
  SnackBarHelper.show(e.toString());
}


}



}


sealed class CarauselSliderState{
  const CarauselSliderState();
}

class InitialCaraouselState extends CarauselSliderState {
  const InitialCaraouselState();
}

class LoadingCaraouselState extends CarauselSliderState {
  const LoadingCaraouselState();
}

class LoadedCaraouselState extends CarauselSliderState {
  final List<String> bannerImages;
  const LoadedCaraouselState({required this.bannerImages});
}

class ErrorCaraouselState extends CarauselSliderState {
  final String error;
  const ErrorCaraouselState({required this.error});
}