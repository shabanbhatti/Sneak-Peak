import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/controllers/users%20controller/address_riverpd.dart';
import 'package:sneak_peak/pages/user%20screens/cart%20page/this%20controllers/check_and_selected_data_list_riverpod.dart';
import 'package:sneak_peak/pages/user%20screens/check%20out%20page/widgets/checkout_card_widget.dart';
import 'package:sneak_peak/pages/user%20screens/check%20out%20page/widgets/top_address_widget.dart';
import 'package:sneak_peak/pages/user%20screens/payment%20method%20page/payment_meth_page.dart';
import 'package:sneak_peak/utils/constants_colors.dart';
import 'package:sneak_peak/utils/price_format.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';
import 'package:sneak_peak/widgets/custom%20btn/custom_button.dart';
import 'package:sneak_peak/widgets/custom%20sliver%20app%20bar/custom_sliverappbar.dart';

class CheckOutPage extends ConsumerStatefulWidget {
  const CheckOutPage({super.key});
  static const pageName = 'check_out';

  @override
  ConsumerState<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends ConsumerState<CheckOutPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(addressProvider.notifier).getAddress();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomBar(),
      body: Center(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _appBar(context),
            const SliverToBoxAdapter(child: TopAddressWidget()),

            SliverToBoxAdapter(
              child: Consumer(
                builder: (context, x, child) {
                  var dataList = x.watch(selectedDataList).cartList;
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    reverse: true,
                    shrinkWrap: true,
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      var cartData = dataList[index];

                      return CheckoutCardWidget(cartModal: cartData);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return CustomSliverAppBar(
      titleWidget: Consumer(
        builder: (context, x, child) {
          var selectedItemList = x.watch(selectedDataList);
          return Text('Checkout (${selectedItemList.cartList.length})');
        },
      ),
      leadingOnTap: () => GoRouter.of(context).pop(),
      leadingIcon: CupertinoIcons.back,
    );
  }
}

Widget _bottomBar() {
  return Container(
    width: double.infinity,
    height: 70,
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(width: 1, color: Colors.grey.withAlpha(100)),
        top: BorderSide(color: Colors.grey.withAlpha(100), width: 1),
      ),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            flex: 8,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(child: Text('Total:  ', maxLines: 1)),
                        Flexible(
                          child: Consumer(
                            builder: (context, y, child) {
                              var totalPrice = y.watch(selectedDataList);
                              return Text(
                                'Rs. ${priceFormat(totalPrice.totalPrice + 160)}',
                                maxLines: 1,
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Text(
                      '(Rs.160 delivery charges included)',
                      style: TextStyle(color: appGreyColor, fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child:SizedBox(
                  width: 140,
                  child: Consumer(
                    builder: (context, x, child) {
                      var selectedList = x.watch(selectedDataList).cartList;
                      var address= x.watch(addressProvider);
                      return CustomButton(
                        btnTitle: 'Place order',
                        onTap: () {
                          if (address is LoadedSuccessfulyAddressState) {
                         if (address.addressModal!=null) {
                           GoRouter.of(context).pushNamed(PaymentMethPage.pageName,extra: {'cartList':selectedList, 'pendingPageOrNot': false} as Map<String, dynamic>);     
                         } else{
                          SnackBarHelper.show('Please add your delivery address', color: Colors.red);
                         }  }
                        },
                      );
                    },
                  ),
                )
          ),
        ],
      ),
    ),
  );
}
