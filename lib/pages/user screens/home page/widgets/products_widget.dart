import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/controllers/users%20controller/search%20product%20in%20home%20riverpod/search_product_in_home_riverpod.dart';
import 'package:sneak_peak/pages/user%20screens/home%20page/widgets/product_card_data_widget.dart';
import 'package:sneak_peak/pages/user%20screens/see%20all%20page/see_all_page.dart';

class ProductsWidget extends StatelessWidget {
  const ProductsWidget({
    super.key,
    required this.title,
    required this.dataTitle,
  });
  final String title;
  final String dataTitle;

  @override
  Widget build(BuildContext contextx) {
    return SliverPadding(
      padding: EdgeInsets.symmetric( horizontal: 12),
      sliver: SliverToBoxAdapter(
        child: Container(
          color: Colors.transparent,
          height: 230,
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 7),
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          shadows: [
                            BoxShadow(
                              offset: Offset(0, 0),
                              color: Colors.black,
                              blurRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),

                    Consumer(
                      builder: (context, x, child) {
                        var productList = x.watch(
                          userHomeSearchProductProvider(dataTitle),
                        );
                        // var myIndex=
                        return (productList.isNotEmpty)
                            ? TextButton(
                              onPressed: () {
                                print(dataTitle);
                                GoRouter.of(contextx).pushNamed(
                                  SeeAllPage.pageName,
                                  extra:(dataTitle != '')
                                            ? dataTitle
                                            : 'allfeatures' ,
                                 
                                );
                              },
                              child: const Text(
                                'See all',
                                style: TextStyle(color: Colors.orange),
                              ),
                            )
                            : const SizedBox();
                      },
                    ),
                  ],
                ),
              ),
              ProductCardDataWidget(dataTitle: dataTitle),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
