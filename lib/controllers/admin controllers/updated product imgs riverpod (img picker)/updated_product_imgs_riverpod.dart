import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';

final updateProductImgProvider =
    StateNotifierProvider<UpdateProductImagesNotifier, UpdateProductImageState>(
      (ref) {
        return UpdateProductImagesNotifier();
      },
    );

class UpdateProductImagesNotifier
    extends StateNotifier<UpdateProductImageState> {
  UpdateProductImagesNotifier() : super(InitialStateUpdateProductImage());

  ImagePicker imagePicker = ImagePicker();

  Future<void> takeImage(String id, BuildContext context) async {
    var db = FirebaseFirestore.instance.collection('products');
    var storage = FirebaseStorage.instance.ref('product_imgs');
    state = LoadingStateUpdateProductImage();

    var result = await imagePicker.pickMultiImage();

    if (result.isNotEmpty) {
      List<File> imgLink = result.map((e) => File(e.path)).toList();
      loadingDialog(context, 'Uploading image....');
      var data = await db.doc(id).get();
      var dbList = List.from(data['images'] ?? []);
      var dbStoragePaths = List.from(data['storage_imgs_paths'] ?? []);

      try {
        List<String> imguUrls = [...dbList];
        List<String> storagePaths = [...dbStoragePaths];
        for (var index in imgLink) {
          var child = storage.child(
            DateTime.now().microsecondsSinceEpoch.toString(),
          );
          await child.putFile(index);

          var link = await child.getDownloadURL();

          imguUrls.add(link);
          storagePaths.add(child.fullPath);
        }

        await db.doc(id).update({
          'images': imguUrls,
          'storage_imgs_paths': storagePaths,
        });

        state = LoadingSuccessfulyStateUpdateProductImage(
          imgLink: [],
          storageImgPath: [],
        );
        Navigator.pop(context);
        SnackBarHelper.show('Photo added successfuly');
      } catch (e) {
        log('FUCKKKKKKK');
        Navigator.pop(context);
        state = ErrorStateUpdateProductImage();
        print('$e ____________');
      }
    }
  }

  Future<void> deleteImage(int index, String id, BuildContext context) async {
    var db = FirebaseFirestore.instance.collection('products');
    var storage = FirebaseStorage.instance;
    state = LoadingStateUpdateProductImage();
    
    try {
      loadingDialog(context, 'Deleting....');
      var data = await db.doc(id).get();

      List<String> strgImgPaths = List.from(data['storage_imgs_paths'] ?? []);
      List<String> dbImgList = List.from(data['images'] ?? []);

      await Future.wait(
        strgImgPaths.map((e) async {
          if (e == strgImgPaths[index]) {
            await storage.ref(strgImgPaths[index]).delete();
          } else {
            print('NO');
          }
        }),
      );

      dbImgList.removeAt(index);
      strgImgPaths.removeAt(index);

      await db.doc(id).update({
        'images': dbImgList,
        'storage_imgs_paths': strgImgPaths,
      });
      Navigator.pop(context);
      state = LoadingSuccessfulyStateUpdateProductImage(
        imgLink: [],
        storageImgPath: [],
      );
      log('Deleted successfuly');
    } catch (e) {
      log('ERRROROROROROR');
      state = ErrorStateUpdateProductImage();
      Navigator.pop(context);
      print(e);
    }
  }
}

sealed class UpdateProductImageState {
  const UpdateProductImageState();
}

class InitialStateUpdateProductImage extends UpdateProductImageState {
  const InitialStateUpdateProductImage();
}

class LoadingStateUpdateProductImage extends UpdateProductImageState {
  const LoadingStateUpdateProductImage();
}

class LoadingSuccessfulyStateUpdateProductImage
    extends UpdateProductImageState {
  final List<String> imgLink;
  final List<String> storageImgPath;
  const LoadingSuccessfulyStateUpdateProductImage({
    required this.imgLink,
    required this.storageImgPath,
  });
}

class ErrorStateUpdateProductImage extends UpdateProductImageState {
  const ErrorStateUpdateProductImage();
}
