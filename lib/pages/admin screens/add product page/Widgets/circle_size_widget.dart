import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/utils/constants_colors.dart';


class CircleSizeWidget extends ConsumerWidget {
  const CircleSizeWidget({
    super.key,
    required this.title,
    required this.index,
    required this.onTap,
    this.size = 30,
    this.fontSIze = 13,
    this.isRadioCheck=false
  });
  final String title;
  final int? index;

  final void Function() onTap;
  final double? size;
  final double? fontSIze;
  final bool? isRadioCheck;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isChecked1 = ref.watch(checkedBtnProvider1(index ?? 0));
    return Padding(
      padding: EdgeInsets.all(2),
      child: InkWell(
        onTap: onTap,
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        child: Container(
          height: size,
          width: size,
          decoration: ShapeDecoration(
            shape: CircleBorder(
              side: BorderSide(
                width: 1,
                color: (isChecked1|| isRadioCheck!) ? Colors.orange : appGreyColor,
              ),
            ),
            color: (isChecked1|| isRadioCheck!) ? Colors.orange : Colors.grey.withAlpha(50),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: (isChecked1|| isRadioCheck!) ? Colors.white : appGreyColor,
              fontSize: fontSIze,
            ),
          ),
        ),
      ),
    );
  }
}
final checkedBtnProvider1 = StateNotifierProvider.family
    <CheckedBtnNotifier1, bool, int>((ref, index) {
      return CheckedBtnNotifier1();
    });

class CheckedBtnNotifier1 extends StateNotifier<bool> {
  CheckedBtnNotifier1() : super(false);

  Future<void> isCheckedMeth1(bool isChecked, ) async {
    state = isChecked;
    log('$state');
  }
}

final radioSizeCheckedProvider = StateProvider.autoDispose<int?>((ref) {
  return null;
});