import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LoadingCardWidget extends StatelessWidget {
  const LoadingCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(150),
              offset: const Offset(0, 1),
              blurStyle: BlurStyle.outer,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              flex: 10,
              child: Skeletonizer(
                child: Container(
                  color: Colors.grey.withAlpha(50),
                
                ),
              ),
            ),
            const Spacer(flex: 1),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 7),
                      child: Text(
                        'sdfswefswf',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Rs. sfsdf',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                          fontSize: 14,
                        ),
                      ),
                    ),
              
                    Expanded(
                          flex: 3,
                          child: Text(
                            '⭐',
                          ),
                        )
                      
                  ],
                ),
              ),
            ),
            const Spacer(flex: 1),
          ],
        ),
      );
  }
}
