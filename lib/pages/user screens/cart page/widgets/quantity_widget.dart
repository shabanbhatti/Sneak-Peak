import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/controllers/users%20controller/product%20quantity%20riverpod/product_quantity_riverpod.dart';
import 'package:sneak_peak/models/cart_poduct_modal.dart';
import 'package:sneak_peak/pages/user%20screens/cart%20page/this%20controllers/check_and_selected_data_list_riverpod.dart';

class QuantityCartWidget extends ConsumerWidget {
  const QuantityCartWidget(this.cartModal, {super.key});
  final CartProductModal cartModal;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isChecked = ref.watch(itemCheckProvider(cartModal.id ?? ''));

    return Flexible(
      child: Container(
        height: 35,
        width: 100,

        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.grey.withAlpha(50)),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: GestureDetector(
                onTap: () {
                  if (isChecked) {
                    ref
                        .read(itemCheckProvider(cartModal.id ?? '').notifier)
                        .state = false;
                    ref
                        .read(selectedDataList.notifier)
                        .toggeled(false, cartModal);
                  }
                  ref
                      .read(quantityAddRemoveProvider.notifier)
                      .decreaseNumber(
                        cartModal.id ?? '',
                        cartModal.quantity ?? 1,
                        int.parse(cartModal.price!),
                        context,
                      );
                },
                child: Icon(
                  Icons.remove_circle,
                  color:
                      (cartModal.quantity == 1)
                          ? Colors.orange.withAlpha(150)
                          : Colors.orange,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  transitionBuilder:
                      (child, animation) =>
                          SlideTransition(position: animation.drive(Tween(begin: Offset(0.0, 0.5), end: Offset.zero)), child: child),
                  child: Text(cartModal.quantity.toString(), key: ValueKey(cartModal.quantity),),
                ),
              ),
            ),

            Expanded(
              flex: 5,
              child: GestureDetector(
                onTap: () {
                  if (isChecked) {
                    ref
                        .read(selectedDataList.notifier)
                        .toggeled(false, cartModal);
                    ref
                        .read(itemCheckProvider(cartModal.id ?? '').notifier)
                        .state = false;
                  }
                  ref
                      .read(quantityAddRemoveProvider.notifier)
                      .addNumber(
                        cartModal.id ?? '',
                        cartModal.quantity ?? 1,
                        int.parse(cartModal.price!),
                        context,
                      );
                },
                child: Icon(
                  Icons.add_circle,
                  color:
                      (cartModal.quantity == 5)
                          ? Colors.orange.withAlpha(100)
                          : Colors.orange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
