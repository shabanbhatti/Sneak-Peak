import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sneak_peak/controllers/users%20controller/address_riverpd.dart';
import 'package:sneak_peak/models/orders_modals.dart';
import 'package:sneak_peak/utils/constants_colors.dart';

class AddressCardWidget extends StatelessWidget {
  const AddressCardWidget({super.key, required this.ordersModals});
final OrdersModals ordersModals;
  @override
  Widget build(BuildContext context) {
    return  SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: Container(
                    height: 330,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: appGreyColor, width: 0.5),
                      color: Colors.grey.withAlpha(50),
                    ),
                    child: Consumer(
                      builder: (context, x, child) {
                        var address = x.watch(addressProvider);
                        if (address is LoadingAddressState) {
                          return LoadingAnimationWidget.flickr(
                            leftDotColor: Colors.orange,
                            rightDotColor: Colors.blue,
                            size: 35,
                          );
                        } else if (address is LoadedSuccessfulyAddressState) {
                          var myAddress = address.addressModal;
                          return Column(
                            children: [
                              _rowAddressWidget('Name', myAddress?.name ?? ''),

                              _rowAddressWidget(
                                'Uid',
                                ordersModals.userUid ?? '',
                              ),

                              _rowAddressWidget(
                                'Address',
                                myAddress?.address ?? '',
                              ),

                              _rowAddressWidget(
                                'Phone',
                                myAddress?.phoneNumber ?? '',
                              ),

                              _rowAddressWidget('City', myAddress?.city ?? ''),

                              _rowAddressWidget(
                                'Region',
                                myAddress?.region ?? '',
                              ),

                              _rowAddressWidget(
                                'Cetagory',
                                myAddress?.addressCetaory ?? '',
                              ),
                            ],
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ),
                ),
              ),
            );
  }
}

Widget _rowAddressWidget(String title, String value) {
  return Expanded(
    child: Padding(
      padding: EdgeInsets.only(left: 5),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$title: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 8,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: Colors.orange,
                decoration: TextDecoration.underline,
                decorationColor: Colors.orange,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );
}
