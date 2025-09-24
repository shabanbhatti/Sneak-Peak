import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/controllers/users%20controller/address_riverpd.dart';
import 'package:sneak_peak/models/address_modal.dart';
import 'package:sneak_peak/pages/user%20screens/address%20page/address_page.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/dialog%20boxes/remove_dialog_.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';

class TopAddressWidget extends ConsumerWidget {
  const TopAddressWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var address = ref.watch(addressProvider);
    if (address is LoadingAddressState) {
      return CupertinoActivityIndicator();
    } else if (address is InitialAddressState) {
      return Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            Size size = Size(constraints.maxWidth, constraints.maxHeight);
            return SizedBox(
              width: size.width * 0.9,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.orange, width: 2),
                ),
                onPressed: () {
                  GoRouter.of(
                    context,
                  ).pushNamed(AddHomeAddress.pageName, extra: AddressModal());
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home, color: Colors.orange, size: 20),
                    Text(
                      ' Add your delivery addess',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    } else if (address is LoadedSuccessfulyAddressState) {
      var data = address;
      if (data.addressModal == null) {
        return Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              Size size = Size(constraints.maxWidth, constraints.maxHeight);
              return SizedBox(
                width: size.width * 0.9,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.orange, width: 2),
                  ),
                  onPressed: () {
                    GoRouter.of(
                      context,
                    ).pushNamed(AddHomeAddress.pageName, extra: AddressModal());
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.home, color: Colors.orange, size: 20),
                      Text(
                        ' Add your delivery addess',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      } else {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: InkWell(
            overlayColor: WidgetStatePropertyAll(Colors.transparent),
            onTap: () {
              GoRouter.of(
                context,
              ).pushNamed(AddHomeAddress.pageName, extra: data.addressModal);
            },
            child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey.withAlpha(150)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () {
                        deleteDialog(
                          context,
                          onDel: () async{
                            Navigator.pop(context);
                            loadingDialog(context, 'Removing address...');
                            var isRemove= await ref.read(addressProvider.notifier).removeAddress();
                               Navigator.pop(context);
                               if (isRemove) {
                                
                                 SnackBarHelper.show('Address deleted successfuly');
                               }
                                  
                                
                          },
                          title: 'Remove address?',
                          descripton: 'Wanna remove address?',
                          btnTitle: 'Remove',
                        );
                      },
                      icon: Icon(Icons.remove_circle, color: Colors.red),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: const CircleAvatar(
                                backgroundColor: Colors.orange,
                                child: Icon(
                                  Icons.place_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        flex: 7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              child: Text(
                                data.addressModal!.name ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            Flexible(
                              child: Text(
                                '${data.addressModal!.address} ${data.addressModal!.city} ${data.addressModal!.region}',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                'Cetagory: ${data.addressModal!.addressCetaory ?? ''}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                data.addressModal!.phoneNumber ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }
    } else {
      return const SizedBox();
    }
  }
}
