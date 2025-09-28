import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sneak_peak/controllers/admin%20controllers/product_db_riverpod.dart';
import 'package:sneak_peak/controllers/get_products_stream.dart';
import 'package:sneak_peak/controllers/search_product_riverpod.dart';
import 'package:sneak_peak/pages/admin%20screens/update%20product%20page/update_product_page.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/dialog%20boxes/remove_product_dialog.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';
import 'package:sneak_peak/widgets/custom%20card%20widget/custom_card_widget.dart';
import 'package:sneak_peak/widgets/custom%20card%20widget/loading_card_widget.dart';

class ProductDataWidget extends ConsumerWidget {
  const ProductDataWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var streamData = ref.watch(getProductsProvider).value;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(searchProductProvider.notifier).addProducts(streamData ?? []);
    });
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      sliver: SliverToBoxAdapter(
        child: Center(
          child: Consumer(
            builder: (context, xRef, child) {
              var getProduct = xRef.watch(getProductsProvider);
              print('stream data');
              var list = xRef.watch(searchProductProvider);

              return getProduct.when(
                data: (data) {
                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: list.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 230,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemBuilder: (context, index) {
                      final product = list[list.length - 1 - index];
                      print(list[index].title);
                      return CustomCardWidget(
                        
                        productModal: product,
                        onRemove: () {
                          showRemoveItemDialog(context, () async {
                            Navigator.pop(context);
                            loadingDialog(context, 'Deleting....');

                            var isDeleted = await xRef
                                .read(productDbProvider.notifier)
                                .deleteProduct(
                                  product.id.toString(),
                                  product.storageImgsPath!,
                                );
                            Navigator.pop(context);
                            if (isDeleted) {
                              SnackBarHelper.show('Item deleted successfully');
                            }
                          });
                        },
                        onTap: () {
                          GoRouter.of(context).goNamed(
                            AdminUpdateProductPage.pageName,
                            extra: product,
                            pathParameters: {
                              'name': product.title ?? '',
                              'id': product.id.toString(),
                            },
                          );
                        },
                      );
                    },
                  );
                },
                error: (error, stackTrace) => Text(error.toString()),
                loading: () => Skeletonizer(child: _loading()),
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget _loading() {
  return GridView.builder(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: List.generate(50, (index) => index).length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisExtent: 230,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
    ),
    itemBuilder: (context, index) => const LoadingCardWidget(),
  );
}
