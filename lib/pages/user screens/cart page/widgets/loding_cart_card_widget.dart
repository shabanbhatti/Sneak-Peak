import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LoadingCartCardWidget extends StatelessWidget {
  const LoadingCartCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Container(
        height: 145,
        width: double.infinity,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withAlpha(50)),
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: const [],
        ),
        child: Row(
          children: [
            _checkBox(),
            _productImg(),
            Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _productTitle(),

                    _productColors(),
                    _productPrice(),
                    _quantity(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _checkBox() {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          Flexible(
            child: SizedBox(
              height: 100,
              width: 100,
              child: Skeletonizer(
                child: Checkbox(
                  activeColor: Colors.orange,
                  value: true,
                  onChanged: (value) {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _productImg() {
    return Flexible(
      flex: 3,
      child: Column(
        children: [
          Flexible(
            child: Skeletonizer(
              child: Container(
                height: 100,
                width: 100,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
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
          ),
        ],
      ),
    );
  }

  Widget _productTitle() {
    return const Expanded(
      flex: 2,
      child: Wrap(
        alignment: WrapAlignment.start,
        children: [
          Skeletonizer(
            child: Text(
              'cartModal.title ?? ',
              maxLines: 2,
              style: TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _productColors() {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: const Wrap(
          alignment: WrapAlignment.start,
          children: [
            Skeletonizer(
              child: Text(
                maxLines: 2,
                'cartModal.colors!.map((e) => e).toString()',
                style: TextStyle(fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productPrice() {
    return const Expanded(
      flex: 2,
      child: Row(
        children: [
          Flexible(
            child: Skeletonizer(
              child: Text(
                maxLines: 2,
                '30000 RS',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantity() {
    return Expanded(
      flex: 3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Skeletonizer(
              child: Container(
                height: 35,
                width: 100,

                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.grey.withAlpha(50)),
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Icon(Icons.remove_circle, color: Colors.orange),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.center,
                        child: Skeletonizer(child: Text('1')),
                      ),
                    ),

                    Expanded(
                      flex: 5,
                      child: Icon(Icons.add_circle, color: Colors.orange),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
