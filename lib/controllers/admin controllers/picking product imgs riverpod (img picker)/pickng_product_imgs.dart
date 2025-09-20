import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final pickingProductImgProvider =
    StateNotifierProvider.autoDispose<PickingProductImagesNotifier, TwoLists>((
      ref,
    ) {
      return PickingProductImagesNotifier();
    });

class PickingProductImagesNotifier extends StateNotifier<TwoLists> {
  PickingProductImagesNotifier()
    : super(
        TwoLists(
          fileList: [],
          imgLinkList: [],
          storageImgPaths: [],
          isLoading: false,
        ),
      );

  ImagePicker imagePicker = ImagePicker();

  Future<void> takeImage() async {
    try {
      var result = await imagePicker.pickMultiImage();
      if (result.isNotEmpty) {
        int only6Index= (4-state.fileList.length).clamp(0, 4);
        List<File> myL = result.take(only6Index).map((e) => File(e.path)).toList();
        state = state.copyWith(files: [...state.fileList, ...myL]);
      }
    } catch (e) {
      print('$e-----------');
    }
  }

  Future<void> removeImage(String path)async{
state= state.copyWith(files: state.fileList.where((element) => element.path!=path,).toList());

  }

  Future<void> addFileList(List<File> list) async {
    state = state.copyWith(files: [...state.fileList, ...list]);
  }

  Future<TwoLists?> addProductFileToStorage() async {
    var storage = FirebaseStorage.instance.ref('product_imgs');
    state = state.copyWith(isLoad: true);
    try {
      List<String> imguUrls = [];
      List<String> storageImgPaths = [];
      for (var index in state.fileList) {
        var child = storage.child(
          DateTime.now().microsecondsSinceEpoch.toString(),
        );
        await child.putFile(index);

        var link = await child.getDownloadURL();
        // print(child.fullPath);
        imguUrls.add(link);
        storageImgPaths.add(child.fullPath);
      }

      state = state.copyWith(
        imgs: [...state.imgLinkList, ...imguUrls],
        storageImgsPaths: [...state.storageImgPaths, ...storageImgPaths],
        isLoad: false,
      );
      return state;
    } catch (e) {
      print('$e ____________');
      return null;
    }
  }
}

class TwoLists {
  final List<File> fileList;
  final bool isLoading;
  final List<String> storageImgPaths;
  final List<String> imgLinkList;

  const TwoLists({
    required this.fileList,
    required this.storageImgPaths,
    required this.imgLinkList,
    required this.isLoading,
  });

  TwoLists copyWith({
    List<File>? files,
    List<String>? imgs,
    bool? isLoad,
    List<String>? storageImgsPaths,
  }) {
    return TwoLists(
      fileList: files ?? fileList,
      imgLinkList: imgs ?? imgLinkList,
      isLoading: isLoad ?? isLoading,
      storageImgPaths: storageImgsPaths ?? storageImgPaths,
    );
  }
}
