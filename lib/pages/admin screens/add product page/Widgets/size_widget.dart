import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/controllers/admin%20controllers/shoes_sizes_riverpod.dart';
import 'package:sneak_peak/pages/admin%20screens/add%20product%20page/Widgets/circle_size_widget.dart';

class ShoesSizes extends StatelessWidget {
  const ShoesSizes({super.key, required this.shoesSized, required this.title});

  final List<int> shoesSized;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.orange,
            fontSize: 20,
            fontStyle: FontStyle.italic,
          ),
        ),
        const Divider(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Wrap(
            alignment: WrapAlignment.center,
            children:
                shoesSized.map((e) {
                  return Consumer(
                    builder: (context, x, child) {
                      var isChecked = x.watch(checkedBtnProvider1(e));
                      return CircleSizeWidget(
                        title: e.toString(),
                        index: e,
                        onTap: () {
                          if (isChecked == false) {
                            x
                                .read(checkedBtnProvider1(e).notifier)
                                .isCheckedMeth1(true);
                  
                            x.read(shoesSizesProvider.notifier).addSize(e);
                          } else {
                            x
                                .read(checkedBtnProvider1(e).notifier)
                                .isCheckedMeth1(false);
                            x
                                .read(shoesSizesProvider.notifier)
                                .removerSize(e);
                          }
                        },
                      );
                    },
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }
}

List<int> menSize = const [42, 43, 44, 45, 46];

List<int> womenSize = const [36, 37, 38, 39, 40, 41];

List<int> kidzSize = const [24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35];
