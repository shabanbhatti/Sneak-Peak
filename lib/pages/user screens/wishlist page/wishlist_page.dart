import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sneak_peak/controllers/users%20controller/wishlist%20riverpod/wishlist_riverpod.dart';
import 'package:sneak_peak/models/products_modals.dart';
import 'package:sneak_peak/pages/user%20screens/view%20product%20page/view_product_page.dart';
import 'package:sneak_peak/pages/user%20screens/wishlist%20page/controllers/wishlist_stream_provider.dart';
import 'package:sneak_peak/pages/user%20screens/wishlist%20page/widgets/no_wishlist_widget.dart';
import 'package:sneak_peak/widgets/custom%20card%20widget/custom_card_widget.dart';
import 'package:sneak_peak/widgets/custom%20sliver%20app%20bar/custom_sliverappbar.dart';

class WishlistPage extends ConsumerStatefulWidget {
  const WishlistPage({super.key});
  static const pageName = 'wishlist_page';

  @override
  ConsumerState<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends ConsumerState<WishlistPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.invalidate(wishlistStreamProvider));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            CustomSliverAppBar(
              leadingOnTap: () => GoRouter.of(context).pop(),
              leadingIcon: CupertinoIcons.back,
              title: 'Wishlist',
            ),

            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: Consumer(
                    builder: (context, x, child) {
                      var uid = FirebaseAuth.instance.currentUser?.uid;
                      var wishlistStream = x.watch(
                        wishlistStreamProvider(uid ?? ''),
                      );

                      return wishlistStream.when(
                        data:
                            (data) => GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: data.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisExtent: 230,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                              itemBuilder: (context, index) {
                                var cartModal = data[data.length - 1 - index];
                                var productModal = ProductModal(
                                  brand: cartModal.brand,
                                  colors: cartModal.colors,
                                  description: cartModal.description,
                                  genders: cartModal.genders,
                                  id: cartModal.id,
                                  img: cartModal.img,
                                  price: cartModal.price,
                                  shoesSizes: cartModal.shoesSizes,
                                  storageImgsPath: cartModal.storageImgsPath,
                                  title: cartModal.title,
                                  isProductExist: cartModal.isProductExist,
                                  reviews: cartModal.reviews,
                                  solds: cartModal.solds,
                                );
                                return CustomCardWidget(
                                  productModal: productModal,
                                  onTap: () async {
                                    if (cartModal.isProductExist!) {
                                      await x
                                          .read(
                                            wishlistProvider(
                                              productModal.id ?? '',
                                            ).notifier,
                                          )
                                          .isFav(true);

                                      GoRouter.of(context).pushNamed(
                                        ViewProductPage.pageName,
                                        pathParameters: {
                                          'title': productModal.title ?? '',
                                        },
                                        extra: {
                                          'productModal': productModal,
                                          'id': productModal.id,
                                        },
                                      );
                                    }
                                  },
                                  onRemove: () {
                                    x
                                        .read(
                                          wishlistProvider(
                                            productModal.id ?? '',
                                          ).notifier,
                                        )
                                        .removeFromWishlist(cartModal, context);
                                  },
                                  icon: Icons.favorite,
                                  color: Colors.red,
                                );
                              },
                            ),
                        error: (error, stackTrace) => Text(error.toString()),
                        loading:
                            () => LoadingAnimationWidget.flickr(
                              leftDotColor: Colors.orange,
                              rightDotColor: Colors.blue,
                              size: 35,
                            ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const NoWishlistWidget(),
          ],
        ),
      ),
    );
  }
}
