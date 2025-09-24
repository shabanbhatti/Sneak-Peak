import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sneak_peak/models/products_modals.dart';
import 'package:sneak_peak/pages/admin%20screens/update%20product%20page/controllers/update_product_img_controller.dart';
import 'package:sneak_peak/pages/admin%20screens/update%20product%20page/controllers/update_stream_controller.dart';
import 'package:sneak_peak/utils/constants_colors.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';

class UpdateProductImgWidget extends StatelessWidget {
  const UpdateProductImgWidget({
    super.key,
    required this.pageController,
    required this.productModal,
  });

  final PageController pageController;
  final ProductModal productModal;
  @override
  Widget build(BuildContext contextX) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(vertical: 20),
      sliver: SliverToBoxAdapter(
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              var mqSize = Size(constraints.maxWidth, constraints.maxHeight);
              return Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                height: 230,
                width: mqSize.width * 0.9,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: appGreyColor),
                  color: Colors.grey.withAlpha(50),
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Consumer(
                  builder: (context, imgPickerRef, child) {
                    // var twoList = imgPickerRef.watch(updateProductImgProvider);
                    var dbStreamImgList = imgPickerRef.watch(
                      productModelStreamProviderForUpdateAdminPage(
                        productModal.id.toString(),
                      ),
                    );
                    var productModel =
                        imgPickerRef
                            .watch(
                              productModelStreamProviderForUpdateAdminPage(
                                productModal.id.toString(),
                              ),
                            )
                            .value;
                    return dbStreamImgList.when(
                      data: (data) {
                        var imgList = productModel?.img ?? [];
                        var imgPaths = productModel?.storageImgsPath ?? [];
                        if (imgList.isEmpty) {
                          return const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(CupertinoIcons.photo, color: Colors.orange),
                              Text(
                                '   No image selected.',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          );
                        } else {
                          return PageView.builder(
                            physics: const BouncingScrollPhysics(),
                            controller: pageController,
                            itemCount: imgList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                height: double.infinity,
                                width: double.infinity,
                                color: Colors.transparent,
                                child: Stack(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: imgList[index],
                                      height: double.infinity,
                                      width: double.infinity,
                                      fit: BoxFit.contain,
                                      progressIndicatorBuilder:
                                          (context, url, progress) =>
                                              Skeletonizer(
                                                enabled: true,
                                                child: Container(
                                                  height: double.infinity,
                                                  width: double.infinity,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        onPressed: () async {
                                          loadingDialog(
                                            context,
                                            'Deleting image...',
                                          );
                                          await imgPickerRef
                                              .read(
                                                updateProductImgProvider
                                                    .notifier,
                                              )
                                              .deleteImage(
                                                index,
                                                productModal.id.toString(),
                                                imgList,
                                                imgPaths,
                                              );
                                          Navigator.pop(contextX);
                                        },
                                        icon: const Icon(
                                          Icons.remove_circle,
                                          size: 30,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                      error: (error, stackTrace) => Text(error.toString()),
                      loading:
                          () => Skeletonizer(
                            enabled: true,
                            child: Container(
                              height: double.infinity,
                              width: double.infinity,
                              color: Colors.grey,
                            ),
                          ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
