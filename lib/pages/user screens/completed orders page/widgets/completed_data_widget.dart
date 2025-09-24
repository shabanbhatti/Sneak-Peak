import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sneak_peak/controllers/cross%20fade%20anim%20riverpod/cross_fade_anim_riverpod.dart';
import 'package:sneak_peak/pages/user%20screens/to%20ship%20page/controllers/to_ship_stream_riverpod.dart';
import 'package:sneak_peak/pages/user%20screens/view%20orders%20page/view_order_page.dart';
import 'package:sneak_peak/utils/constant_steps.dart';
import 'package:sneak_peak/utils/constants_colors.dart';
import 'package:sneak_peak/utils/constants_imgs_paths.dart';
import 'package:sneak_peak/utils/date_time_constant_formats.dart';

class CompletedDataWidget extends StatelessWidget {
  const CompletedDataWidget({super.key});

  @override
  Widget build(BuildContext contextX) {
    return SliverToBoxAdapter(
      child: Center(
        child: Consumer(
          builder: (context, x, child) {
            
            var streamList = x.watch(toShipStreamProvider);

            var dataList = x.watch(toShipStreamProvider).value ?? [];
            var list =
                dataList
                    .where((element) => element.deliveryStatus == delivered)
                    .toList();
            var crossFade = x.watch(crossFadeProvider);
            return streamList.when(
              data:
                  (z) => ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    reverse: true,
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      var productList = list[index].productsList ?? [];
                      return ListTile(
                        onTap:
                            () => GoRouter.of(context).pushNamed(
                              ViewOrderPage.pageName,
                              extra: list[index],
                            ),
                        leading: Container(
                          height: 50,
                          width: 50,
                          alignment: Alignment.center,
                          decoration: ShapeDecoration(
                            shape: const CircleBorder(),
                          ),
                          child:
                              (productList[0].isProductExist!)
                                  ? CachedNetworkImage(
                                    imageUrl:
                                        list[index].productsList![0].img![0],
                                  )
                                  : Image.asset(outOfStockImg)
                        ),
                        title: Text('Tap to view order'),
                        subtitle: AnimatedCrossFade(
                          firstChild: Text(
                            (productList.length > 1)
                                ? '${productList.length} products COMPLETED.'
                                : '${productList.length} product COMPLETED.',
                            maxLines: 1,
                            style: TextStyle(color: appGreyColor),
                          ),
                          secondChild: Text(
                            '✅: ${list[index].deliveryStatus}',
                            maxLines: 1,
                            style: TextStyle(color: appGreyColor),
                          ),
                          crossFadeState: crossFade,
                          duration: const Duration(seconds: 1),
                        ),
                        trailing: Text(dateFormat(list[index].timeDate ?? '')),
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
    );
  }
}
