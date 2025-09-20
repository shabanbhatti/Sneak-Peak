import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/controllers/admin%20controllers/add%20product%20colors%20riverpod/add_colors_riverpod.dart';
import 'package:sneak_peak/utils/colors&names_records.dart';
import 'package:sneak_peak/widgets/custom%20colors%20collection/custom_colors_collection.dart';

class ColorsWidget extends StatelessWidget {
  const ColorsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
      sliver: SliverToBoxAdapter(
        child: Wrap(
          alignment: WrapAlignment.center,
          children:
              colorsRecord
                  .map(
                    (index) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Consumer(
                        builder: (context, checkedRef, child) {
                          var isClicked = checkedRef.watch(
                            colorsCollectionProvider(index.colorName),
                          );
                          return ColorsCollection(
                            color: index.color,
                            onTap: () {
                              if (isClicked == false) {
                                checkedRef
                                    .read(
                                      colorsCollectionProvider(
                                        index.colorName,
                                      ).notifier,
                                    )
                                    .isChecked(true);

                                checkedRef
                                    .read(addProductColorProvider.notifier)
                                    .addColors(index.colorName);
                              } else {
                                checkedRef
                                    .read(
                                      colorsCollectionProvider(
                                        index.colorName,
                                      ).notifier,
                                    )
                                    .isChecked(false);
                                checkedRef
                                    .read(addProductColorProvider.notifier)
                                    .deleteColor(index.colorName);
                              }
                            },
                            colorName: index.colorName,
                          );
                        },
                      ),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}
