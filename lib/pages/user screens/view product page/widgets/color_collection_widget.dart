import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ColorsCollectionFoUserViewProduct extends StatelessWidget {
  const ColorsCollectionFoUserViewProduct({
    super.key,
    required this.color,
    required this.onTap,
    required this.isClicked,
  });
  final Color color;
  final void Function() onTap;
  final bool isClicked;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(100),
      child: InkWell(
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        onTap: onTap,
        child: Consumer(
          builder: (context, ref, child) {
            return Container(
              height: 35,
              width: 35,

              decoration: ShapeDecoration(
                shape: CircleBorder(
                  side: BorderSide(
                    width: 2.5,
                    color: (isClicked) ? Colors.orange : Colors.transparent,
                  ),
                ),
              ),
              alignment: Alignment.center,
              child: CircleAvatar(radius: 13, backgroundColor: color),
            );
          },
        ),
      ),
    );
  }
}

final colorsCollectionForUserViewProductPageProvider =
    StateNotifierProvider.autoDispose<
      ColorsCollectionForUserViewPageNotifier,
      String
    >((ref) {
      return ColorsCollectionForUserViewPageNotifier();
    });

class ColorsCollectionForUserViewPageNotifier extends StateNotifier<String> {
  ColorsCollectionForUserViewPageNotifier() : super('');

  Future<String> isChecked(String colorName) async {
    state = colorName;
    return state;
  }
}

final colorsCollectionForUserViewProductPageProvider1 =
    StateNotifierProvider.autoDispose<
      ColorsCollectionForUserViewPageNotifier1,
      String
    >((ref) {
      return ColorsCollectionForUserViewPageNotifier1();
    });

class ColorsCollectionForUserViewPageNotifier1 extends StateNotifier<String> {
  ColorsCollectionForUserViewPageNotifier1() : super('');

  Future<String> isChecked(String colorName) async {
    state = colorName;
    return state;
  }
}
