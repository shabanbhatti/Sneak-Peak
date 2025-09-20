import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/models/products_modals.dart';
import 'package:sneak_peak/pages/admin%20screens/admin_main.dart';
import 'package:sneak_peak/services/admin%20service/products_ser.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';

final addProductToFirestoreProvider =
    StateNotifierProvider<AddProductToFirestoreStateNotifier, ProductState>((
      ref,
    ) {
      return AddProductToFirestoreStateNotifier();
    });

class AddProductToFirestoreStateNotifier extends StateNotifier<ProductState> {
  AddProductToFirestoreStateNotifier() : super(ProductInitalState());
  ProductService productService = ProductService();

  Future<void> addProduct(
    ProductModal productModal,
    BuildContext context,
  ) async {
    state = ProductLoadingState();
    
    try {
      await productService.addProduct(productModal);
      
      SnackBarHelper.show('Product add successfuly');
      GoRouter.of(context).goNamed(AdminMain.pageName);
      
      state = ProductLoadedSuccessfullyState();
    } catch (e) {
      
      state = ProductErrorState();
      SnackBarHelper.show('$e');
    }
  }

  Future<void> updateProduct(
    ProductModal productModal,
    BuildContext context,
  ) async {
    state = ProductLoadingState();
    try {
      await productService.updateProduct(productModal);
      SnackBarHelper.show('Product updated successfuly');
      GoRouter.of(context).goNamed(AdminMain.pageName);
      state = ProductLoadedSuccessfullyState();
    } catch (e) {
      state = ProductErrorState();
      SnackBarHelper.show('$e');
    }
  }

  Future<void> deleteProduct(
    String productId,
    List<String> storageImgPaths,
    BuildContext context,
  ) async {
    try {
      Navigator.pop(context);
      await productService.deleteProduct(productId, storageImgPaths);

      SnackBarHelper.show('Product deleted successfuly');
    } catch (e) {
      state = ProductErrorState();
      SnackBarHelper.show('$e');
    }
  }

  Future<void> deleteAll(BuildContext context) async {
    try {
      Navigator.pop(context);
      state = ProductLoadingState();
      await productService.deleteAll();
      state = ProductLoadedSuccessfullyState();

      SnackBarHelper.show('Product deleted successfuly');
    } catch (e) {
      state = ProductErrorState();
      SnackBarHelper.show('$e');
    }
  }
}

sealed class ProductState {
  const ProductState();
}

class ProductInitalState extends ProductState {
  const ProductInitalState();
}

class ProductLoadingState extends ProductState {
  const ProductLoadingState();
}

class ProductLoadedSuccessfullyState extends ProductState {
  const ProductLoadedSuccessfullyState();
}

class ProductErrorState extends ProductState {
  const ProductErrorState();
}
