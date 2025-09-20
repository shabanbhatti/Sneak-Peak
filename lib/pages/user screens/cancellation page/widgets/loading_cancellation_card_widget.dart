import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LoadingCancellationCardWidget extends ConsumerWidget {
  const LoadingCancellationCardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('cancelled card widget BUILD CALLED');
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: Container(
        height: 145,
        width: double.infinity,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(8),
          border: Border(
            bottom: BorderSide(width: 1, color: Colors.grey.withAlpha(100)),
          ),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Stack(
          children: [
            Row(
              children: [
                _productImg(),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _productTitle(),

                        _productColors(),
                        _productSizes(),
                        _productPrice(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Qty: 2',
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Icon(Icons.remove_circle, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _productImg() {
  return Expanded(
    flex: 4,
    child: Skeletonizer(
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(30),
              offset: const Offset(0, 0),
              blurRadius: 1,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _productTitle() {
  return const Expanded(
    flex: 2,
    child: Wrap(
      alignment: WrapAlignment.start,
      children: [
        Text(
          'hchasdcd',
          maxLines: 2,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

Widget _productColors() {
  return const Expanded(
    flex: 2,
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Wrap(
        alignment: WrapAlignment.start,
        children: [
          Text(
            maxLines: 2,
            'cartModal.colors!.map((e,',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    ),
  );
}

Widget _productSizes() {
  return const Expanded(
    flex: 2,
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Wrap(
        alignment: WrapAlignment.start,
        children: [
          Text(
            maxLines: 2,
            'Size: 23',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    ),
  );
}

Widget _productPrice() {
  return const Expanded(
    flex: 2,
    child: Wrap(
      children: [
        Text(
          maxLines: 2,
          'Rs. 23',
          style: TextStyle(
            fontSize: 15,
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
