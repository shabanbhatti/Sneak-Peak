import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sneak_peak/models/cart_poduct_modal.dart';
import 'package:sneak_peak/models/orders_modals.dart';
import 'package:sneak_peak/pages/user%20screens/completed%20orders%20page/controllers/order_reviews_riverpod.dart';
import 'package:sneak_peak/utils/constants_colors.dart';
import 'package:sneak_peak/utils/price_format.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';

class CompletedCardsWidgets extends ConsumerWidget {
  const CompletedCardsWidgets({
    super.key,
    required this.cartModal,
    required this.ordersModals,
  });

  final CartProductModal cartModal;
  final OrdersModals ordersModals;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: Container(
        height: 245,
        width: double.infinity,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(8),
          border: Border(
            bottom: BorderSide(width: 1, color: Colors.grey.withAlpha(100)),
          ),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 8,
                  child: Row(
                    children: [
                      _productImg(cartModal),
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 5,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _productTitle(cartModal),

                              _productColors(cartModal),
                              _productSizes(cartModal),
                              _productPrice(cartModal),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          'Qty: ${cartModal.quantity}',
                                          style: const TextStyle(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                if (cartModal.isProductExist!)
                  const Expanded(
                    flex: 1,
                    child: Text(
                      'Please give us a feedback',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                const Spacer(flex: 1),
                if (cartModal.isProductExist == false)
                  Flexible(
                    child: Text(
                      'NOTE: This product is no more avaliable on this store.',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.red,
                      ),
                    ),
                  ),
                if (cartModal.isProductExist!)
                  Expanded(
                    flex: 2,
                    child: Consumer(
                      builder: (context, x, child) {
                        var auth = FirebaseAuth.instance.currentUser;
                        var ratings = x.watch(
                          reviewsStreamProvider((
                            id: ordersModals.id ?? '',
                            productId: cartModal.id ?? '',
                            uid: auth!.uid,
                          )),
                        );
                        return ratings.when(
                          data:
                              (data) => Opacity(
                                opacity: cartModal.isProductExist! ? 1.0 : 0.3,
                                child: Wrap(
                                  children: [
                                    const Text(
                                      '🙁',
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: RatingBar.builder(
                                        initialRating: data,
                                        minRating: 1,
                                        glowRadius: 10,
                                        itemSize: 25,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,

                                        itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 3.0,
                                        ),
                                        itemBuilder:
                                            (context, _) => const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                              size: 10,
                                            ),
                                        onRatingUpdate: (rating) {
                                          if (cartModal.isProductExist!) {
                                            var auth =
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser;
                                            ref
                                                .read(
                                                  reviewsProvider(
                                                    cartModal.id ?? '',
                                                  ).notifier,
                                                )
                                                .addReview(
                                                  context,
                                                  rating,
                                                  cartModal.id ?? '',
                                                  auth!.uid,
                                                  ordersModals,
                                                );
                                          } else {
                                            SnackBarHelper.show(
                                              'Product is out of stock',
                                              color: Colors.red,
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    const Text(
                                      '😀',
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          error: (error, stackTrace) => Text(error.toString()),
                          loading: () => CupertinoActivityIndicator(),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

final reviewsStreamProvider = StreamProvider.family<
  double,
  ({String id, String productId, String uid})
>((ref, record) {
  var db = FirebaseFirestore.instance
      .collection('users')
      .doc(record.uid)
      .collection('to_ship');
  return db.doc(record.id).snapshots().map((event) {
    var data = event.data() ?? {};
    List<dynamic> value = data['products'] ?? [];
    var list =
        value.where((element) => element['id'] == record.productId).toList();
    var dataList = list[0]['reviews'] ?? {};
    var reviews = dataList[record.uid];
    return reviews ?? 0.0;
  });
});

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
