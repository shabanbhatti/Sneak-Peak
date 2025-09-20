import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sneak_peak/controllers/users%20controller/cart%20riverpod/cart_riverpod.dart';
import 'package:sneak_peak/models/cart_poduct_modal.dart';
import 'package:sneak_peak/pages/user%20screens/cart%20page/this%20controllers/check_and_selected_data_list_riverpod.dart';
import 'package:sneak_peak/pages/user%20screens/cart%20page/widgets/quantity_widget.dart';
import 'package:sneak_peak/pages/user%20screens/view%20product%20page/view_product_page.dart';
import 'package:sneak_peak/utils/constants_colors.dart';
import 'package:sneak_peak/utils/price_format.dart';

class CartCardWidget extends ConsumerWidget {
  const CartCardWidget({super.key, required this.cartModal});

  final CartProductModal cartModal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('CART CARD BUILD CALLED');
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: InkWell(
        onTap: () {
          if (cartModal.isProductExist!) {
            GoRouter.of(context).pushNamed(
              ViewProductPage.pageName,
              extra:
                  {'productModal': null, 'id': cartModal.id}
                      as Map<String, dynamic>,
              pathParameters: {'title': cartModal.title ?? ''},
            );
          }
        },
        child: Container(
          height: 145,
          width: double.infinity,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(8),
            border: Border(
              bottom: BorderSide(width: 1, color: Colors.grey.withAlpha(100)),
            ),
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Row(
            children: [
              _checkBox(cartModal),
              _productImg(cartModal, ref),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Opacity(
                    opacity: (cartModal.isProductExist!) ? 1.0 : 0.5,
                    child: AbsorbPointer(
                      absorbing: (cartModal.isProductExist!) ? false : true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _productTitle(cartModal),

                          _productColors(cartModal),
                          _productSizes(cartModal),
                          _productPrice(cartModal),
                          _quantity(cartModal),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _checkBox(CartProductModal cartModal) {
  return Expanded(
    flex: 1,
    child: Column(
      children: [
        Flexible(
          child: SizedBox(
            height: 100,
            width: 100,
            child: Consumer(
              builder: (context, x, child) {
                var value = x.watch(itemCheckProvider(cartModal.id!));
                return Checkbox(
                  activeColor: Colors.orange,
                  value: value,
                  onChanged: (value) {
                    x.read(itemCheckProvider(cartModal.id!).notifier).state =
                        value!;
                    x
                        .read(selectedDataList.notifier)
                        .toggeled(value, cartModal);
                  },
                );
              },
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _productImg(CartProductModal cartModal, WidgetRef ref) {
  return Flexible(
    flex: 3,
    child: Column(
      children: [
        Flexible(
          child: Container(
            height: 100,
            width: 100,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(30),
                  offset:const Offset(0, 0),
                  blurRadius: 1,
                ),
              ],
            ),
    
            child: Consumer(
              builder: (context, x, _) {
                return (cartModal.isProductExist == false)
                    ? Image.asset('assets/images/sold_out.png')
                    : CachedNetworkImage(
                      imageUrl: cartModal.img![0],
                      errorWidget: (context, error, stackTrace) {
                        ref
                            .read(cartProvider.notifier)
                            .updateForExistance(cartModal.id ?? '', false);
                        return Icon(Icons.error, color: Colors.red);
                      },
                      placeholder: (context, url) {
                        return Skeletonizer(
                          child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            color: Colors.grey.withAlpha(100),
                          ),
                        );
                      },
                    );
              },
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _productTitle(CartProductModal cartModal) {
  return Expanded(
    flex: 2,
    child: Wrap(
      alignment: WrapAlignment.start,
      children: [
        Text(
          cartModal.title ?? '',
          maxLines: 2,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

Widget _productColors(CartProductModal cartModal) {
  return Expanded(
    flex: 2,
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Wrap(
        alignment: WrapAlignment.start,
        children: [
          Text(
            maxLines: 2,
            cartModal.colors!.map((e) => e).toString(),
            style: TextStyle(fontSize: 13, color: appGreyColor),
          ),
        ],
      ),
    ),
  );
}

Widget _productSizes(CartProductModal cartModal) {
  return Expanded(
    flex: 2,
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Wrap(
        alignment: WrapAlignment.start,
        children: [
          Text(
            maxLines: 2,
            'Size: ${cartModal.shoesSizes!.map((e) => e)}',
            style: TextStyle(fontSize: 13, color: appGreyColor),
          ),
        ],
      ),
    ),
  );
}

Widget _productPrice(CartProductModal cartModal) {
  return Expanded(
    flex: 2,
    child: Wrap(
      children: [
        Text(
          maxLines: 2,
          'Rs. ${priceFormat(int.parse(cartModal.price ?? '1'))}',
          style: TextStyle(
            fontSize: 15,
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

Widget _quantity(CartProductModal cartModal) {
  return Expanded(
    flex: 3,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [QuantityCartWidget(cartModal)],
    ),
  );
}
