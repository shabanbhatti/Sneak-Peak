import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/address_modal.dart';
import 'package:sneak_peak/provider/provider_objects.dart';
import 'package:sneak_peak/repository/user%20repository/user_cloud_db_repository.dart';

final addressProvider =
    StateNotifierProvider.autoDispose<AddressStateNotifier, AddressState>((
      ref,
    ) {
      return AddressStateNotifier(
        userCloudDbRepository: ref.read(userCloudDbRepositoryProvider),
      );
    });

class AddressStateNotifier extends StateNotifier<AddressState> {
  UserCloudDbRepository userCloudDbRepository;
  AddressStateNotifier({required this.userCloudDbRepository})
    : super(InitialAddressState());

  Future<void> getAddress() async {
    try {
      var data = await userCloudDbRepository.getAddress(userUid: null);
      if (data != null) {
        state = LoadedSuccessfulyAddressState(
          addressModal: AddressModal.fromMap(data),
        );
      } else {
        state = LoadedSuccessfulyAddressState(addressModal: null);
      }
    } catch (e) {
      state = ErrorAddressState(error: e.toString());
    }
  }

  Future<void> getAddressFromOrderPage(String uid) async {
    try {
      state = LoadingAddressState();

      var data = await userCloudDbRepository.getAddress(userUid: uid);

      if (data != null) {
        state = LoadedSuccessfulyAddressState(
          addressModal: AddressModal.fromMap(data),
        );
      } else {
        state = LoadedSuccessfulyAddressState(addressModal: null);
      }
    } catch (e) {
      state = ErrorAddressState(error: e.toString());
    }
  }

  Future<bool> removeAddress() async {
    try {
      state = LoadingAddressState();

      await userCloudDbRepository.removeAddress();

      await getAddress();
      state = InitialAddressState();
      return true;
    } catch (e) {
      state = ErrorAddressState(error: e.toString());
      return false;
    }
  }

  Future<bool> saveAddress(AddressModal addressModel) async {
    state = LoadingAddressState();

    try {
      state = LoadingAddressState();

      await userCloudDbRepository.saveAddress(addressModel);

      state = InitialAddressState();
      await getAddress();
      return true;
    } catch (e) {
      state = ErrorAddressState(error: e.toString());
      return false;
    }
  }
}

sealed class AddressState {
  const AddressState();
}

class InitialAddressState extends AddressState {
  const InitialAddressState();
}

class LoadingAddressState extends AddressState {
  const LoadingAddressState();
}

class LoadedSuccessfulyAddressState extends AddressState {
  final AddressModal? addressModal;
  const LoadedSuccessfulyAddressState({required this.addressModal});
}

class ErrorAddressState extends AddressState {
  final String error;
  const ErrorAddressState({required this.error});
}
