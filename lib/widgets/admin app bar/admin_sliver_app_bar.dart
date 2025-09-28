import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/controllers/get_products_stream.dart';
import 'package:sneak_peak/controllers/search_product_riverpod.dart';
import 'package:sneak_peak/utils/constants_imgs_paths.dart';

Widget adminSliverAppBar(
  String title,
  TextEditingController controller,
  FocusNode focusNode,
  BuildContext context,
  Widget? widget,
) {
  return SliverAppBar(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    snap: true,
    floating: true,
    leading: Padding(padding: EdgeInsets.all(8), child: Image.asset(imgLogo)),
    centerTitle: true,
    expandedHeight: 120,
    title: Text(title, style: const TextStyle()),
    actions: [widget ?? const SizedBox()],
    flexibleSpace: FlexibleSpaceBar(
      background: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Spacer(flex: 7),
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: SizedBox(
                height: 50,
                child: Consumer(
                  builder: (context, ref, child) {
                    var streamDataList = ref.watch(getProductsProvider);
                    return CupertinoTextField(
                      controller: controller,
                      decoration: BoxDecoration(
                        color: Colors.grey.withAlpha(50),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.transparent),
                      ),
                      placeholder: 'Search',
                      prefix: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        ref
                            .read(searchProductProvider.notifier)
                            .onChanged(value, streamDataList.value ?? []);
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
