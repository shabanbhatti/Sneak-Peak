import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sneak_peak/models/products_modals.dart';
import 'package:sneak_peak/utils/constant_imgs.dart';
import 'package:sneak_peak/utils/price_format.dart';

class CustomCardWidget extends StatelessWidget {
  const CustomCardWidget({
    super.key,
    required this.productModal,
    required this.onTap,
    required this.onRemove,
    this.icon = Icons.cancel,
    this.color = Colors.orange,
    this.pendingOrderText = '',
  });
  final ProductModal productModal;
  final void Function() onTap;
  final void Function() onRemove;
  final IconData? icon;
  final Color? color;
  final String pendingOrderText;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(150),
              offset: const Offset(0, 1),
              blurStyle: BlurStyle.outer,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              flex: 10,
              child: Container(
                // color: Colors.grey.withAlpha(50),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    (productModal.isProductExist!)
                        ? CachedNetworkImage(
                          imageUrl:
                              (productModal.img == null|| productModal.img!.isEmpty)
                                  ? noImgUrl
                                  : productModal.img![0],
                          fit: BoxFit.cover,

                          width: double.infinity,
                          height: double.infinity,
                          progressIndicatorBuilder:
                              (context, url, progress) => Skeletonizer(
                                enabled: true,
                                child: Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  color: Colors.grey,
                                ),
                              ),
                        )
                        : Opacity(
                          opacity: (productModal.isProductExist!) ? 1.0 : 0.5,
                          child: Image.asset('assets/images/sold_out.png'),
                        ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: onRemove,
                        icon: Icon(icon, size: 25, color: color),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(flex: 1),
            Expanded(
              flex: 2,
              child: Opacity(
                opacity: (productModal.isProductExist!) ? 1.0 : 0.5,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 7),
                        child: Text(
                          productModal.title ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Opacity(
                opacity: (productModal.isProductExist!) ? 1.0 : 0.5,
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Rs. ${priceFormat(int.parse(productModal.price ?? ''))} $pendingOrderText',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                            fontSize: 14,
                          ),
                        ),
                      ),

                      (pendingOrderText == '')
                          ? Expanded(
                            flex: 3,
                            child: Text(
                              '⭐(${productModal.reviews!.toStringAsFixed(1)})',
                            ),
                          )
                          : Text(''),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
