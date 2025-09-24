import 'dart:developer' show log;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/cart_poduct_modal.dart';
import 'package:sneak_peak/provider/provider_objects.dart';
import 'package:sneak_peak/repository/user%20repository/user_cloud_db_repository.dart';

final itemCheckProvider = StateProvider.family<bool, String>(
  (ref, id) => false,
);

final selectedDataList =
    StateNotifierProvider<SelectedDataListStateNotifier, CheckSelectedClass>((
      ref,
    ) {
      return SelectedDataListStateNotifier(
        userRepositoy: ref.read(userCloudDbRepositoryProvider),
      );
    });

class SelectedDataListStateNotifier extends StateNotifier<CheckSelectedClass> {
  final UserCloudDbRepository userRepositoy;
  SelectedDataListStateNotifier({required this.userRepositoy})
    : super(
        CheckSelectedClass(totalPrice: 0, cartList: [], disableProductList: []),
      );

  Future<void> toggeled(bool value, CartProductModal cartProductModal) async {
    log('${cartProductModal.id}');

    if (cartProductModal.isProductExist!) {
      if (value) {
        List<CartProductModal> list = [...state.cartList, cartProductModal];

        int totalPrice = list
            .map((e) => int.parse(e.price!))
            .reduce((value, element) => value + element);
        state = state.copyWith(
          cartListX: list,
          totalPriceX: totalPrice,
          disableproductListX: [],
        );
        print(state.cartList);
      } else {
        List<CartProductModal> list =
            state.cartList
                .where((element) => element.id != cartProductModal.id)
                .toList();
        if (state.cartList.length > 1) {
          int totalPrice = list
              .map((e) => int.parse(e.price!))
              .reduce((value, element) => value + element);
          state = state.copyWith(
            cartListX: list,
            totalPriceX: totalPrice,
            disableproductListX: [],
          );
        } else {
          state = state.copyWith(
            cartListX: list,
            totalPriceX: 0,
            disableproductListX: [],
          );
        }
      }
    } else {
      state = state.copyWith(
        disableproductListX: [...state.disableProductList, cartProductModal],
      );
    }
  }

  Future<bool> deleteCartProducts() async {
    if (state.cartList.isNotEmpty) {
      try {
        for (var element in state.cartList) {
          await userRepositoy.deleteCart(element.id ?? '');
        }

        state = state.copyWith(cartListX: [], totalPriceX: 0);
      } catch (e) {
        print(e.toString());
      }
      return true;
    } else if (state.disableProductList.isNotEmpty) {
      try {
        Future.wait(
          state.disableProductList.map((e) async {
            await userRepositoy.deleteCart(e.id ?? '');
          }),
        );

        state = state.copyWith(cartListX: [], totalPriceX: 0);
      } catch (e) {
        print(e.toString());
      }
      return true;
    } else {
      return false;
    }
  }
}

class CheckSelectedClass {
  final int totalPrice;

  final List<CartProductModal> cartList;

  final List<CartProductModal> disableProductList;

  const CheckSelectedClass({
    required this.totalPrice,
    required this.cartList,
    required this.disableProductList,
  });

  CheckSelectedClass copyWith({
    int? totalPriceX,
    List<CartProductModal>? cartListX,
    List<CartProductModal>? disableproductListX,
  }) {
    return CheckSelectedClass(
      totalPrice: totalPriceX ?? totalPrice,
      cartList: cartListX ?? cartList,
      disableProductList: disableproductListX ?? disableProductList,
    );
  }
}
