import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/controllers/admin%20controllers/banners_riverpod.dart';
import 'package:sneak_peak/controllers/admin%20controllers/product_db_riverpod.dart';
import 'package:sneak_peak/controllers/banners_stream.dart';
import 'package:sneak_peak/controllers/get%20products%20stream%20provider/get_products_stream.dart';
import 'package:sneak_peak/pages/admin%20screens/add%20product%20page/admin_add_product_page.dart';
import 'package:sneak_peak/pages/admin%20screens/home%20page/widgets/caraousel_widget.dart';
import 'package:sneak_peak/pages/admin%20screens/home%20page/widgets/product_data_widget.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/dialog%20boxes/remove_product_dialog.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';
import 'package:sneak_peak/widgets/admin%20app%20bar/admin_sliver_app_bar.dart';
import 'package:sneak_peak/widgets/custom%20btn/custom_button.dart';

class AdminHome extends ConsumerStatefulWidget {
  const AdminHome({super.key});

  @override
  ConsumerState<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends ConsumerState<AdminHome> {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {});
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('ADMIN HOME BUILD CALLED');
    ref.listen(productDbProvider, (previous, next) {
      if (next is ProductErrorState) {
        var error = next.error;
        SnackBarHelper.show(error, color: Colors.red);
      }
    });
    ref.listen(bannersProvider, (previous, next) {
      if (next is ErrorCaraouselState) {
        var e = next.error;
        SnackBarHelper.show(e.toString(), color: Colors.red);
      }
    });
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.all(1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              backgroundColor: Colors.orange,
              onPressed: () {
                GoRouter.of(context).goNamed(AddProductPage.pageName);
              },
              child: const Icon(Icons.add, color: Colors.white, size: 30),
            ),
          ],
        ),
      ),
      body: Center(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            adminSliverAppBar('Hey Admin', controller, focusNode, context),
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 20),
              sliver: SliverToBoxAdapter(
                child: Center(child: const CaraouselWidget()),
              ),
            ),
            SliverToBoxAdapter(
              child: Center(
                child: CustomButton(
                  btnTitle: 'Add banners',
                  onTap: () async {
                    loadingDialog(context, 'Processing image...');
                    var isBannerAdd =
                        await ref
                            .read(caraouselSliderImagesProvider.notifier)
                            .addBanner();
                    Navigator.pop(context);
                    if (isBannerAdd ?? false) {
                      SnackBarHelper.show('Added successfully');
                    }
                  },
                ),
              ),
            ),
            // _deleteAllButton(),
            const ProductDataWidget(),
            _noProductText(),
          ],
        ),
      ),
    );
  }
}

Widget _noProductText() {
  return SliverFillRemaining(
    hasScrollBody: false,
    child: Center(
      child: Consumer(
        builder: (context, xRef, child) {
          var data = xRef.watch(getProductsProvider).value ?? [];
          return (data.isEmpty)
              ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag, color: Colors.orange),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'No Product added yet',
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
              : const SizedBox();
        },
      ),
    ),
  );
}

Widget _deleteAllButton() {
  return SliverPadding(
    padding: EdgeInsets.only(top: 0),
    sliver: SliverToBoxAdapter(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Consumer(
            builder: (context, xRef, child) {
              var data = xRef.watch(getProductsProvider).value ?? [];
              return (data.isEmpty)
                  ? const SizedBox()
                  : TextButton(
                    onPressed: () {
                      removeAllItemsDialog(context, () {
                        loadingDialog(context, 'Deleting all....');
                        xRef
                            .read(productDbProvider.notifier)
                            .deleteAll(context)
                            .then((value) => Navigator.pop(context));
                        Navigator.pop(context);
                      });
                    },
                    child: const Text(
                      'Delete all',
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  );
            },
          ),
        ],
      ),
    ),
  );
}
