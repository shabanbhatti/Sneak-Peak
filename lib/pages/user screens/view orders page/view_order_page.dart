import 'package:another_stepper/another_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/models/orders_modals.dart';
import 'package:sneak_peak/pages/user%20screens/view%20orders%20page/controllers/orders_riverpod.dart';
import 'package:sneak_peak/pages/user%20screens/view%20orders%20page/widgets/for%20completed%20page/completed_card_widget.dart';
import 'package:sneak_peak/pages/user%20screens/view%20orders%20page/widgets/for%20to%20ship%20page/view_to_ship_orders_cards.dart';
import 'package:sneak_peak/utils/constant_steps.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/dialog%20boxes/remove_dialog_.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';
import 'package:sneak_peak/widgets/custom%20btn/custom_button.dart';
import 'package:sneak_peak/widgets/custom%20sliver%20app%20bar/custom_sliverappbar.dart';

class ViewOrderPage extends ConsumerStatefulWidget {
  const ViewOrderPage({super.key, required this.ordersModals});
  static const pageName = 'view_toship_orders';
  final OrdersModals ordersModals;

  @override
  ConsumerState<ViewOrderPage> createState() => _ViewToShipOrderPageState();
}

class _ViewToShipOrderPageState extends ConsumerState<ViewOrderPage> {
  @override
  Widget build(BuildContext context) {
    print('view order page build called');
    var list = widget.ordersModals.productsList ?? [];
    ref.listen(ordersProvider, (previous, next) {
      if (next != 'loading' && next != 'init' && next != 'done') {
        SnackBarHelper.show(next, color: Colors.red);
      }
    });
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            CustomSliverAppBar(
              title: 'View order',
              leadingOnTap: () => GoRouter.of(context).pop(),
              leadingIcon: CupertinoIcons.back,
            ),
            SliverToBoxAdapter(
              child: Center(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder:
                      (context, index) =>
                          (widget.ordersModals.deliveryStatus != delivered)
                              ? ViewToShipOrdersCardsWidgets(
                                cartModal: list[index],
                                ordersModals: widget.ordersModals,
                              )
                              : CompletedCardsWidgets(
                                cartModal: list[index],
                                ordersModals: widget.ordersModals,
                              ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              sliver: SliverToBoxAdapter(
                child: AnotherStepper(
                  stepperList: stepperList(),
                  stepperDirection: Axis.vertical,
                ),
              ),
            ),

            SliverToBoxAdapter(
              child:
                  (widget.ordersModals.deliveryStatus != delivered)
                      ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: CustomButton(
                          btnTitle: 'Cancel order',
                          onTap: () {
                            if (widget.ordersModals.deliveryStatus !=
                                    dispatched &&
                                widget.ordersModals.deliveryStatus !=
                                    outOfDelivery) {
                              deleteDialog(
                                context,
                                onDel: () async {
                                  Navigator.pop(context);
                                  loadingDialog(
                                    context,
                                    'Cancelling your order...',
                                  );
                                  var isDeleted = await ref
                                      .read(ordersProvider.notifier)
                                      .cancelOrder(
                                        widget.ordersModals.id ?? '',
                                        widget.ordersModals.productsList ?? [],
                                      );
                                  Navigator.pop(context);
                                  if (isDeleted) {
                                    SnackBarHelper.show(
                                      'Order cancel successfuly',
                                    );
                                    GoRouter.of(context).pop();
                                  }
                                },
                                title: 'Cancel Order?',
                                descripton: 'Wanna cancel your order',
                                btnTitle: 'Cancel order',
                              );
                            } else {
                              SnackBarHelper.show(
                                'You cannot cancel your order because your order got ${widget.ordersModals.deliveryStatus}',
                                duration: const Duration(seconds: 5),
                              );
                            }
                          },
                        ),
                      )
                      : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  List<String> statuses = const [
    preparing,
    dispatched,
    outOfDelivery,
    delivered,
  ];

  List<StepperData> stepperList() {
    int currentIndex = statuses.indexOf(
      widget.ordersModals.deliveryStatus ?? "",
    );

    return List.generate(statuses.length, (index) {
      Color color;
      if (index < currentIndex) {
        color = Colors.green;
      } else if (index == currentIndex) {
        color = (index == 3) ? Colors.green : Colors.orange;
      } else {
        color = Colors.grey;
      }
      Color textColor;
      if (index < currentIndex) {
        textColor = Colors.green;
      } else if (index == currentIndex) {
        textColor =
            (index == 3) ? Colors.green : Theme.of(context).primaryColor;
      } else {
        textColor = Colors.grey;
      }

      String title = "";
      String subtitle = "";

      switch (statuses[index]) {
        case preparing:
          title = "Preparing";
          subtitle = "Preparing your order.";
          break;
        case dispatched:
          title = "Dispatched";
          subtitle = "Your parcel has been handed over.";
          break;
        case outOfDelivery:
          title = "Out for delivery";
          subtitle =
              "Delivery partner is on the way to deliver your parcel today.";
          break;
        case delivered:
          title = "Delivered";
          subtitle = "Your order has been successfully delivered.";
          break;
      }

      return StepperData(
        title: StepperText(
          title,

          textStyle: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        subtitle: StepperText(
          subtitle,
          textStyle: TextStyle(color: textColor, fontSize: 10),
        ),
        iconWidget: Icon(Icons.check_circle, color: color),
      );
    });
  }
}
