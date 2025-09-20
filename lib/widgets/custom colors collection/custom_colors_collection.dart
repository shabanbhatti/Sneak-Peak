import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ColorsCollection extends StatelessWidget {
  const ColorsCollection({
    super.key,
    required this.color,
    required this.onTap,
    required this.colorName,
  });
  final Color color;
  final void Function() onTap;
  final String colorName;
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(100),
      child: InkWell(
        onTap: onTap,
        child: Consumer(
          builder: (context, ref, child) {
            var isClicke = ref.watch(colorsCollectionProvider(colorName));
            
            return Container(
              height: 35,
              width: 35,

              decoration: ShapeDecoration(
                shape: CircleBorder(
                  side: BorderSide(
                    width: 2,
                    color: (isClicke) ? Colors.orange : Colors.transparent,
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

final colorsCollectionProvider = StateNotifierProvider.family
    .autoDispose<ColorsCollectionNotifier, bool, String>((ref, index) {
      return ColorsCollectionNotifier();
    });

class ColorsCollectionNotifier extends StateNotifier<bool> {
  ColorsCollectionNotifier() : super(false);

  Future<void> isChecked(bool isClicked) async {
    state = isClicked;
  }
}


