import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/models/cart_poduct_modal.dart';
import 'package:sneak_peak/pages/admin%20screens/add%20product%20page/Widgets/circle_size_widget.dart';
import 'package:sneak_peak/pages/user%20screens/view%20product%20page/this%20contoller/selected_color%20riverpod.dart';
import 'package:sneak_peak/pages/user%20screens/view%20product%20page/widgets/color_collection_widget.dart';
import 'package:sneak_peak/utils/colors&names_records.dart';
import 'package:sneak_peak/utils/price_format.dart';

class SelectionPageCardWidget extends StatelessWidget {
  const SelectionPageCardWidget({super.key, required this.cartModal});

  final CartProductModal cartModal;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Container(
        height: 230,
        width: double.infinity,
        decoration: BoxDecoration(
          // color:
          //     Theme.of(context).scaffoldBackgroundColor == Colors.black
          //         ? const Color.fromARGB(255, 42, 42, 42)
          //         : const Color.fromARGB(255, 231, 231, 231),
          border: Border(
            bottom: BorderSide(color: Colors.grey.withAlpha(100), width: 1),
          ),
        ),
        child: Row(
          children: [
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  height: 100,
                  width: 100,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: cartModal.img![0],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 0),
                child: Container(
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 5,
                    children: [
                      Flexible(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Text(
                              'Rs. ${priceFormat(int.parse(cartModal.price.toString()))}',
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children:
                              cartModal.colors!.map((e) {
                                var data = getColors(e);
                                return Consumer(
                                  builder: (context, ref, child) {
                                    var isColorChecked = ref.watch(
                                      colorsCollectionForUserViewProductPageProvider1,
                                    );
                                    return Padding(
                                      padding: EdgeInsets.all(1),
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: ColorsCollectionFoUserViewProduct(
                                          isClicked:
                                              isColorChecked == data.colorName,
                                          color: data.color,
                                          onTap: () {
                                            ref
                                                .read(
                                                  colorsCollectionForUserViewProductPageProvider1
                                                      .notifier,
                                                )
                                                .isChecked(e)
                                                .then((value) {
                                                  ref
                                                      .read(
                                                        selectedColorProvider
                                                            .notifier,
                                                      )
                                                      .addColor(e);
                                                });
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                        ),
                      ),

                      Flexible(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children:
                              cartModal.shoesSizes!.map((e) {
                                return CircleSizeWidget(
                                  size: 20,
                                  fontSIze: 10,
                                  title: e.toString(),
                                  index: e,
                                  onTap: () => '',
                                );
                              }).toList(),
                        ),
                      ),

                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Wrap(
                            children:
                                cartModal.genders!.map((e) {
                                  return Padding(
                                    padding: EdgeInsets.all(5),
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Text(
                                        e,
                                        style: const TextStyle(
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                    ],
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
