import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final pickingProductImgProvider =
    StateNotifierProvider.autoDispose<PickingProductImagesNotifier, TwoLists>((
      ref,
    ) {
      return PickingProductImagesNotifier(imagePicker: ImagePicker());
    });

class PickingProductImagesNotifier extends StateNotifier<TwoLists> {
 final ImagePicker imagePicker; 
  PickingProductImagesNotifier({required this.imagePicker}): super(TwoLists(fileList: [],imgLinkList: [],storageImgPaths: [],isLoading: false,),);


  Future<void> takeImage() async {
    try {
      var result = await imagePicker.pickMultiImage();
      if (result.isNotEmpty) {
        int only6Index= (4-state.fileList.length).clamp(0, 4);
        List<File> fileList = result.take(only6Index).map((e) => File(e.path)).toList();
        state = state.copyWith(files: [...state.fileList, ...fileList]);
      }
    } catch (e) {
      print('$e-----------');
    }
  }

  Future<void> removeImage(String path)async{
state= state.copyWith(files: state.fileList.where((element) => element.path!=path,).toList());

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
