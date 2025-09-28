import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sneak_peak/provider/provider_objects.dart';
import 'package:sneak_peak/repository/user%20repository/user_cloud_db_repository.dart';

final userImgProvider =
    StateNotifierProvider.family<UserImgStateNotifier, UserImgState, String>((
      ref,
      key,
    ) {
      return UserImgStateNotifier(
        imagePicker: ImagePicker(),
        userDbRepository: ref.read(userCloudDbRepositoryProvider),
      );
    });

class UserImgStateNotifier extends StateNotifier<UserImgState> {
  final UserCloudDbRepository userDbRepository;
  final ImagePicker imagePicker;
  UserImgStateNotifier({
    required this.userDbRepository,
    required this.imagePicker,
  }) : super(InitialStateUserImg());

  Future<String> takeImage(ImageSource source) async {
    try {
      var result = await imagePicker.pickImage(source: source);
      if (result != null) {
        state = LoadingUserImg();
        var file = File(result.path);

        var imgUrl = await userDbRepository.addUserImage(file);
        state = LoadedSuccessfulyUserImg(
          file: File(result.path),
          imgUrl: imgUrl,
        );

        return 'done';
      } else {
        return 'null';
      }
    } catch (e) {
      state = ErrorStateUserImg(error: e.toString());
      return 'error';
    }
  }

  Future<void> getUserImg() async {
    // state = LoadingUserImg();
    try {
      var img = await userDbRepository.getUserFromDB();

      state = LoadedSuccessfulyUserImg(file: File(''), imgUrl: img);
    } catch (e) {
      state = ErrorStateUserImg(error: e.toString());
    }
  }

  Future<bool> deleteUserImg()async{
    try {
      await userDbRepository.deleteUserImg();
      return true;
    } catch (e) {
      state = ErrorStateUserImg(error: e.toString());
      return false;
    }
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

class ErrorStateUserImg extends UserImgState {
  final String error;
  const ErrorStateUserImg({required this.error});
}
