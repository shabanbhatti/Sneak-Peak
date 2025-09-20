import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sneak_peak/controllers/admin%20controllers/order%20delivery%20status%20stream%20riverpod/order_delivery_status_riverpod.dart';
import 'package:sneak_peak/controllers/cross%20fade%20anim%20riverpod/cross_fade_anim_riverpod.dart';
import 'package:sneak_peak/pages/admin%20screens/completed%20orders%20page/widgets/no_completed_order_widget.dart';
import 'package:sneak_peak/pages/admin%20screens/orders%20page/controllers/orders_stream_riverpod.dart';
import 'package:sneak_peak/pages/admin%20screens/view%20order%20page/view_admin_order_page.dart';
import 'package:sneak_peak/utils/constant_steps.dart';
import 'package:sneak_peak/utils/constants_colors.dart';
import 'package:sneak_peak/utils/date_time_constant_formats.dart';
import 'package:sneak_peak/widgets/animated%20loading/animated_loading_widget.dart';
import 'package:sneak_peak/widgets/custom%20sliver%20app%20bar/custom_sliverappbar.dart';

class AdminCompletedOrdersPage extends ConsumerStatefulWidget {
  const AdminCompletedOrdersPage({super.key});
  static const pageName = 'admin_completed_orders';

  @override
  ConsumerState<AdminCompletedOrdersPage> createState() =>
      _AdminCompletedOrdersPageState();
}

class _AdminCompletedOrdersPageState
    extends ConsumerState<AdminCompletedOrdersPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(crossFadeProvider.notifier).toggeled();
      ref.invalidate(adminOrdersStreamProvider);
    });
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
              title: 'Completed orders',
            ),

            SliverToBoxAdapter(
              child: Center(
                child: Consumer(
                  builder: (context, x, child) {
                    var crossFade = x.watch(crossFadeProvider);
                    var stream = x.watch(adminOrdersStreamProvider);
                    var streamList = stream.value ?? [];
                    var list =
                        streamList
                            .where(
                              (element) => element.deliveryStatus == delivered,
                            )
                            .toList();
                    return stream.when(
                      data: (data) {
                        return ListView.builder(
                          shrinkWrap: true,
                          reverse: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            var productList = list[index].productsList ?? [];
                            return ListTile(
                              onTap:
                                  () => GoRouter.of(context).pushNamed(
                                    ViewAdminOrderPage.pageName,
                                    extra: list[index],
                                  ),
                              leading: CircleAvatar(
                                backgroundColor: Colors.green,
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 30,
                                ),
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
                              subtitle: AnimatedCrossFade(
                                firstChild: Text(
                                  (productList.length > 1)
                                      ? '(${productList.length}) items ordered by user'
                                      : '(${productList.length}) item ordered by user',
                                  style: TextStyle(color: appGreyColor),
                                ),
                                secondChild: Text(
                                  '✅: ${x.watch(orderDeliveryStatusStreamProvider(list[index].id ?? '')).value}',
                                  style: TextStyle(color: appGreyColor),
                                ),
                                crossFadeState: crossFade,
                                duration: const Duration(milliseconds: 500),
                              ),
                              trailing: Text(
                                dateFormat(list[index].timeDate ?? ''),
                              ),
                            );
                          },
                        );
                      },
                      error: (error, stackTrace) => Text(error.toString()),
                      loading: () => const AnimatedLoadingWidget(),
                    );
                  },
                ),
              ),
            ),

            const NoCompletedOrdersWidget(),
          ],
        ),
      ),
    );
  }
}
