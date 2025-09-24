import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sneak_peak/controllers/users%20controller/wishlist_riverpod.dart';
import 'package:sneak_peak/controllers/users%20controller/get_product_family_stream_riverpod.dart';
import 'package:sneak_peak/models/products_modals.dart';
import 'package:sneak_peak/pages/user%20screens/view%20product%20page/view_product_page.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';
import 'package:sneak_peak/widgets/custom%20card%20widget/custom_card_widget.dart';
import 'package:sneak_peak/widgets/custom%20card%20widget/loading_card_widget.dart';

class DataListWidget extends ConsumerWidget {
  const DataListWidget({
    super.key,
    required this.fileName,
    required this.gender,
  });
  final String fileName;
  final String gender;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var productListOfStream = ref.watch(
      streamsProductDataProvider((fileName != 'allfeatures') ? fileName : ''),
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref
          .read(genderListDataProvider.notifier)
          .addData(productListOfStream.value ?? [], gender);
    });
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      sliver: SliverToBoxAdapter(
        child: Center(
          child: Consumer(
            builder: (context, x, child) {
              var myList = x.watch(genderListDataProvider).list;
              var streamDataList = x.watch(
                streamsProductDataProvider(fileName),
              );
              return streamDataList.when(
                data: (data) {
                  if (myList.isNotEmpty) {
                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: myList.length,
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 230,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                      itemBuilder:
                          (context, index) => CustomCardWidget(
                            productModal: myList[index],
                            onTap: () {
                              GoRouter.of(context).pushNamed(
                                ViewProductPage.pageName,
                                pathParameters: {
                                  'title': myList[index].title.toString(),
                                },
                                extra:
                                    {'productModal': myList[index], 'id': ''}
                                        as Map<String, dynamic>,
                              );
                            },
                            onRemove: ()async{
                               
                                   loadingDialog(context, 'Processing wishlist...');
                                var isDone= await ref.read(wishlistProvider(myList[index].id.toString(),).notifier,).addToWishlist(myList[index]);
                                Navigator.pop(context);
                                if (isDone==false) {
                                  SnackBarHelper.show('Something went wrong', color: Colors.red);
                                }
                              // ref
                              //     .read(
                              //       wishlistProvider(
                              //         myList[index].id.toString(),
                              //       ).notifier,
                              //     )
                              //     .addToWishlist(myList[index], context);
                            },
                            icon:
                                (ref.watch(
                                          wishlistProvider(
                                            myList[index].id.toString(),
                                          ),
                                        ) ==
                                        false)
                                    ? Icons.favorite_border
                                    : Icons.favorite,
                            color:
                                (ref.watch(
                                          wishlistProvider(
                                            myList[index].id.toString(),
                                          ),
                                        ) ==
                                        false)
                                    ? Colors.orange
                                    : Colors.red,
                          ),
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 250),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_bag, color: Colors.orange),
                          Text('  No product found'),
                        ],
                      ),
                    );
                  }
                },
                error: (error, stackTrace) => Text(error.toString()),
                loading: () => _loading(),
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget _loading() {
  return Skeletonizer(
    child: GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: List.generate(50, (index) => '').length,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 230,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) => const LoadingCardWidget(),
    ),
  );
}

final genderListDataProvider = StateNotifierProvider<
  GenderListDataNotifier,
  ({List<ProductModal> list, String highOrLowPrive})
>((ref) {
  return GenderListDataNotifier();
});

class GenderListDataNotifier
    extends StateNotifier<({List<ProductModal> list, String highOrLowPrive})> {
  GenderListDataNotifier() : super((list: [], highOrLowPrive: ''));

  Future<void> addData(List<ProductModal> list, String gender) async {
    if (gender != '') {
      state = (
        list:
            list.where((element) => element.genders!.contains(gender)).toList(),
        highOrLowPrive: '',
      );
    } else {
      state = state = (list: list, highOrLowPrive: '');
    }
  }

  void sortByPriceLowToHigh() {
    final sortedList = [...state.list];
    sortedList.sort((a, b) {
      final aPrice = int.tryParse(a.price ?? '0') ?? 0;
      final bPrice = int.tryParse(b.price ?? '0') ?? 0;
      return aPrice.compareTo(bPrice);
    });
    state = (list: sortedList, highOrLowPrive: 'Price: Low to hight');
  }

  void sortByPriceHighToLow() {
    final sortedList = [...state.list];
    sortedList.sort((a, b) {
      final aPrice = int.tryParse(a.price ?? '0') ?? 0;
      final bPrice = int.tryParse(b.price ?? '0') ?? 0;
      return bPrice.compareTo(aPrice);
    });
    state = (list: sortedList, highOrLowPrive: 'Price: high to low');
  }
}
