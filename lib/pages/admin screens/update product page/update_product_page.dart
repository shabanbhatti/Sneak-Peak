import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/controllers/admin%20controllers/add_colors_riverpod.dart';
import 'package:sneak_peak/controllers/admin%20controllers/drop_down_menu_rierpod.dart';
import 'package:sneak_peak/controllers/admin%20controllers/gender_selection_riverpod.dart';
import 'package:sneak_peak/controllers/admin%20controllers/product_db_riverpod.dart';
import 'package:sneak_peak/controllers/admin%20controllers/shoes_sizes_riverpod.dart';
import 'package:sneak_peak/models/products_modals.dart';
import 'package:sneak_peak/pages/admin%20screens/add%20product%20page/Widgets/circle_size_widget.dart';
import 'package:sneak_peak/pages/admin%20screens/add%20product%20page/Widgets/colors_widget.dart';
import 'package:sneak_peak/pages/admin%20screens/add%20product%20page/Widgets/gender_btns.dart';
import 'package:sneak_peak/pages/admin%20screens/add%20product%20page/Widgets/size_widget.dart';
import 'package:sneak_peak/pages/admin%20screens/admin_main.dart';
import 'package:sneak_peak/pages/admin%20screens/update%20product%20page/controllers/update_product_img_controller.dart';
import 'package:sneak_peak/pages/admin%20screens/update%20product%20page/controllers/update_stream_controller.dart';
import 'package:sneak_peak/pages/admin%20screens/update%20product%20page/widgets/update_product_img_widget.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/shoes_brands_list.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';
import 'package:sneak_peak/widgets/custom%20btn/custom_button.dart';
import 'package:sneak_peak/widgets/custom%20colors%20collection/custom_colors_collection.dart';
import 'package:sneak_peak/widgets/custom%20sliver%20app%20bar/custom_sliverappbar1.dart';
import 'package:sneak_peak/widgets/custom%20smooth%20page%20indicator%20widget/smoot_page_indicator_widget.dart';
import 'package:sneak_peak/widgets/custom%20text%20fields/custom_textfields.dart';
import 'package:sneak_peak/widgets/drop%20down%20menu%20widget/drop_down_menu_.dart';
import 'package:sneak_peak/widgets/gender%20cetagory%20collection%20btn/gender_cetagory_cllection_btn.dart';

class AdminUpdateProductPage extends ConsumerStatefulWidget {
  const AdminUpdateProductPage({super.key, required this.productModal});

  final ProductModal productModal;
  static const pageName = 'update_page';
  @override
  ConsumerState<AdminUpdateProductPage> createState() =>
      _UpdateProductPageState();
}

class _UpdateProductPageState extends ConsumerState<AdminUpdateProductPage> {
  PageController pageController = PageController();

  TextEditingController titleController = TextEditingController();

  GlobalKey<FormState> titleKey = GlobalKey<FormState>();

  FocusNode titleFocusNode = FocusNode();

  TextEditingController desController = TextEditingController();

  GlobalKey<FormState> desKey = GlobalKey<FormState>();

  FocusNode desFocusNode = FocusNode();

  TextEditingController priceController = TextEditingController();

  GlobalKey<FormState> priceKey = GlobalKey<FormState>();

  FocusNode priceFocusNode = FocusNode();
  GlobalKey<FormState> brandsKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    print(widget.productModal.id);
    print(widget.productModal.genders);
    Future.microtask(
      () => ref
          .read(dropDownMenuProvider.notifier)
          .addValue(widget.productModal.brand ?? ''),
    );
    initializeAll();
  }

  void initializeAll() {
    try {
      gendersFetch();
      titleController.text = widget.productModal.title ?? '';
      desController.text = widget.productModal.description ?? '';
      priceController.text = widget.productModal.price ?? '';
      colorsFetch();
      sizeFetch();
    } catch (e) {
      print(e);
    }
  }

  void colorsFetch() async {
    await Future.wait(
      widget.productModal.colors!.map((e) async {
        Future.microtask(() {
          ref.read(colorsCollectionProvider(e).notifier).isChecked(true);
        });
        Future.microtask(() {
          ref.read(addProductColorProvider.notifier).addColors(e);
        });
      }),
    );
  }

  void sizeFetch() async {
    Future.wait(
      widget.productModal.shoesSizes!.map((e) async {
        Future.microtask(() {
          print(e);
          ref.read(checkedBtnProvider1(e).notifier).isCheckedMeth1(true);
          ref.read(shoesSizesProvider.notifier).addSize(e);
        });
      }),
    );
  }

  void gendersFetch() async {
    await Future.wait(
      widget.productModal.genders!.map((e) async {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          ref.read(checkedBtnProvider(e).notifier).isCheckedMeth(true);
          ref.read(genderSelectionProvider.notifier).addGenders(e);
        });
      }),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    titleController.dispose();
    titleFocusNode.dispose();
    desController.dispose();
    desFocusNode.dispose();
    priceController.dispose();
    priceFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _appBar(),
            UpdateProductImgWidget(
              pageController: pageController,
              productModal: widget.productModal,
            ),
            SliverToBoxAdapter(
              child: Consumer(
                builder: (context, streamProductImgRef, child) {
                  var streamImgs =
                      streamProductImgRef
                          .watch(
                            productModelStreamProviderForUpdateAdminPage(
                              widget.productModal.id.toString(),
                            ),
                          )
                          .value;
                  return SmootPageIndicatorWidget(
                    pageController: pageController,
                    count: streamImgs?.img?.length ?? [].length,
                  );
                },
              ),
            ),
            _titleTextfield(),
            _descriptionTextField(),
            _priceTextField(),
            SliverPadding(
              padding: EdgeInsets.only(bottom: 20),
              sliver: SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: brandsKey,
                    child: Consumer(
                      builder: (context, dropDownRef, child) {
                        var value = dropDownRef.watch(dropDownMenuProvider);
                        return CustomDropDownMenu(
                          title: 'Select brand',
                          items:
                              shoesBrandsList
                                  .map(
                                    (e) => DropdownMenuItem(
                                      alignment: Alignment.center,
                                      value: e.title,
                                      child: Image.asset(
                                        e.imgPath,
                                        height: 22,
                                        width: 80,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            dropDownRef
                                .read(dropDownMenuProvider.notifier)
                                .addValue(value!);
                            log(value);
                          },
                          value: value,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            const GenderBtns(),
            SliverToBoxAdapter(
              child: Consumer(
                builder: (context, x, child) {
                  var selectedGender = x.watch(genderSelectionProvider);
                  return (selectedGender.contains('Men'))
                      ? ShoesSizes(shoesSized: menSize, title: 'Men')
                      : const SizedBox();
                },
              ),
            ),

            SliverToBoxAdapter(
              child: Consumer(
                builder: (context, x, child) {
                  var selectedGender = x.watch(genderSelectionProvider);
                  return (selectedGender.contains('Women'))
                      ? ShoesSizes(shoesSized: womenSize, title: 'Women')
                      : const SizedBox();
                },
              ),
            ),

            SliverToBoxAdapter(
              child: Consumer(
                builder: (context, x, child) {
                  var selectedGender = x.watch(genderSelectionProvider);
                  return (selectedGender.contains('Kidz'))
                      ? ShoesSizes(shoesSized: kidzSize, title: 'Kidz')
                      : const SizedBox();
                },
              ),
            ),

            const ColorsWidget(),
            _onButtonClick(),
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return Consumer(
      builder: (context, x, child) {
        var streamImgList = x.watch(
          productModelStreamProviderForUpdateAdminPage(
            widget.productModal.id.toString(),
          ),
        );
        var streamList =
            x
                .watch(
                  productModelStreamProviderForUpdateAdminPage(
                    widget.productModal.id.toString(),
                  ),
                )
                .value ??
            ProductModal();
        return CustomSliverAppBar1(
          title: 'Update product',
          leadingOnTap: () {
            if (streamList.img!.isEmpty || streamImgList.isLoading) {
              SnackBarHelper.show('Upload the image', color: Colors.red);
            } else {
              ref.invalidate(shoesSizesProvider);
              ref.invalidate(checkedBtnProvider1);
              GoRouter.of(context).goNamed(AdminMain.pageName);
            }
          },
          leadingIcon: CupertinoIcons.back,
          trailingIcon: CupertinoIcons.photo,
          onTrailingTap: () async {
            loadingDialog(context, 'Uploading image...');
            await ref
                .read(updateProductImgProvider.notifier)
                .takeImage(
                  widget.productModal.id.toString(),
                  widget.productModal.img ?? [],
                  widget.productModal.storageImgsPath ?? [],
                );
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Widget _titleTextfield() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(vertical: 20),
      sliver: SliverToBoxAdapter(
        child: Center(
          child: Form(
            key: titleKey,
            child: CustomTextfields(
              controller: titleController,
              title: 'Title',
              prefix: CupertinoIcons.textformat,
              focusNode: titleFocusNode,
              isObscure: false,

              validator: (value) {
                if (value!.isEmpty) {
                  return 'Title should not be empty';
                }
                return null;
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _descriptionTextField() {
    return SliverToBoxAdapter(
      child: Center(
        child: Form(
          key: desKey,
          child: CustomTextfields(
            controller: desController,
            title: 'Description',
            maxLine: 10,
            minLine: 5,

            focusNode: desFocusNode,
            isObscure: false,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Description should not be empty';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }

  Widget _priceTextField() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(vertical: 20),
      sliver: SliverToBoxAdapter(
        child: Center(
          child: Form(
            key: priceKey,
            child: CustomTextfields(
              controller: priceController,
              title: 'Price',
              prefix: Icons.attach_money,
              focusNode: priceFocusNode,
              isObscure: false,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Price should not be empty';
                }
                return null;
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _onButtonClick() {
    return SliverToBoxAdapter(
      child: Center(
        child: Consumer(
          builder: (context, buttonRef, child) {
            var streamUpdateImg = buttonRef.watch(
              productModelStreamProviderForUpdateAdminPage(
                widget.productModal.id.toString(),
              ),
            );
            var streamUpdateImgList =
                buttonRef
                    .watch(
                      productModelStreamProviderForUpdateAdminPage(
                        widget.productModal.id.toString(),
                      ),
                    )
                    .value ??
                ProductModal();
            var colors = buttonRef.watch(addProductColorProvider);
            var genderList = buttonRef.watch(genderSelectionProvider);
            var productToFirstore = buttonRef.watch(productDbProvider);
            var brand = buttonRef.watch(dropDownMenuProvider);

            return CustomButton(
              btnTitleWidget:
                  (streamUpdateImg.isLoading ||
                          productToFirstore is ProductLoadingState)
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                        'Update product',
                        style: TextStyle(color: Colors.white),
                      ),
              onTap: () async {
                var titleValidation = titleKey.currentState!.validate();
                var desValidation = desKey.currentState!.validate();
                var priceValidation = priceKey.currentState!.validate();
                var shoesSizesList =
                    await buttonRef
                        .read(shoesSizesProvider.notifier)
                        .addToSHoesList();

                if (titleValidation &&
                    desValidation &&
                    priceValidation &&
                    streamUpdateImgList.img!.isNotEmpty &&
                    colors.isNotEmpty &&
                    genderList.isNotEmpty &&
                    brand!.isNotEmpty &&
                    shoesSizesList.isNotEmpty) {
                  loadingDialog(context, 'Updating product...');
                  var isUpdated = await ref
                      .read(productDbProvider.notifier)
                      .updateProduct(
                        ProductModal(
                          title: titleController.text.trim(),
                          description: desController.text.trim(),
                          price: priceController.text.trim(),
                          colors: colors,
                          brand: brand,
                          genders: genderList.toList(),
                          id: widget.productModal.id,
                          shoesSizes: shoesSizesList,
                        ),
                      );
                      Navigator.pop(context);
                  if (isUpdated) {
                    
                    SnackBarHelper.show('Product updated successfuly');
                    ref.invalidate(shoesSizesProvider);
                    ref.invalidate(checkedBtnProvider1);
                    GoRouter.of(context).goNamed(AdminMain.pageName);
                  }
                } else {
                  SnackBarHelper.show('Null fields found', color: Colors.red);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
