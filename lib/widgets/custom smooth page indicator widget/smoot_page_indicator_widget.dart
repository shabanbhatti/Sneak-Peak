import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SmootPageIndicatorWidget extends StatelessWidget {
  const SmootPageIndicatorWidget({
    super.key,
    required this.pageController,
    required this.count,
    this.title='(Note: You can only upload 4 pictures)'
  });
  final PageController pageController;
  final String? title;
  final int count;
  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          (count <= 0)
              ?  Text(
                title!,
                style:const TextStyle(color: Colors.red),
              )
              : SmoothPageIndicator(
                controller: pageController,
                count: count,
                
                effect: const ExpandingDotsEffect(
                  
                  activeDotColor: Colors.orange,
                  radius: 20,
                  dotHeight: 10,
                  dotWidth: 10,
                ),
              ),
    );
  }
}
