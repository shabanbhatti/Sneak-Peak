import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/controllers/users%20controller/address%20riverpod/address_riverpd.dart';
import 'package:sneak_peak/models/orders_modals.dart';
import 'package:sneak_peak/pages/admin%20screens/view%20orders%20page/widgets/address_card_widget.dart';
import 'package:sneak_peak/pages/admin%20screens/view%20orders%20page/widgets/order_card_widget.dart';
import 'package:sneak_peak/pages/admin%20screens/view%20orders%20page/widgets/stepper_widget.dart';
import 'package:sneak_peak/widgets/custom%20sliver%20app%20bar/custom_sliverappbar.dart';

class AdminViewOrdersPage extends ConsumerStatefulWidget {
  const AdminViewOrdersPage({super.key, required this.ordersModals});
  static const pageName = 'admin_view-order';
  final OrdersModals ordersModals;

  @override
  ConsumerState<AdminViewOrdersPage> createState() =>
      _AdminViewOrdersPageState();
}

class _AdminViewOrdersPageState extends ConsumerState<AdminViewOrdersPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref
          .read(addressProvider.notifier)
          .getAddressFromOrderPage(widget.ordersModals.userUid ?? ''),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('view order admin build called');
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _appbar(),
            AddressCardWidget(ordersModals: widget.ordersModals),
            _products(),
            AdminStepperWidget(ordersModals: widget.ordersModals),
          ],
        ),
      ),
    );
  }

  Widget _products() {
    return SliverToBoxAdapter(
      child: Center(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.ordersModals.productsList!.length,
          itemBuilder:
              (context, index) => OrdersCardsWidgets(
                cartModal: widget.ordersModals.productsList![index],
                ordersModals: widget.ordersModals,
              ),
        ),
      ),
    );
  }

  Widget _appbar() {
    var list = widget.ordersModals.productsList ?? [];
    return CustomSliverAppBar(
      leadingOnTap: () => GoRouter.of(context).pop(),
      leadingIcon: CupertinoIcons.back,
      title:
          (list.length > 1)
              ? '(${widget.ordersModals.productsList?.length}) items'
              : '(${widget.ordersModals.productsList?.length}) item',
    );
  }
}
