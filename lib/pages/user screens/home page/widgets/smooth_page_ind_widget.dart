import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sneak_peak/controllers/banners_stream.dart';
import 'package:sneak_peak/pages/user%20screens/home%20page/widgets/carousel_user_home_widget.dart';

class SmoothPageIndWidget extends StatelessWidget {
  const SmoothPageIndWidget({super.key, required this.carouselController});
final CarouselController carouselController;
  @override
  Widget build(BuildContext context) {
    return Center(
                child: Consumer(
                  builder: (context, smoothIndexRef, child) {
                    var index = smoothIndexRef.watch(
                      smoothPageIndicatorIndexProvider,
                    );
                    var totalData =
                        smoothIndexRef.watch(bannersProvider).value ?? [];
                    return AnimatedSmoothIndicator(
                      activeIndex:(index < totalData.length) ? index : 0,
                      count: totalData.length,
                      effect:const ExpandingDotsEffect(
                        dotHeight: 10,
                        dotWidth: 10,
                        activeDotColor: Colors.orange,
                      ),
                      onDotClicked: (i) {
                        // carouselController.animateTo(
                        //   index.toDouble(),
                        //   duration:const Duration(seconds: 1),
                        //   curve: Curves.bounceInOut,
                        // );
                         if (i < totalData.length) {
            carouselController.jumpTo(i.toDouble());
          }
                      },
                    );
                  },
                ),
              );
  }
}