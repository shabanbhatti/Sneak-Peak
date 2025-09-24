import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/controllers/cross%20fade%20anim%20riverpod/cross_fade_anim_riverpod.dart';
import 'package:sneak_peak/pages/user%20screens/to%20ship%20page/controllers/to_ship_stream_riverpod.dart';
import 'package:sneak_peak/pages/user%20screens/to%20ship%20page/widgets/to_ship_no_data_wdget.dart';
import 'package:sneak_peak/pages/user%20screens/view%20orders%20page/view_order_page.dart';
import 'package:sneak_peak/utils/constant_steps.dart';
import 'package:sneak_peak/utils/constants_colors.dart';
import 'package:sneak_peak/utils/constants_imgs_paths.dart';
import 'package:sneak_peak/utils/date_time_constant_formats.dart';
import 'package:sneak_peak/widgets/animated%20loading/animated_loading_widget.dart';
import 'package:sneak_peak/widgets/custom%20sliver%20app%20bar/custom_sliverappbar.dart';

class ToShipPage extends ConsumerStatefulWidget {
  const ToShipPage({super.key});
  static const pageName = 'to_ship';

  @override
  ConsumerState<ToShipPage> createState() => _ToShipPageState();
}

class _ToShipPageState extends ConsumerState<ToShipPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.invalidate(toShipStreamProvider);
      ref.read(crossFadeProvider.notifier).toggeled();
    });
  }

  @override
  Widget build(BuildContext context) {
    print('TO SHIP BUILD CALLED');
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            CustomSliverAppBar(
              leadingOnTap: () => GoRouter.of(context).pop(),
              leadingIcon: CupertinoIcons.back,
              title: 'To ship',
            ),
            SliverToBoxAdapter(
              child: Center(
                child: Consumer(
                  builder: (context, x, child) {
                    
                    var streamList = x.watch(toShipStreamProvider);
                    var dataList =
                        x.watch(toShipStreamProvider).value ?? [];
                    var list =
                        dataList
                            .where(
                              (element) => element.deliveryStatus != delivered,
                            )
                            .toList();
                    var crossFad = x.watch(crossFadeProvider);
                    return streamList.when(
                      data:
                          (z) => ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            reverse: true,
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              var productList = list[index].productsList ?? [];
                              // var isExist= productList[0].isProductExist??true;
                              return ListTile(
                                onTap:
                                    () => GoRouter.of(context).pushNamed(
                                      ViewOrderPage.pageName,
                                      extra: list[index],
                                    ),
                                leading: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: ShapeDecoration(
                                    shape: const CircleBorder(),
                                  ),
                                  child:
                                      (productList[0].isProductExist == true)
                                          ? CachedNetworkImage(
                                            imageUrl: productList[0].img![0],
                                          )
                                          : Image.asset(outOfStockImg)
                                ),
                                title: Text('Tap to view order'),
                                subtitle: AnimatedCrossFade(
                                  firstChild: Text(
                                    (productList.length > 1)
                                        ? '${productList.length} products are in process.'
                                        : '${productList.length} product is in process.',
                                    maxLines: 1,
                                    style: TextStyle(color: appGreyColor),
                                  ),
                                  secondChild: Text(
                                    '✅: ${list[index].deliveryStatus}',
                                    maxLines: 1,
                                    style: TextStyle(color: appGreyColor),
                                  ),
                                  crossFadeState: crossFad,
                                  duration: const Duration(seconds: 1),
                                ),
                                trailing: Text(
                                  dateFormat(list[index].timeDate ?? ''),
                                ),
                              );
                            },
                          ),

                      error: (error, stackTrace) => Text(error.toString()),
                      loading: () => const AnimatedLoadingWidget(),
                    );
                  },
                ),
              ),
            ),
            const ToShipNoDataWdget(),
          ],
        ),
      ),
    );
  }
}
