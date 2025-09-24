import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sneak_peak/controllers/users%20controller/cart_riverpod.dart';
import 'package:sneak_peak/controllers/users%20controller/product_quantity_riverpod.dart';
import 'package:sneak_peak/pages/user%20screens/cart%20page/this%20controllers/cart_stream_provider.dart';
import 'package:sneak_peak/pages/user%20screens/cart%20page/this%20controllers/check_and_selected_data_list_riverpod.dart';
import 'package:sneak_peak/pages/user%20screens/cart%20page/widgets/cart_card_widget.dart';
import 'package:sneak_peak/pages/user%20screens/cart%20page/widgets/no_cart_added_widget.dart';
import 'package:sneak_peak/pages/user%20screens/check%20out%20page/check_out_page.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/price_format.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';
import 'package:sneak_peak/widgets/custom%20btn/custom_button.dart';
import 'package:sneak_peak/widgets/custom%20card%20widget/loading_card_widget.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.invalidate(cartStreamProvider));
  }

  @override
  Widget build(BuildContext contextX) {
    print('cart page build called');
    ref.listen(cartProvider, (previous, next) {
      if (next!='loading'&& next!='done'&&next!='init') {
        SnackBarHelper.show(next, color: Colors.red);
      }
    },);
    ref.listen(productQuantityProvider, (previous, next) {
      
        if (next!='loading'&& next!='done'&&next!='init') {
        SnackBarHelper.show(next, color: Colors.red);
      
      }
    },);
    return Scaffold(
      bottomNavigationBar: _bottomBar(),
      body: Center(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _appBar(context),

            SliverToBoxAdapter(
              child: Center(
                child: Consumer(
                  builder: (context, x, child) {
                    var streamList = x.watch(cartStreamProvider);
                    return streamList.when(
                      data:
                          (data) => ListView.builder(
                            reverse: true,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder:
                                (context, index) => Slidable(
                                  key: ValueKey(data[index].id),
                                  closeOnScroll: false,

                                  endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) async{
                                          loadingDialog(context, 'Deleting...');
                                         await ref.read(cartProvider.notifier).deleteCart(data[index].id ?? '',);
                                         Navigator.pop(contextX);
                                         
                                        },
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: 'Delete',
                                      ),
                                    ],
                                  ),
                                  child: CartCardWidget(cartModal: data[index]),
                                ),
                          ),
                      error: (error, stackTrace) => Text(error.toString()),
                      loading:
                          () => ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: List.generate(50, (index) => '').length,
                            itemBuilder:
                                (context, index) => const Skeletonizer(
                                  child: LoadingCardWidget(),
                                ),
                          ),
                    );
                  },
                ),
              ),
            ),
            const NoCartAddedWidget(),
          ],
        ),
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return SliverAppBar(
      centerTitle: true,
      title: const Text('Cart'),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floating: true,
      snap: true,
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer(
                builder: (context, x, _) {
                  
                  var streamList =
                      x.watch(cartStreamProvider).value ?? [];
                  var selectedList = x.watch(selectedDataList);
                  return (streamList.isNotEmpty &&
                          selectedList.cartList.isNotEmpty)
                      ? IconButton(
                        onPressed: ()async{
                          loadingDialog(context, 'Deleting...');
                      var isDeleted= await x.read(selectedDataList.notifier).deleteCartProducts();
                          Navigator.pop(context);
                          if (isDeleted) {
                            SnackBarHelper.show('Delete successfully');
                          }else{
                            SnackBarHelper.show('Something went wrong.');
                          }
                        },
                        icon: const Icon(CupertinoIcons.delete),
                      )
                      : const SizedBox();
                },
              ),
            ],
          ),
        ),
      ],
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
                        Flexible(child: Text('Subtotal:  ', maxLines: 1)),
                        Flexible(
                          child: Consumer(
                            builder: (context, y, child) {
                              var totalPrice = y.watch(selectedDataList);
                              return Text(
                                'Rs. ${priceFormat(totalPrice.totalPrice)}',
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
                  const Expanded(
                    child: Row(
                      children: [
                        Flexible(child: Text('Shipping Fee: ', maxLines: 1)),
                        Flexible(
                          child: Text(
                            'Rs.160',
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Consumer(
              builder: (context, x, child) {
                var selectedList = x.watch(selectedDataList);
                return SizedBox(
                  width: 140,
                  child: Consumer(
                    builder: (context, x, child) {
                      var selectedItemList = x.watch(selectedDataList);
                      return CustomButton(
                        btnTitle: 'Check out (${selectedList.cartList.length})',
                        onTap: () {
                          if (selectedItemList.cartList.isNotEmpty) {
                            GoRouter.of(
                              context,
                            ).pushNamed(CheckOutPage.pageName);
                          } else {
                            SnackBarHelper.show(
                              'Please select items',
                              color: Colors.red,
                            );
                          }
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
