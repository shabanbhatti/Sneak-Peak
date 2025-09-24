import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/controllers/get%20products%20stream%20provider/get_products_stream.dart';
import 'package:sneak_peak/controllers/search%20product%20riverpod/search_product_riverpod.dart';
import 'package:sneak_peak/controllers/users%20controller/wishlist_riverpod.dart';
import 'package:sneak_peak/pages/user%20screens/search%20page/widgets/no_search_widget.dart';
import 'package:sneak_peak/pages/user%20screens/view%20product%20page/view_product_page.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';
import 'package:sneak_peak/widgets/custom%20card%20widget/custom_card_widget.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print('Search BULD CALLED');
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              floating: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              snap: true,
              title: Text('Search'),
              centerTitle: true,
              actions: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Row(children: [_popupMenuButton()]),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size(double.infinity, 40),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Consumer(
                    builder: (context, x, child) {
                      var streamProductList =
                          x.watch(getProductsProvider).value ?? [];
                      return CupertinoTextField(
                        controller: controller,
                        decoration: BoxDecoration(
                          color: Colors.grey.withAlpha(50),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.transparent),
                        ),
                        placeholder: 'Search shoes',
                        prefix: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Icon(Icons.search),
                        ),
                        onChanged: (value) {
                          ref
                              .read(searchProductProvider.notifier)
                              .onChanged(value, streamProductList);
                          ref
                              .read(searchValueProvider.notifier)
                              .addValue(value);
                        },
                      );
                    },
                  ),
                ),
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.only(top: 20, left: 15, right: 15),
              sliver: SliverToBoxAdapter(
                child: Consumer(
                  builder: (context, ref, child) {
                    var searchValue = ref.watch(searchValueProvider);
                    var listLenght = ref.watch(searchProductProvider);
                    return (searchValue.isEmpty)
                        ? const SizedBox()
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                'Result for "$searchValue"',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                '${listLenght.length.toString()} result found',
                              ),
                            ),
                          ],
                        );
                  },
                ),
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 13),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: Consumer(
                    builder: (context, ref, child) {
                      var list = ref.watch(searchProductProvider);

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: list.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent: 230,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                        itemBuilder: (context, index) {
                          return CustomCardWidget(
                            productModal: list[index],
                            onTap: () {
                               GoRouter.of(context).pushNamed(ViewProductPage.pageName, pathParameters: {
                                        'title':
                                            list[index].title.toString(),
                                      },extra: {
                                        'productModal':list[index],
                                        'id':list[index].id
                                      } );
                            },
                            onRemove: ()async {
                                loadingDialog(context, 'Processing wishlist...');
                                var isDone= await ref.read(wishlistProvider(list[index].id.toString(),).notifier,).addToWishlist(list[index]);
                                Navigator.pop(context);
                                if (isDone==false) {
                                  SnackBarHelper.show('Something went wrong', color: Colors.red);
                                }
                              // ref
                              //     .read(
                              //       wishlistProvider(
                              //         list[index].id.toString(),
                              //       ).notifier,
                              //     )
                              //     .addToWishlist(list[index], context);
                            },
                            icon:
                                (ref.watch(
                                          wishlistProvider(
                                            list[index].id.toString(),
                                          ),
                                        ) ==
                                        false)
                                    ? Icons.favorite_border
                                    : Icons.favorite,
                            color:
                                (ref.watch(
                                          wishlistProvider(
                                            list[index].id.toString(),
                                          ),
                                        ) ==
                                        false)
                                    ? Colors.orange
                                    : Colors.red,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            const NoSearchWidget(),
          ],
        ),
      ),
    );
  }

  Widget _popupMenuButton() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'low_high') {
          ref.read(searchProductProvider.notifier).highToLow();
        } else if (value == 'high_low') {
          ref.read(searchProductProvider.notifier).lowToHigh();
        }
      },
      itemBuilder: (BuildContext context) {
        return const [
          PopupMenuItem(value: 'low_high', child: Text('Price: Low to High')),
          PopupMenuItem(value: 'high_low', child: Text('Price: High to Low')),
        ];
      },
      icon: const Icon(Icons.sort),
    );
  }
}
