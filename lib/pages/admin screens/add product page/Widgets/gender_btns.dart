import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/controllers/admin%20controllers/gender%20selection%20riverpod/gender_selection_riverpod.dart';
import 'package:sneak_peak/controllers/admin%20controllers/shoes%20sizes%20riverpod/shoes_sizes_riverpod.dart';
import 'package:sneak_peak/utils/male_female_kids_record.dart';
import 'package:sneak_peak/widgets/gender%20cetagory%20collection%20btn/gender_cetagory_cllection_btn.dart';

class GenderBtns extends ConsumerWidget {
  const GenderBtns({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return  SliverToBoxAdapter(
              child: Wrap(
                alignment: WrapAlignment.center,
                children:
                    genderCetagories.map((e) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Consumer(
                          builder: (context, genderBtnRef, child) {
                            var isChecked = genderBtnRef.watch(
                              checkedBtnProvider(e.person),
                            );
                            var sizesList= genderBtnRef.watch(shoesSizesProvider);
                            return GenderCetagoryCollectionBtn(
                              title: e.person,
                              onTap: () {
                                if (isChecked == false) {
                                  
                                  ref
                                      .read(
                                        checkedBtnProvider(
                                          e.person,
                                        ).notifier,
                                      )
                                      .isCheckedMeth(true);
                                  ref
                                      .read(genderSelectionProvider.notifier)
                                      .addGenders(e.person);
                                } else {
                                  ref
                                      .read(
                                        checkedBtnProvider(
                                          e.person,
                                        ).notifier,
                                      )
                                      .isCheckedMeth(false);

                                  ref
                                      .read(genderSelectionProvider.notifier)
                                      .deleteGender(e.person);
                                      ref.read(shoesSizesProvider.notifier).onRemoveCheck(e.person);
                                }
                              },
                            );
                          },
                        ),
                      );
                    }).toList(),
              ),
            );
  }
}