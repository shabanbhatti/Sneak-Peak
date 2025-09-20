import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/controllers/buy%20product%20riverpod/buy_product_riverpod.dart';
import 'package:sneak_peak/controllers/users%20controller/pending%20orders%20riverpod/pending_orders_riverpod.dart';
import 'package:sneak_peak/models/cart_poduct_modal.dart';
import 'package:sneak_peak/models/orders_modals.dart';
import 'package:sneak_peak/pages/user%20screens/cart%20page/this%20controllers/check_and_selected_data_list_riverpod.dart';
import 'package:sneak_peak/pages/user%20screens/order%20confirmed%20page/order_confrmed_page.dart';
import 'package:sneak_peak/utils/constant_steps.dart';
import 'package:sneak_peak/widgets/custom%20sliver%20app%20bar/custom_sliverappbar.dart';

class PaymentMethPage extends ConsumerWidget {
  const PaymentMethPage({
    super.key,
    required this.cartList,
    this.isFromPendingPayentPage = false,
  });
  static const pageName = 'payment_meth';
  final List<CartProductModal> cartList;
  final bool isFromPendingPayentPage;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('payment method pag build called');
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          slivers: [
            CustomSliverAppBar(
              leadingOnTap: () {
                if (isFromPendingPayentPage) {
                  GoRouter.of(context).pop();
                  ref.invalidate(selectedDataList);
                } else {
                  ref
                      .read(pendingOrdersProvider.notifier)
                      .addToPendingPayments(cartList, context)
                      .then((value) {
                        GoRouter.of(context).pop();
                      });
                }
              },
              leadingIcon: CupertinoIcons.back,
              title: 'Select payment method',
            ),

            SliverToBoxAdapter(
              child: Center(
                child: SizedBox(
                  height: 65,
                  child: ListTile(
                    onTap: ()async {
                    await  ref
                          .read(buyProductProvider.notifier)
                          .buy(
                            context,
                            OrdersModals(
                              deliveryStatus: preparing,
                              paymentStatus: 'Cash on delivery',
                              timeDate: DateTime.now().toString(),
                              productsList: cartList,
                            ),
                          );
                           ref.invalidate(selectedDataList);
                    ref.invalidate(itemCheckProvider);
                           GoRouter.of(
                              context,
                            ).pushNamed(OrderConfirmedPage.pageName);
                          
                    },
                    tileColor: Colors.grey.withAlpha(30),
                    // shape: Border.all(width: 1, color: Colors.grey),
                    leading: Image.asset(
                      'assets/images/cash.png',
                      height: 50,
                      width: 50,
                      fit: BoxFit.contain,
                    ),
                    title: const Text(
                      'Cash on delivery',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      'Cash on delivery',
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
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
