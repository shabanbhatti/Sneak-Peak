import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/pages/admin%20screens/add%20product%20page/controllers/add_product_picking_imgs_controller.dart';
import 'package:sneak_peak/utils/constants_colors.dart';

class ProductImgsWidget extends StatelessWidget {
  const ProductImgsWidget({super.key, required this.pageController});
  final PageController pageController;
  @override
  Widget build(BuildContext context) {
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
                    var twoList = imgPickerRef.watch(pickingProductImgProvider);
                    return (twoList.fileList.isEmpty)
                        ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.photo, color: Colors.orange),
                            Text(
                              '   No image selected.',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                        : PageView.builder(
                          physics: const BouncingScrollPhysics(),
                          controller: pageController,
                          itemCount: twoList.fileList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: double.infinity,
                              width: double.infinity,
                              color: Colors.transparent,
                              child: Stack(
                                children: [
                                  Image.file(
                                    twoList.fileList[index],
                                    height: double.infinity,
                                    width: double.infinity,
                                    fit: BoxFit.contain,
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      onPressed: () {
                                        imgPickerRef.read(pickingProductImgProvider.notifier).removeImage(twoList.fileList[index].path);
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
