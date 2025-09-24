import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/controllers/users%20controller/pending_orders_riverpod.dart';
import 'package:sneak_peak/models/cart_poduct_modal.dart';
import 'package:sneak_peak/models/products_modals.dart';
import 'package:sneak_peak/pages/user%20screens/cart%20page/this%20controllers/check_and_selected_data_list_riverpod.dart';
import 'package:sneak_peak/pages/user%20screens/payment%20method%20page/payment_meth_page.dart';
import 'package:sneak_peak/pages/user%20screens/pending%20order%20page/this_controllers/pending_stream_provider.dart';
import 'package:sneak_peak/pages/user%20screens/pending%20order%20page/widgets/no_pending_widget.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/dialog%20boxes/remove_dialog_.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';
import 'package:sneak_peak/widgets/animated%20loading/animated_loading_widget.dart';
import 'package:sneak_peak/widgets/custom%20card%20widget/custom_card_widget.dart';
import 'package:sneak_peak/widgets/custom%20sliver%20app%20bar/custom_sliverappbar.dart';

class PendingOrders extends ConsumerStatefulWidget {
  const PendingOrders({super.key});
  static const pageName = 'pending_orderZ';
  @override
  ConsumerState<PendingOrders> createState() => _PendingOrdersState();
}

class _PendingOrdersState extends ConsumerState<PendingOrders> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.invalidate(selectedDataList);
      ref.invalidate(itemCheckProvider);
      ref.invalidate(pendingStreamProvider);
      
    });
  }

  @override
  Widget build(BuildContext contextX) {
    print('PENDING ORDERS BUILD CALLED');
     ref.listen(pendingOrdersProvider, (previous, next) {
      if (next!='init'&&next!='loading'&&next!='done') {
        SnackBarHelper.show(next, color: Colors.red);
      }
    },);
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            CustomSliverAppBar(
              leadingOnTap: () => GoRouter.of(context).pop(),
              leadingIcon: CupertinoIcons.back,
              title: 'Pendings',
            ),

            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: Consumer(
                    builder: (context, x, child) {
                      
                      var peningList = x.watch(pendingStreamProvider);

                    return peningList.when(
                      data: (data) => _dataWidget(contextX, data, x),
                       error: (error, stackTrace) => Text(error.toString()),
                        loading: () => const AnimatedLoadingWidget());
                    
                    },
                  ),
                ),
              ),
            ),
            const NoPendingWidget(),
          ],
        ),
      ),
    );
  }

  Widget _dataWidget(BuildContext contextX, List<CartProductModal> list, WidgetRef x) {
    
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: list.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 230,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        var cartModal = list[list.length-1-index];
        var productModel = ProductModal(
          brand: cartModal.brand,
          colors: cartModal.colors,
          description: cartModal.description,
          genders: cartModal.genders,
          id: cartModal.id,
          img: cartModal.img,
          price: cartModal.price,
          shoesSizes: cartModal.shoesSizes,
          storageImgsPath: cartModal.storageImgsPath,
          title: cartModal.title,
          isProductExist: cartModal.isProductExist,
          reviews: cartModal.reviews,
          solds: cartModal.solds,
          quantity: cartModal.quantity
        );
        return CustomCardWidget(
          productModal: productModel,
          onTap: ()async{
          if (productModel.isProductExist!) {
              await ref.read(selectedDataList.notifier).toggeled(true, cartModal);
            var selectedList = x.watch(selectedDataList).cartList;
            
            GoRouter.of(context).pushNamed(PaymentMethPage.pageName, extra: {'cartList':selectedList, 'pendingPageOrNot': true} as Map<String, dynamic>);
          }  
          
          },
          onRemove: () {
            deleteDialog(
              context,
              onDel: () async {
                Navigator.pop(contextX);
                loadingDialog(contextX, 'Cancelling your order...');
            var isDeleted= await ref.read(pendingOrdersProvider.notifier).deletePendingOrder(cartModal,);
              Navigator.pop(contextX);
              if (isDeleted) {
                  SnackBarHelper.show('Order cancel successfuly');
              }
              },
              title: 'Cancel Order?',
              descripton: 'Wanna cancel your order',
              btnTitle: 'Cancel order',
            );
          },
          icon: Icons.remove_circle,
          color: Colors.red,
          pendingOrderText: ' |  Qty: ${cartModal.quantity}',
        );
      },
    );
  }
}
