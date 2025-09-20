import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/products_modals.dart';
import 'package:sneak_peak/pages/admin%20screens/add%20product%20page/Widgets/circle_size_widget.dart';
import 'package:sneak_peak/pages/user%20screens/view%20product%20page/widgets/bottom_bar_buttons_widget.dart';
import 'package:sneak_peak/pages/user%20screens/view%20product%20page/widgets/color_collection_widget.dart';
import 'package:sneak_peak/pages/user%20screens/view%20product%20page/widgets/sliver_app_bar.dart';
import 'package:sneak_peak/utils/colors&names_records.dart';
import 'package:sneak_peak/utils/price_format.dart';
import 'package:sneak_peak/widgets/gender%20cetagory%20collection%20btn/gender_cetagory_cllection_btn.dart';

class ViewProductPage extends ConsumerWidget {
  const ViewProductPage({super.key, this.productModal, this.id});
  static const pageName = 'view_product_page';

  final ProductModal? productModal;
  final String? id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      bottomNavigationBar: BottomBarButtonsWidget(
        productModal: productModal,
        id: id,
      ),
      body:
          (productModal == null)
              ? Center(
                child: Consumer(
                  builder: (context, x, child) {
                    var productModalFromStream = x.watch(
                      cartViewProductOrHomeProvider(id ?? ''),
                    );
                    return productModalFromStream.when(
                      data: (data) {
                        return Scrollbar(
                          thumbVisibility: true,
                          radius: Radius.circular(20),
                          thickness: 5,
                          child: CustomScrollView(
                            physics: const BouncingScrollPhysics(),
                            slivers: [
                              SliverAppbarForViewProductPage(
                                productModal: data,
                              ),

                              _price(data),
                              _title(data),
                              _salesAndReviews(data),
                              _genderCheck(data),
                              _colorsCheck(data),
                              _productSizes(data),
                              _description(data),
                            ],
                          ),
                        );
                      },
                      error: (error, stackTrace) => Text(error.toString()),
                      loading: () => CupertinoActivityIndicator(),
                    );
                  },
                ),
              )
              : Center(
                child: Scrollbar(
                  thumbVisibility: true,
                  radius: Radius.circular(20),
                  thickness: 5,
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverAppbarForViewProductPage(
                        productModal: productModal!,
                      ),

                      _price(productModal!),
                      _title(productModal!),
                      _salesAndReviews(productModal!),
                      _genderCheck(productModal!),
                      _colorsCheck(productModal!),
                      _productSizes(productModal!),
                      _description(productModal!),
                    ],
                  ),
                ),
              ),
    );
  }
}

Widget _price(ProductModal productModal) {
  return SliverPadding(
    padding: EdgeInsets.only(top: 20, left: 10),
    sliver: SliverToBoxAdapter(
      child: Text(
        'Rs: ${priceFormat(int.parse(productModal.price.toString()))}',
        style: TextStyle(
          fontSize: 20,
          color: Colors.orange,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

Widget _title(ProductModal productModal) {
  return SliverPadding(
    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    sliver: SliverToBoxAdapter(
      child: Text(
        productModal.title.toString(),
        style: TextStyle(fontSize: 17),
      ),
    ),
  );
}

Widget _salesAndReviews(ProductModal productModel) {
  return SliverPadding(
    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    sliver: SliverToBoxAdapter(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Flexible(child: Icon(Icons.star, color: Colors.amber)),
          Flexible(
            child: RatingBarIndicator(
              rating: productModel.reviews ?? 0.0,
              itemSize: 20,
              itemCount: 5,

              itemBuilder:
                  (context, index) => Icon(Icons.star, color: Colors.amber),
            ),
          ),
          Flexible(
            child: Text(
              ' ${productModel.reviews!.toStringAsFixed(1)} (${productModel.totalRatedUser})  |  ${(productModel.solds == null) ? '0' : productModel.solds} sold',
              maxLines: 1,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _description(ProductModal productModal) {
  return SliverPadding(
    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    sliver: SliverToBoxAdapter(
      child: Column(
        children: [
          const Row(
            children: [
              Text(
                'Description',
                style: TextStyle(
                  color: Color.fromARGB(255, 152, 152, 152),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(productModal.description.toString()),
        ],
      ),
    ),
  );
}

Widget _genderCheck(ProductModal productModal) {
  return SliverPadding(
    padding: EdgeInsets.symmetric(horizontal: 10),
    sliver: SliverToBoxAdapter(
      child: Consumer(
        builder: (context, ref, child) {
          return Wrap(
            children:
                productModal.genders!.map((e) {
                  return Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: GenderCetagoryCollectionBtn(title: e, onTap: () {}),
                  );
                }).toList(),
          );
        },
      ),
    ),
  );
}

Widget _colorsCheck(ProductModal productModal) {
  return SliverPadding(
    padding: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
    sliver: SliverToBoxAdapter(
      child: Wrap(
        children:
            productModal.colors!.map((e) {
              var data = getColors(e);
              return Consumer(
                builder: (context, ref, child) {
                  var isColorChecked = ref.watch(
                    colorsCollectionForUserViewProductPageProvider,
                  );
                  return ColorsCollectionFoUserViewProduct(
                    isClicked: isColorChecked == e,
                    color: data.color,
                    onTap: () {},
                  );
                },
              );
            }).toList(),
      ),
    ),
  );
}

Widget _productSizes(ProductModal productModal) {
  return SliverPadding(
    padding: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
    sliver: SliverToBoxAdapter(
      child: Wrap(
        children:
            productModal.shoesSizes!.map((e) {
              return CircleSizeWidget(
                title: e.toString(),
                index: e,
                onTap: () => '',
              );
            }).toList(),
      ),
    ),
  );
}

final cartViewProductOrHomeProvider =
    StreamProvider.family<ProductModal, String>((ref, id) {
      var db = FirebaseFirestore.instance.collection('products').doc(id);

      return db.snapshots().map((event) => ProductModal.fromMap(event.data()!));
    });
