import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/controllers/users%20controller/cart_riverpod.dart';
import 'package:sneak_peak/models/cart_poduct_modal.dart';
import 'package:sneak_peak/models/products_modals.dart';
import 'package:sneak_peak/pages/admin%20screens/add%20product%20page/Widgets/circle_size_widget.dart';
import 'package:sneak_peak/pages/user%20screens/cart%20page/this%20controllers/check_and_selected_data_list_riverpod.dart';
import 'package:sneak_peak/pages/user%20screens/check%20out%20page/check_out_page.dart';
import 'package:sneak_peak/pages/user%20screens/view%20product%20page/this%20contoller/selected_color%20riverpod.dart';
import 'package:sneak_peak/pages/user%20screens/view%20product%20page/widgets/color_collection_widget.dart';
import 'package:sneak_peak/utils/colors&names_records.dart';
import 'package:sneak_peak/utils/dialog%20boxes/error_dialog.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/price_format.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';
import 'package:sneak_peak/widgets/custom%20btn/custom_button.dart';

void selectionBottomSheet(
  BuildContext context,
  ProductModal productModal,
  String buyOrCart, {
  WidgetRef? ref,
}) {
  print('Selection sheet called');
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Center(
                child: Column(
                  children: [
                    _topRow(productModal),

                    const Divider(),

                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: const Text(
                              'Colors',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              children:
                                  productModal.colors!.map((e) {
                                    var data = getColors(e);
                                    return Consumer(
                                      builder: (context, ref, child) {
                                        var isColorChecked = ref.watch(
                                          colorsCollectionForUserViewProductPageProvider1,
                                        );
                                        return Padding(
                                          padding: EdgeInsets.all(1),
                                          child: SizedBox(
                                            height: 30,
                                            width: 30,
                                            child: ColorsCollectionFoUserViewProduct(
                                              isClicked:
                                                  isColorChecked ==
                                                  data.colorName,
                                              color: data.color,
                                              onTap: () {
                                                ref
                                                    .read(
                                                      colorsCollectionForUserViewProductPageProvider1
                                                          .notifier,
                                                    )
                                                    .isChecked(e)
                                                    .then((value) {
                                                      ref
                                                          .read(
                                                            selectedColorProvider
                                                                .notifier,
                                                          )
                                                          .addColor(e);
                                                    });
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Selected color:'),
                              Consumer(
                                builder: (context, x, child) {
                                  var color = x.watch(selectedColorProvider);
                                  return Text(
                                    (color == '') ? ' None' : ' $color',
                                    style: const TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.orange,
                                      decorationThickness: 3,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),

                          const Divider(),

                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: const Text(
                              'Size',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              children:
                                  productModal.shoesSizes!.map((e) {
                                    return Consumer(
                                      builder: (context, x, child) {
                                        var isChecked = x.watch(
                                          radioSizeCheckedProvider,
                                        );

                                        var isEqualIndex = isChecked == e;
                                        print(isEqualIndex);
                                        return CircleSizeWidget(
                                          size: 30,
                                          fontSIze: 15,
                                          title: e.toString(),
                                          isRadioCheck: isEqualIndex,
                                          index: e,
                                          onTap: () {
                                            x
                                                .read(
                                                  radioSizeCheckedProvider
                                                      .notifier,
                                                )
                                                .state = e;
                                          },
                                        );
                                      },
                                    );
                                  }).toList(),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Selected size:'),
                              Consumer(
                                builder: (context, x, child) {
                                  var size = x.watch(radioSizeCheckedProvider);
                                  return Text(
                                    (size == null) ? ' None' : ' $size',
                                    style: const TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.orange,
                                      decorationThickness: 3,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            _bottomBtn(productModal, buyOrCart),

            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  if (buyOrCart == "BUY") {
                    ref!.invalidate(selectedDataList);
                    ref.invalidate(itemCheckProvider);
                  }
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _bottomBtn(ProductModal productModal, String buyOrCart) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      width: double.infinity,
      height: 90,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.grey.withAlpha(100)),
          top: BorderSide(color: Colors.grey.withAlpha(100), width: 1),
        ),
      ),
      child: Consumer(
        builder: (context, x, child) {
          var loading = x.watch(cartProvider);
          var shoesSize = x.watch(radioSizeCheckedProvider);
          var color = x.watch(selectedColorProvider);
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child:
                (buyOrCart == 'CART')
                    ? SafeArea(
                      child: CustomButton(
                        onTap: () async {
                          if (shoesSize != null && color.isNotEmpty) {
                            var pM = ProductModal(
                              id: productModal.id,
                              brand: productModal.brand,
                              colors: [color],
                              description: productModal.description,
                              genders: productModal.genders,
                              price: productModal.price,
                              img: productModal.img,
                              storageImgsPath: productModal.storageImgsPath,
                              title: productModal.title,
                              shoesSizes: [shoesSize ?? 0],
                            );
                            loadingDialog(context, 'Adding to cart...');
                            var isCarted = await x
                                .read(cartProvider.notifier)
                                .addToCartBtnClick(pM);
                            Navigator.pop(context);
                            if (isCarted) {
                              SnackBarHelper.show('Add to cart successfuly');
                              Navigator.pop(context);
                            }
                          } else {
                            errorDialog(
                              context,
                              'Please select the color and size.',
                            );
                          }
                        },
                        btnTitleWidget: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              (loading == 'loading')
                                  ? const [
                                    CupertinoActivityIndicator(
                                      color: Colors.white,
                                    ),
                                  ]
                                  : const [
                                    Flexible(
                                      child: Icon(
                                        Icons.shopping_bag,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Flexible(
                                      child: FittedBox(
                                        child: Text(
                                          '  Add to cart',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                        ),
                      ),
                    )
                    : CustomButton(
                      onTap: () async {
                        if (shoesSize != null && color.isNotEmpty) {
                          x.invalidate(selectedDataList);
                          var cartModal = CartProductModal(
                            id: productModal.id,
                            brand: productModal.brand,
                            colors: [color],
                            description: productModal.description,
                            genders: productModal.genders,
                            price: productModal.price,
                            img: productModal.img,
                            storageImgsPath: productModal.storageImgsPath,
                            title: productModal.title,
                            quantity: 1,
                            shoesSizes: [shoesSize],
                          );

                          await x
                              .read(selectedDataList.notifier)
                              .toggeled(true, cartModal);

                          GoRouter.of(context).pushNamed(CheckOutPage.pageName);
                        } else {
                          errorDialog(
                            context,
                            'Please select the color and size.',
                          );
                        }
                      },
                      btnTitle: 'Buy',
                    ),
          );
        },
      ),
    ),
  );
}

Widget _topRow(ProductModal productModal) {
  return Flexible(
    child: Container(
      height: 85,
      width: double.infinity,
      color: Colors.transparent,
      child: Row(
        children: [
          Flexible(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                height: 70,
                width: 70,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CachedNetworkImage(
                  imageUrl: productModal.img![0],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 5,
                  child: Text(
                    'Rs. ${priceFormat(int.parse(productModal.price ?? ''))}',
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Flexible(
                  flex: 5,
                  child: Text(
                    productModal.colors!.map((e) => e).toString(),
                    maxLines: 2,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
                Flexible(
                  flex: 5,
                  child: Text(
                    productModal.genders!.map((e) => e).toString(),
                    maxLines: 2,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
