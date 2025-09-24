import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/orders_modals.dart';
import 'package:sneak_peak/provider/provider_objects.dart';
import 'package:sneak_peak/repository/user%20repository/user_cloud_db_repository.dart';

final buyProductProvider =
    StateNotifierProvider<BuyProductNotifier, BuyProductState>((ref) {
      return BuyProductNotifier(
        userCloudDbRepository: ref.read(userCloudDbRepositoryProvider),
      );
    });

class BuyProductNotifier extends StateNotifier<BuyProductState> {
  UserCloudDbRepository userCloudDbRepository;
  BuyProductNotifier({required this.userCloudDbRepository})
    : super(InitialBuyProductState());

  Future<bool> buy(OrdersModals orderModal) async {
    state = LoadingBuyProductState();

    try {
      await userCloudDbRepository.buyProduct(orderModal);

      state = LoadedSuccessfulyBuyProductState();
      return true;
    } catch (e) {
      state = ErrorBuyProductState(error: e.toString());
      return false;
    }
  }
}

sealed class BuyProductState {
  const BuyProductState();
}

class InitialBuyProductState extends BuyProductState {
  const InitialBuyProductState();
}

class LoadingBuyProductState extends BuyProductState {
  const LoadingBuyProductState();
}

class LoadedSuccessfulyBuyProductState extends BuyProductState {
  const LoadedSuccessfulyBuyProductState();
}

class ErrorBuyProductState extends BuyProductState {
  final String error;
  const ErrorBuyProductState({required this.error});
}
