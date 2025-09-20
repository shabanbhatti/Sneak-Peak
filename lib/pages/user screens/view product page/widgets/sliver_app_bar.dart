import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/controllers/users%20controller/wishlist%20riverpod/wishlist_riverpod.dart';
import 'package:sneak_peak/models/products_modals.dart';
import 'package:sneak_peak/pages/user%20screens/view%20product%20image%20page/view_product_img_page.dart';
import 'package:sneak_peak/utils/constants_colors.dart';

class SliverAppbarForViewProductPage extends ConsumerWidget {
  const SliverAppbarForViewProductPage({super.key, required this.productModal});
  final ProductModal productModal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
      pinned: true,
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: CircleAvatar(
          backgroundColor: Colors.grey.withAlpha(70),
          child: IconButton(
            onPressed: () {
              GoRouter.of(context).pop();
            },
            icon: Icon(CupertinoIcons.back, color: appGreyColor),
          ),
        ),
      ),
      expandedHeight: 300,
      flexibleSpace: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: FlexibleSpaceBar(
          background: SizedBox(
            child: Stack(
              children: [
                PageView.builder(
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (value) {
                    ref.read(indexProvider.notifier).setIndex(value + 1);
                  },
                  itemCount: productModal.img!.length,
                  itemBuilder: (context, index) {
                    List<String> imgList=productModal.img??[];
                    return GestureDetector(
                      onTap: () {
                        GoRouter.of(context).pushNamed(ViewProductImgPage.pageName, extra: imgList, pathParameters: {'index': '$index'});
                      },
                      child: CachedNetworkImage(
                        imageUrl: productModal.img![index],
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                      ),
                    );
                  },
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      height: 30,
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.withAlpha(100),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(flex: 1),
                          Expanded(
                            flex: 5,
                            child: Icon(
                              CupertinoIcons.photo,
                              size: 15,
                              color: appGreyColor,
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: Consumer(
                              builder: (context, x, child) {
                                var index = x.watch(indexProvider);
                                return Text(
                                  maxLines: 1,

                                  '  $index/${productModal.img!.length.toString()}',
                                  style: TextStyle(color: appGreyColor),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      height: 50,
                      width: 100,
                      color: Colors.transparent,
                      child: Image.asset(
                        'assets/images/${(productModal.brand == 'Servis')
                            ? 'servis.png'
                            : (productModal.brand == 'Stylo')
                            ? 'styo.png'
                            : (productModal.brand == 'Bata')
                            ? 'bata.png'
                            : 'ndure.png'}',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      actions: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: CircleAvatar(
                  backgroundColor: Colors.grey.withAlpha(70),
                  child: Consumer(
                    builder: (context, x, child) {
                      var isFav = x.watch(
                        wishlistProvider(productModal.id.toString()),
                      );
                      var isWishlist = x.watch(wishlistProvider(productModal.id??''));
                      return (isWishlist == false)
                          ? IconButton(
                            onPressed: () {
                              x
                                  .read(
                                    wishlistProvider(
                                      productModal.id.toString(),
                                    ).notifier,
                                  )
                                  .addToWishlist(productModal,  context);
                            },
                            icon: Icon(
                              (isFav)
                                  ? CupertinoIcons.heart_fill
                                  : CupertinoIcons.heart,
                              color: (isFav) ? Colors.red : appGreyColor,
                            ),
                          )
                          :
                          // ---------------------------------
                          IconButton(
                            onPressed: ()async {
                              // var p = CartProductModal(
                              //   brand: productModal.brand,
                              //   colors: productModal.colors,
                              //   description: productModal.description,
                              //   genders: productModal.genders,
                              //   id: productModal.id,
                              //   img: productModal.img,
                              //   price: productModal.price,
                              //   shoesSizes: productModal.shoesSizes,
                              //   storageImgsPath: productModal.storageImgsPath,
                              //   title: productModal.title,
                              // );
                              await x.read(wishlistProvider(productModal.id??'').notifier).isFav(false);
                              await x.read(wishlistProvider(productModal.id??'').notifier).setToFalse();
                             x.read(wishlistProvider(productModal.id??'').notifier).addToWishlist(productModal,  context);
                            },
                            icon: Icon(
                              (isWishlist)
                                  ? CupertinoIcons.heart_fill
                                  : CupertinoIcons.heart,
                              color: (isWishlist) ? Colors.red : appGreyColor,
                              // Icons.person
                            ),
                          );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

final indexProvider = StateNotifierProvider.autoDispose<IndexNotifier, int>((
  ref,
) {
  return IndexNotifier();
});

class IndexNotifier extends StateNotifier<int> {
  IndexNotifier() : super(1);

  void setIndex(int index) {
    state = index;
  }
}
