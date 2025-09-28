import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sneak_peak/provider/provider_objects.dart';
import 'package:sneak_peak/repository/admin%20repository/product_cloud_db_repository.dart';

final caraouselSliderImagesProvider = StateNotifierProvider<
  CaraouselSliderImagesNotifier,
  CarauselSliderState
>((ref) {
  return CaraouselSliderImagesNotifier(
    imagePicker: ImagePicker(),
    productCloudDbRepository: ref.read(productServiceRepositoryProviderObject),
  );
});

class CaraouselSliderImagesNotifier extends StateNotifier<CarauselSliderState> {
  ImagePicker imagePicker;
  ProductCloudDbRepository productCloudDbRepository;
  CaraouselSliderImagesNotifier({
    required this.imagePicker,
    required this.productCloudDbRepository,
  }) : super(InitialCaraouselState());

  Future<bool?> addBanner() async {
    var result = await imagePicker.pickMultiImage();

    if (result.isNotEmpty) {
      state = LoadingCaraouselState();
      List<File> imgFilesList = result.map((e) => File(e.path)).toList();
      try {
        await productCloudDbRepository.addBanners(imgFilesList);
        state = LoadedCaraouselState(bannerImages: []);
        return true;
      } catch (e) {
        state = ErrorCaraouselState(error: e.toString());
        return false;
      }
    } else {
      state = InitialCaraouselState();
      return null;
    }
  }

  Future<bool> deleteBanners(String id, String path) async {
    try {
      state = LoadingCaraouselState();
      await productCloudDbRepository.deleteBanner(id, path);
      state = LoadedCaraouselState(bannerImages: []);
      return true;
    } catch (e) {
      state = ErrorCaraouselState(error: e.toString());
      return false;
    }
  }
}

sealed class CarauselSliderState {
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
