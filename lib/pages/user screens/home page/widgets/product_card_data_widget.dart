import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sneak_peak/controllers/users%20controller/get_product_family_stream_riverpod.dart';
import 'package:sneak_peak/controllers/users%20controller/search_product_in_home_riverpod.dart';
import 'package:sneak_peak/controllers/users%20controller/wishlist_riverpod.dart';
import 'package:sneak_peak/pages/user%20screens/view%20product%20page/view_product_page.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';
import 'package:sneak_peak/widgets/custom%20card%20widget/custom_card_widget_for_user_home.dart';
import 'package:sneak_peak/widgets/custom%20card%20widget/loading_card_widget.dart';

class ProductCardDataWidget extends ConsumerWidget {
  const ProductCardDataWidget({super.key, required this.dataTitle});
  final String dataTitle;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var streamData = ref.watch(streamsProductDataProvider(dataTitle));

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref
          .read(userHomeSearchProductProvider(dataTitle).notifier)
          .addProducts(streamData.value ?? []);
    });

    return Consumer(
      builder: (context, x, child) {
        var productDataStream = x.watch(streamsProductDataProvider(dataTitle));
        var productList = x.watch(userHomeSearchProductProvider(dataTitle));

        return productDataStream.when(
          data:
              (data) =>
                  (productList.isNotEmpty)
                      ? Expanded(
                        flex: 20,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),

                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              productList.length > 5 ? 5 : productList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 5,
                              ),
                              child: Container(
                                width: 185,
                                child: CustomCardWidgetForUserHome(
                                  productModal: productList[index],
                                  onTap: () {
                                    GoRouter.of(context).pushNamed(
                                      ViewProductPage.pageName,
                                      pathParameters: {
                                        'title':
                                            productList[index].title.toString(),
                                      },
                                      extra:
                                          {
                                                'productModal':
                                                    productList[index],
                                                'id': '',
                                              },
                                    );
                                  },
                                  onRemove: () async {
                                    loadingDialog(
                                      context,
                                      'Processing wishlist...',
                                    );
                                    var isDone = await x
                                        .read(
                                          wishlistProvider(
                                            productList[index].id.toString(),
                                          ).notifier,
                                        )
                                        .addToWishlist(data[index]);
                                    Navigator.pop(context);
                                    if (isDone == false) {
                                      SnackBarHelper.show(
                                        'Something went wrong',
                                        color: Colors.red,
                                      );
                                    }
                                  },
                                  icon:
                                      (x.watch(
                                                wishlistProvider(
                                                  productList[index].id
                                                      .toString(),
                                                ),
                                              ) ==
                                              false)
                                          ? Icons.favorite_border
                                          : Icons.favorite,
                                  color:
                                      (x.watch(
                                                wishlistProvider(
                                                  productList[index].id
                                                      .toString(),
                                                ),
                                              ) ==
                                              false)
                                          ? Colors.orange
                                          : Colors.red,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                      : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_bag, color: Colors.orange),
                          Text('  No product found'),
                        ],
                      ),
          error: (error, stackTrace) => Text(error.toString()),
          loading: () => _loading(),
        );
      },
    );
  }
}

Widget _loading() {
  return Expanded(
    flex: 10,
    child: ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: List.generate(50, (index) => index).length,
      itemBuilder:
          (context, index) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Skeletonizer(
              child: const SizedBox(
                width: 200,
                child: const LoadingCardWidget(),
              ),
            ),
          ),
    ),
  );
}
