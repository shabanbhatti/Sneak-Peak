import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/controllers/admin%20controllers/add_colors_riverpod.dart';
import 'package:sneak_peak/controllers/admin%20controllers/drop_down_menu_rierpod.dart';
import 'package:sneak_peak/controllers/admin%20controllers/gender_selection_riverpod.dart';
import 'package:sneak_peak/pages/admin%20screens/add%20product%20page/controllers/add_product_picking_imgs_controller.dart';
import 'package:sneak_peak/controllers/admin%20controllers/product_db_riverpod.dart';
import 'package:sneak_peak/controllers/admin%20controllers/shoes_sizes_riverpod.dart';
import 'package:sneak_peak/models/products_modals.dart';
import 'package:sneak_peak/pages/admin%20screens/add%20product%20page/Widgets/circle_size_widget.dart';
import 'package:sneak_peak/pages/admin%20screens/add%20product%20page/Widgets/colors_widget.dart';
import 'package:sneak_peak/pages/admin%20screens/add%20product%20page/Widgets/gender_btns.dart';
import 'package:sneak_peak/pages/admin%20screens/add%20product%20page/Widgets/product_imgs_widget.dart';
import 'package:sneak_peak/pages/admin%20screens/add%20product%20page/Widgets/size_widget.dart';
import 'package:sneak_peak/pages/admin%20screens/admin_main.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/shoes_brands_list.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';
import 'package:sneak_peak/widgets/custom%20btn/custom_button.dart';
import 'package:sneak_peak/widgets/custom%20sliver%20app%20bar/custom_sliverappbar1.dart';
import 'package:sneak_peak/widgets/custom%20smooth%20page%20indicator%20widget/smoot_page_indicator_widget.dart';
import 'package:sneak_peak/widgets/custom%20text%20fields/custom_textfields.dart';
import 'package:sneak_peak/widgets/drop%20down%20menu%20widget/drop_down_menu_.dart';

class AddProductPage extends ConsumerStatefulWidget {
  const AddProductPage({super.key});
  static const pageName = 'add_product';

  @override
  ConsumerState<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends ConsumerState<AddProductPage> {
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
    print('ADD PRODUCT BUILD CALLED');

    return Scaffold(
      body: Center(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _sliverAppbar(),
            ProductImgsWidget(pageController: pageController),

            SliverToBoxAdapter(
              child: Consumer(
                builder: (context, pickingImgRef, child) {
                  var myData = pickingImgRef.watch(pickingProductImgProvider);
                  return SmootPageIndicatorWidget(
                    pageController: pageController,
                    count: myData.fileList.length,
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
                                        height: 25,
                                        width: 70,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            dropDownRef
                                .read(dropDownMenuProvider.notifier)
                                .addValue(value!);
                          },
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

            // ShoesSizes(shoesSized: womenSize, title: 'Women'),

            // ShoesSizes(shoesSized: kidzSize, title: 'Kidz'),
            const ColorsWidget(),

            _onButtonClick(),
          ],
        ),
      ),
    );
  }

  Widget _sliverAppbar() {
    return CustomSliverAppBar1(
      title: 'Add new product',
      leadingOnTap: () {
        ref.invalidate(shoesSizesProvider);
        ref.invalidate(checkedBtnProvider1);
        GoRouter.of(context).goNamed(AdminMain.pageName);
      },
      leadingIcon: CupertinoIcons.back,
      onTrailingTap: () {
        ref.read(pickingProductImgProvider.notifier).takeImage();
      },
      trailingIcon: CupertinoIcons.photo,
      trailingIconSize: 25,
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
            var fileList = buttonRef.watch(pickingProductImgProvider);
            var colors = buttonRef.watch(addProductColorProvider);
            var genderList = buttonRef.watch(genderSelectionProvider);
            var productToFirstore = buttonRef.watch(productDbProvider);

            var dropDownValue = buttonRef.watch(dropDownMenuProvider);
            return CustomButton(
              btnTitleWidget:
                  (fileList.isLoading ||
                          productToFirstore is ProductLoadingState)
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                        'Add product',
                        style: TextStyle(color: Colors.white),
                      ),
              onTap: () async {
                var titleValidation = titleKey.currentState!.validate();
                var desValidation = desKey.currentState!.validate();
                var priceValidation = priceKey.currentState!.validate();
                var brandsValidation = brandsKey.currentState!.validate();
                var shoesSizes =
                    await ref
                        .read(shoesSizesProvider.notifier)
                        .addToSHoesList();
                if (titleValidation &&
                    desValidation &&
                    priceValidation &&
                    fileList.fileList.isNotEmpty &&
                    colors.isNotEmpty &&
                    genderList.isNotEmpty &&
                    brandsValidation &&
                    dropDownValue!.isNotEmpty &&
                    shoesSizes.isNotEmpty) {
                  loadingDialog(context, 'Uploading product...');

                  var isInserted = await ref
                      .read(productDbProvider.notifier)
                      .addProduct(
                        ProductModal(
                          title: titleController.text.trim(),
                          description: desController.text.trim(),
                          price: priceController.text.trim(),
                          colors: colors,
                          genders: genderList.toList(),
                          brand: dropDownValue,
                          shoesSizes: shoesSizes,
                        ),
                        fileList.fileList,
                      );
                      Navigator.pop(context);
                  if (isInserted) {
                    
                    SnackBarHelper.show('Product added successfuly');
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
