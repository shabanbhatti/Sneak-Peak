import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class UserStorageService {
  final FirebaseStorage firebaseStorage;
  UserStorageService({required this.firebaseStorage});

  Future<({String imgUrl, String imgPath})> addUserImage(
    File imgFile,
    String uid,
  ) async {
    var storage = firebaseStorage.ref('user_imgs');

    var child = storage.child('user/$uid');
    await child.putFile(imgFile);
    var url = await child.getDownloadURL();
    var fullPath = child.fullPath;
    return (imgUrl: url, imgPath: fullPath);
  }
}
