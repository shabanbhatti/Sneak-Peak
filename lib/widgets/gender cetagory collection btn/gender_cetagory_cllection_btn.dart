
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/pages/admin%20screens/add%20product%20page/Widgets/circle_size_widget.dart';
import 'package:sneak_peak/utils/constants_colors.dart';

class GenderCetagoryCollectionBtn extends ConsumerWidget {
  const GenderCetagoryCollectionBtn({
    super.key,
    required this.title,
    required this.onTap,
    this.index
  });
  final String title;
  final int? index;

  final void Function() onTap;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isChecked = ref.watch(checkedBtnProvider(title));
    var isChecked1 = ref.watch(checkedBtnProvider1(index??0));

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor:
            (isChecked || isChecked1)
                ? Colors.orange
                : Colors.grey.withAlpha(50),
        side: BorderSide(
          width: 1,
          color: (isChecked || isChecked1) ? Colors.orange : appGreyColor,
        ),
      ),
      onPressed: onTap,
      child: Text(
        title,
        style: TextStyle(
          color: (isChecked || isChecked1) ? Colors.white : appGreyColor,
        ),
      ),
    );
  }
}

final checkedBtnProvider = StateNotifierProvider.family
    .autoDispose<CheckedBtnNotifier, bool, String>((ref, index) {
      return CheckedBtnNotifier();
    });

class CheckedBtnNotifier extends StateNotifier<bool> {
  CheckedBtnNotifier() : super(false);

  Future<void> isCheckedMeth(bool isChecked) async {
    state = isChecked;
  }
}



