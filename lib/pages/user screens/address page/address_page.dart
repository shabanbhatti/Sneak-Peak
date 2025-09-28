import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/controllers/users%20controller/address_riverpd.dart';
import 'package:sneak_peak/models/address_modal.dart';
import 'package:sneak_peak/pages/user%20screens/address%20page/widgets/radio_button_widget.dart';
import 'package:sneak_peak/pages/user%20screens/address%20page/widgets/text_field_address_widget.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';
import 'package:sneak_peak/utils/validations.dart';
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
  GlobalKey<FormState> reciepientKey = GlobalKey<FormState>();
  TextEditingController phoneNumberController = TextEditingController();
  GlobalKey<FormState> phoneKey = GlobalKey<FormState>();
  TextEditingController regionController = TextEditingController();
  GlobalKey<FormState> regionKey = GlobalKey<FormState>();
  TextEditingController cityController = TextEditingController();
  GlobalKey<FormState> cityKey = GlobalKey<FormState>();
  TextEditingController addressController = TextEditingController();
  GlobalKey<FormState> addressKey = GlobalKey<FormState>();

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
    print('adress page build called');
    ref.listen(addressProvider, (previous, next) {
      if (next is ErrorAddressState) {
        var error = next.error;
        SnackBarHelper.show(error, color: Colors.red);
      }
    });
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 5,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
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
                    formKey: reciepientKey,
                    controller: recipientController,
                    inputTitle: "Recipient's name",
                    title: 'e.g: (Shaban Bhatti)',
                    validation: (p0) => nameValidation(p0),
                  ),
                  TextFieldAddressWidget(
                    formKey: phoneKey,
                    controller: phoneNumberController,
                    inputTitle: 'Phone number',
                    title: 'e.g: (03146371991)',
                    keyboardType: TextInputType.number,
                    validation: (p0) => phoneNumberValidation(p0),
                  ),
                  TextFieldAddressWidget(
                    formKey: regionKey,
                    controller: regionController,
                    inputTitle: "Region",
                    title: 'e.g: (Punjab)',
                    validation: (p0) {
                      if (p0 == null || p0.isEmpty) {
                        return 'Region is required';
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextFieldAddressWidget(
                    formKey: cityKey,
                    controller: cityController,
                    inputTitle: "City",
                    title: 'e.g: (Bahawalpur)',
                    validation: (p0) {
                      if (p0 == null || p0.isEmpty) {
                        return 'City is required';
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextFieldAddressWidget(
                    formKey: addressKey,
                    controller: addressController,
                    inputTitle: "Address",
                    title: 'e.g: (Cheema Town)',
                    validation: (p0) {
                      if (p0 == null || p0.isEmpty) {
                        return 'Address is required';
                      } else {
                        return null;
                      }
                    },
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
                        onTap: () async {
                          var reciepientValidation =
                              reciepientKey.currentState!.validate();
                          var phoneValidation =
                              phoneKey.currentState!.validate();
                          var regionValidation =
                              regionKey.currentState!.validate();
                          var cityValidation = cityKey.currentState!.validate();
                          var addressValidation =
                              addressKey.currentState!.validate();

                          if (reciepientValidation &&
                              phoneValidation &&
                              regionValidation &&
                              cityValidation &&
                              addressValidation) {
                            if (addressCetagoy.isNotEmpty) {
                              loadingDialog(
                                context,
                                '',
                                color: Colors.transparent,
                              );
                              var isSave = await ref
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
                                  );
                              Navigator.pop(context);
                              if (isSave) {
                                SnackBarHelper.show(
                                  'Address added successfuly',
                                  color: Colors.green,
                                );
                                GoRouter.of(context).pop();
                              }
                            } else {
                              SnackBarHelper.show(
                                'Please select the address cetagory',
                                color: Colors.red,
                              );
                            }
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
