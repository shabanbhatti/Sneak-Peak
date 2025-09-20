import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/controllers/users%20controller/address%20riverpod/address_riverpd.dart';
import 'package:sneak_peak/models/address_modal.dart';
import 'package:sneak_peak/pages/user%20screens/address%20page/widgets/radio_button_widget.dart';
import 'package:sneak_peak/pages/user%20screens/address%20page/widgets/text_field_address_widget.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';
import 'package:sneak_peak/widgets/custom%20btn/custom_button.dart';
import 'package:sneak_peak/widgets/custom%20sliver%20app%20bar/custom_sliverappbar.dart';

class AddHomeAddress extends ConsumerStatefulWidget {
  const AddHomeAddress({super.key, required this.addressModal});
  static const pageName = 'add_home_address';

  final AddressModal addressModal;
  @override
  ConsumerState<AddHomeAddress> createState() => _AddHomeAddressState();
}

class _AddHomeAddressState extends ConsumerState<AddHomeAddress> {
  TextEditingController recipientController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController regionController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    updateAddress();
  }

  void updateAddress() {
    if (widget.addressModal.name != null) {
      recipientController.text = widget.addressModal.name ?? '';
      cityController.text = widget.addressModal.city ?? '';
      addressController.text = widget.addressModal.address ?? '';
      phoneNumberController.text = widget.addressModal.phoneNumber ?? '';
      regionController.text = widget.addressModal.region ?? '';
      Future.microtask(() {
        ref
            .read(addressCheckboxProvider.notifier)
            .check(widget.addressModal.addressCetaory ?? '');
      });
    }
  }

  @override
  void dispose() {
    recipientController.dispose();
    phoneNumberController.dispose();
    regionController.dispose();
    cityController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          CustomSliverAppBar(
            leadingOnTap: () => GoRouter.of(context).pop(),
            leadingIcon: CupertinoIcons.back,
            title: 'Address',
          ),
          SliverToBoxAdapter(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  TextFieldAddressWidget(
                    controller: recipientController,
                    inputTitle: "Recipient's name",
                    title: 'e.g: (Shaban Bhatti)',
                  ),
                  TextFieldAddressWidget(
                    controller: phoneNumberController,
                    inputTitle: 'Phone number',
                    title: 'e.g: (03146371991)',
                    keyboardType: TextInputType.number,
                  ),
                  TextFieldAddressWidget(
                    controller: regionController,
                    inputTitle: "Region",
                    title: 'e.g: (Punjab)',
                  ),
                  TextFieldAddressWidget(
                    controller: cityController,
                    inputTitle: "City",
                    title: 'e.g: (Islamabad)',
                  ),
                  TextFieldAddressWidget(
                    controller: addressController,
                    inputTitle: "Address",
                    title: 'e.g: (Hashmi garden)',
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: const Row(
                      children: [
                        Text(
                          'Address cetagory',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: const Row(
                      children: [
                        Expanded(
                          flex: 10,
                          child: RadioButtonAddressWidget(title: 'Home'),
                        ),
                        Expanded(
                          flex: 10,
                          child: RadioButtonAddressWidget(title: 'Office'),
                        ),
                        Spacer(flex: 13),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Consumer(
                    builder: (context, ref, child) {
                      var isLoading = ref.watch(addressProvider);
                      var addressCetagoy = ref.watch(addressCheckboxProvider);
                      return CustomButton(
                        btnTitleWidget: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              (isLoading is LoadingAddressState)
                                  ? const [
                                    CupertinoActivityIndicator(
                                      color: Colors.white,
                                    ),
                                  ]
                                  : [
                                    Text(
                                      (widget.addressModal.name == null)
                                          ? 'Save'
                                          : 'Update',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                        ),
                        onTap: () {
                          if (recipientController.text.isNotEmpty &&
                              addressCetagoy.isNotEmpty &&
                              phoneNumberController.text.isNotEmpty &&
                              cityController.text.isNotEmpty &&
                              regionController.text.isNotEmpty &&
                              addressController.text.isNotEmpty) {
                            ref
                                .read(addressProvider.notifier)
                                .saveAddress(
                                  AddressModal(
                                    address: addressController.text.trim(),
                                    addressCetaory: addressCetagoy,
                                    city: cityController.text.trim(),
                                    name: recipientController.text.trim(),
                                    phoneNumber:
                                        phoneNumberController.text.trim(),
                                    region: regionController.text.trim(),
                                  ),
                                  context,
                                )
                                .then((value) {
                                  GoRouter.of(context).pop();
                                });
                          } else {
                            SnackBarHelper.show(
                              'Null fields found',
                              color: Colors.red,
                            );
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
