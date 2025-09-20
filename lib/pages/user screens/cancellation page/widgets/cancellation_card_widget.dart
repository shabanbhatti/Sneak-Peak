import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sneak_peak/controllers/users%20controller/cancellation%20order%20riverpod/cancellation_order_riverpod.dart';
import 'package:sneak_peak/models/cart_poduct_modal.dart';
import 'package:sneak_peak/pages/user%20screens/cart%20page/widgets/quantity_widget.dart';
import 'package:sneak_peak/utils/constants_colors.dart';
import 'package:sneak_peak/utils/price_format.dart';

class CancellationCardWidget extends ConsumerWidget {
  const CancellationCardWidget({super.key, required this.cartModal, required this.myContext});

  final CartProductModal cartModal;
  final BuildContext myContext;

  @override
  Widget build(BuildContext contextx, WidgetRef ref) {
    print('cancelled card widget BUILD CALLED');
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: Container(
        height: 145,
        width: double.infinity,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(8),
          border: Border(
            bottom: BorderSide(width: 1, color: Colors.grey.withAlpha(100)),
          ),
          color: Theme.of(contextx).scaffoldBackgroundColor,
        ),
        child: Stack(
          children: [
            Opacity(
              opacity: 0.5,
              child: Row(
                children: [
                  _productImg(cartModal),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _productTitle(cartModal),

                          _productColors(cartModal),
                          _productSizes(cartModal),
                          _productPrice(cartModal),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Qty: ${cartModal.quantity}',
                                  style: const TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () {
                  ref
                      .read(cancellationProvider.notifier)
                      .removeCancelledOrders(myContext, cartModal);
                },
                icon: const Icon(Icons.remove_circle, color: Colors.red),
              ),
            ),
            Opacity(
              opacity: (cartModal.isProductExist!) ? 1.0 : 0.5,
              child: Align(
                alignment: Alignment(1, 0),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Image.asset(
                    'assets/images/pngegg.png',
                    height: 50,
                    width: 100,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _productImg(CartProductModal cartModal) {
  return Expanded(
    flex: 4,
    child: Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            offset: const Offset(0, 0),
            blurRadius: 1,
          ),
        ],
      ),

      child:
          (cartModal.isProductExist!)
              ? CachedNetworkImage(
                imageUrl: cartModal.img![0],
                fit: BoxFit.cover,

                progressIndicatorBuilder: (context, url, progress) {
                  return Skeletonizer(
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.grey.withAlpha(100),
                    ),
                  );
                },
              )
              : Image.asset('assets/images/sold_out.png'),
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
