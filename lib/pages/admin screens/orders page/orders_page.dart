import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sneak_peak/controllers/admin%20controllers/order%20delivery%20status%20stream%20riverpod/order_delivery_status_riverpod.dart';
import 'package:sneak_peak/controllers/cross%20fade%20anim%20riverpod/cross_fade_anim_riverpod.dart';
import 'package:sneak_peak/models/cart_poduct_modal.dart';
import 'package:sneak_peak/pages/admin%20screens/orders%20page/controllers/orders_stream_riverpod.dart';
import 'package:sneak_peak/pages/admin%20screens/orders%20page/widgets/no_orders_widget.dart';
import 'package:sneak_peak/pages/admin%20screens/view%20orders%20page/view_orders_page.dart';
import 'package:sneak_peak/utils/constant_steps.dart';
import 'package:sneak_peak/utils/constants_colors.dart';
import 'package:sneak_peak/widgets/admin%20app%20bar/admin_app_bar.dart';
import 'package:sneak_peak/widgets/animated%20loading/animated_loading_widget.dart';

class AdminOrdersPage extends ConsumerStatefulWidget {
  const AdminOrdersPage({super.key});
  static const pageName = 'admin_order';

  @override
  ConsumerState<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends ConsumerState<AdminOrdersPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(crossFadeProvider.notifier).toggeled();
      ref.invalidate(adminOrdersStreamProvider);
    });
  }

  String dateFormat(String date) {
    DateTime parsedDate = DateTime.parse(date);
    var format = DateFormat('dd/MM/yyyy').format(parsedDate);

    return format;
  }

  String foo(List<CartProductModal> cartModel) {
    String title = '';
    for (var element in cartModel) {
      title = element.title ?? '';
    }
    return title;
  }

  @override
  Widget build(BuildContext context) {
    print('Admin order page build called');
    return Scaffold(
      appBar: adminAppBar('Orders'),
      body: Center(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Consumer(
                builder: (context, x, child) {
                  var crossFade = x.watch(crossFadeProvider);
                  var stream = x.watch(adminOrdersStreamProvider);
                  var streamList = stream.value ?? [];
                  var list =
                      streamList
                          .where(
                            (element) => element.deliveryStatus != delivered,
                          )
                          .toList();

                  return stream.when(
                    data:
                        (data) => ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          reverse: true,
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            var productList = list[index].productsList ?? [];
                            return ListTile(
                              onTap: () {
                                GoRouter.of(context).pushNamed(
                                  AdminViewOrdersPage.pageName,
                                  extra: list[index],
                                );
                              },
                              leading: Container(
                                height: 50,
                                width: 50,

                                alignment: Alignment.center,
                                decoration: ShapeDecoration(
                                  color: Colors.grey.withAlpha(100),
                                  shape: CircleBorder(),
                                ),
                                child:
                                    (productList[0].isProductExist == true)
                                        ? CachedNetworkImage(
                                          imageUrl:
                                              list[index]
                                                  .productsList![0]
                                                  .img![0],
                                        )
                                        : const Text(
                                          'Sold out',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                              ),

                              subtitle: AnimatedCrossFade(
                                firstChild: Text(
                                  (productList.length > 1)
                                      ? '(${productList.length}) items ordered by user'
                                      : '(${productList.length}) item ordered by user',
                                  style: TextStyle(color: appGreyColor),
                                ),
                                secondChild: Text(
                                  '⌛: ${x.watch(orderDeliveryStatusStreamProvider(list[index].id ?? '')).value}',
                                  style: TextStyle(color: appGreyColor),
                                ),
                                crossFadeState: crossFade,
                                duration: const Duration(milliseconds: 500),
                              ),
                              title: Text(
                                productList.map((e) => e.title).toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
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

            const NoOrdersWidget(),
          ],
        ),
      ),
    );
  }
}
