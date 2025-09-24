import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/controllers/users%20controller/cart_riverpod.dart';
import 'package:sneak_peak/models/products_modals.dart';
import 'package:sneak_peak/pages/user%20screens/selection%20page/selection_page.dart';
import 'package:sneak_peak/pages/user%20screens/view%20product%20page/view_product_page.dart';
import 'package:sneak_peak/widgets/custom%20btn/custom_button.dart';

class BottomBarButtonsWidget extends StatelessWidget {
  const BottomBarButtonsWidget({super.key, this.productModal, this.id});

final ProductModal? productModal;
final String? id;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(
            bottom: BorderSide(width: 1, color: Colors.grey.withAlpha(100)),
            top: BorderSide(color: Colors.grey.withAlpha(100), width: 1),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 7),
                child: Consumer(builder: (context, x, child) {
                  
                  return CustomButton(btnTitle: 'Buy now', onTap: (){
                   if (productModal!=null) {
                          selectionBottomSheet(context, productModal!, 'BUY', ref: x);
                        }else{
                          var streamProductModal= x.watch(cartViewProductOrHomeProvider(id??'')).value??ProductModal();
                          selectionBottomSheet(context, streamProductModal, 'BUY', ref: x);
                        }
                });
                },)
              ),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 7),
                child: Consumer(
                  builder: (context, x, child) {
                    var loading = x.watch(cartProvider);
                    
                    return CustomButton(
                      onTap: () {
                        
                        if (productModal!=null) {
                          selectionBottomSheet(context, productModal!, 'CART');
                        }else{
                          var streamProductModal= x.watch(cartViewProductOrHomeProvider(id??'')).value??ProductModal();
                          selectionBottomSheet(context, streamProductModal,'CART');
                        }
                       
                      },
                      btnTitleWidget: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            (loading == 'loading')
                                ? const [
                                  CupertinoActivityIndicator(
                                    color: Colors.white,
                                  ),
                                ]
                                : const [
                                  Flexible(
                                    child: Icon(
                                      Icons.shopping_bag,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Flexible(
                                    child: FittedBox(
                                      child: Text(
                                        '  Add to cart',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
  }
}