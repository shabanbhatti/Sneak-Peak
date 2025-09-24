import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/products_modals.dart';
import 'package:sneak_peak/provider/provider_objects.dart';
import 'package:sneak_peak/repository/admin%20repositories/product_cloud_db_repository.dart';

final productDbProvider =
    StateNotifierProvider<AddProductToFirestoreStateNotifier, ProductState>((
      ref,
    ) {
      return AddProductToFirestoreStateNotifier(
        productRepository: ref.read(productServiceRepositoryProviderObject),
      );
    });

class AddProductToFirestoreStateNotifier extends StateNotifier<ProductState> {
  ProductCloudDbRepository productRepository;
  AddProductToFirestoreStateNotifier({required this.productRepository})
    : super(ProductInitalState());

  Future<bool> addProduct(ProductModal productModal, List<File> imgFile) async {
    state = ProductLoadingState();
    try {
      await productRepository.addProduct(productModal, imgFile);

      state = ProductLoadedSuccessfullyState();
      return true;
    } catch (e) {
      state = ProductErrorState(error: e.toString());

      return false;
    }
  }

  Future<bool> updateProduct(ProductModal productModal,) async {
    state = ProductLoadingState();
    try {
      await productRepository.updateProduct(productModal);

      state = ProductLoadedSuccessfullyState();
      return true;
    } catch (e) {
      state = ProductErrorState(error: e.toString());
      return false;
    }
  }

  Future<bool> deleteProduct(String productId,List<String> storageImgPaths,) async {
    try {
      state = ProductLoadingState();
      await productRepository.deleteProduct(productId, storageImgPaths);
      state=ProductLoadedSuccessfullyState();
      return true;
    } catch (e) {
      state = ProductErrorState(error: e.toString());
      return false;
    }
  }

  Future<void> deleteAll(BuildContext context) async {
    // try {
    //   Navigator.pop(context);
    //   state = ProductLoadingState();
    //   await productService.deleteAll();
    //   state = ProductLoadedSuccessfullyState();

    //   SnackBarHelper.show('Product deleted successfuly');
    // } catch (e) {
    //   state = ProductErrorState();
    //   SnackBarHelper.show('$e');
    // }
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
  final String error;
  const ProductErrorState({required this.error});
}
