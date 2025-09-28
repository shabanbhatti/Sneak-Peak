import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sneak_peak/provider/provider_objects.dart';
import 'package:sneak_peak/repository/admin%20repository/product_cloud_db_repository.dart';

final updateProductImgProvider = StateNotifierProvider<
  UpdateProductImagesNotifier,
  UpdateProductImageState
>((ref) {
  return UpdateProductImagesNotifier(
    imagePicker: ImagePicker(),
    productCloudDbRepository: ref.read(productServiceRepositoryProviderObject),
  );
});

class UpdateProductImagesNotifier
    extends StateNotifier<UpdateProductImageState> {
  ImagePicker imagePicker;
  ProductCloudDbRepository productCloudDbRepository;
  UpdateProductImagesNotifier({
    required this.imagePicker,
    required this.productCloudDbRepository,
  }) : super(InitialStateUpdateProductImage());

  Future<void> takeImage(
    String id,
    List<String> imgUrls,
    List<String> imgPaths,
  ) async {
    state = LoadingStateUpdateProductImage();

    var result = await imagePicker.pickMultiImage();

    if (result.isNotEmpty) {
      List<File> imgFilePathsList = result.map((e) => File(e.path)).toList();

      try {
        await productCloudDbRepository.updateProductImages(
          id,
          imgFilePathsList,
          imgUrls,
          imgPaths,
        );

        state = LoadingSuccessfulyStateUpdateProductImage(
          imgLink: [],
          storageImgPath: [],
        );
      } catch (e) {
        state = ErrorStateUpdateProductImage(error: e.toString());
      }
    }
  }

  Future<void> deleteImage(
    int index,
    String id,
    List<String> imgList,
    List<String> imgPaths,
  ) async {
    state = LoadingStateUpdateProductImage();

    try {
      await productCloudDbRepository.deleteProductImage(
        index,
        id,
        imgList,
        imgPaths,
      );

      state = LoadingSuccessfulyStateUpdateProductImage(
        imgLink: [],
        storageImgPath: [],
      );
    } catch (e) {
      state = ErrorStateUpdateProductImage(error: e.toString());
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
  final String error;
  const ErrorStateUpdateProductImage({required this.error});
}
