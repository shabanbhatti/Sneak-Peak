import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sneak_peak/services/shared%20pref%20service/shared_pref_service.dart';
import 'package:sneak_peak/utils/constant_imgs.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';

final userImgProvider =
    StateNotifierProvider<UserImgStateNotifier, UserImgState>((ref) {
      return UserImgStateNotifier();
    });

class UserImgStateNotifier extends StateNotifier<UserImgState> {
  UserImgStateNotifier() : super(InitialStateUserImg());

  ImagePicker imagePicker = ImagePicker();

  Future<void> takeImage(ImageSource source, BuildContext context) async {
    try {
      var db = FirebaseFirestore.instance.collection('users');
      var auth = FirebaseAuth.instance.currentUser;

      var storage = FirebaseStorage.instance.ref('user_imgs');

      var result = await imagePicker.pickImage(source: source);
      state = LoadingUserImg();
      loadingDialog(context, 'Uploading image...');
      if (result != null) {
        var file = File(result.path);

        var child = storage.child('user/${auth!.uid}');

        await child.putFile(file);

        var url = await child.getDownloadURL();
        var fullPath = child.fullPath;
        state = LoadedSuccessfulyUserImg(file: File(result.path), imgUrl: url);

        await db.doc(auth.uid).update({
          'userProfileImg': url,
          'userImgStoragePath': fullPath,
        });
       await SPHelper.setString(SPHelper.userImg, url);
        Navigator.pop(context);

        SnackBarHelper.show('Image uploaded successfuly');
      } else {
        state= InitialStateUserImg();
        await getUserImg(context);
        Navigator.pop(context);
        
      }
    } catch (e) {
      Navigator.pop(context);
      state = ErroStateUserImg(error: e.toString());
      print(e);
    }
  }

  Future<void> getUserImg(BuildContext context) async {
    var db= FirebaseFirestore.instance.collection('users');
    var auth= FirebaseAuth.instance.currentUser;
    state = LoadingUserImg();
try {
   String imgUrl= await SPHelper.getString(SPHelper.userImg);

   if (imgUrl=='') {
     print('SP doesnot have img');
var snapshot= await db.doc(auth!.uid).get();

var data= snapshot.data() as Map<String, dynamic>;


if (data.containsKey('userProfileImg')) {
  String firebaseImgUrl= data['userProfileImg'];
  state= LoadedSuccessfulyUserImg(file: File(''), imgUrl: firebaseImgUrl);
await SPHelper.setString(SPHelper.userImg, firebaseImgUrl);
}else{
state= LoadedSuccessfulyUserImg(file: File(''), imgUrl: profileIconUrl);
}

   }else{
    print('SP has img');
    state= LoadedSuccessfulyUserImg(file: File(''), imgUrl: imgUrl);
   }


} catch (e) {
  
  print(e);
  // throw Exception(e);
}

//     loadingDialog(context, 'Loading image...');
//     // var db = FirebaseFirestore.instance.collection('users');
//     // var auth = FirebaseAuth.instance.currentUser;

//     try {
// String? imgUrl= await SPHelper.getString(SPHelper.userImg);
// print(imgUrl);
     
//        if (imgUrl!=null) {
//         state = LoadedSuccessfulyUserImg(file: File(''), imgUrl: imgUrl??'https://thumb.ac-illust.com/b1/b170870007dfa419295d949814474ab2_t.jpeg');
// print('TRUE------------------------------IMG FOUND');
//       } 
//        Navigator.pop(context);
//     } catch (e) {
//       Navigator.pop(context);
      
//       state = ErroStateUserImg(error: e.toString());
//       throw Exception('IMG ERROR');
//     }
  }
}

sealed class UserImgState {
  const UserImgState();
}

class InitialStateUserImg extends UserImgState {
  const InitialStateUserImg();
}

class LoadingUserImg extends UserImgState {
  const LoadingUserImg();
}

class LoadedSuccessfulyUserImg extends UserImgState {
  final File file;
  final String imgUrl;
  const LoadedSuccessfulyUserImg({required this.file, required this.imgUrl});
}

class ErroStateUserImg extends UserImgState {
  final String error;
  const ErroStateUserImg({required this.error});
}
