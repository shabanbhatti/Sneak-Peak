import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sneak_peak/pages/admin%20screens/home%20page/widgets/caraousel_widget.dart';

class CarouselUserHomeWidget extends StatelessWidget {
  const CarouselUserHomeWidget({super.key, required this.controller});
  final CarouselController controller;
  @override
  Widget build(BuildContext context) {
    print('carousel home widget build called');
    return LayoutBuilder(
      builder: (context, constraints) {
        var mqSize = Size(constraints.maxWidth, constraints.maxHeight);
        return Container(
          height: 170,
          width: mqSize.width * 0.9,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(150),
                offset: const Offset(0, 1),
                blurStyle: BlurStyle.outer,
                blurRadius: 10,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Consumer(
            builder: (context, ref, child) {
              var banners = ref.watch(bannersProvider);
              return banners.when(
                data:
                    (data) =>
                        (data.isNotEmpty)
                            ? CarouselSlider.builder(
                              itemCount: data.length,
                              itemBuilder:
                                  (context, index, realIndex) =>
                                      CachedNetworkImage(
                                        imageUrl: data[index].caraouselImages!,
                                        height: double.infinity,
                                        width: double.infinity,
                                        fit: BoxFit.fitHeight,
                                        progressIndicatorBuilder:
                                            (context, url, progress) =>
                                                Skeletonizer(
                                                  enabled: true,
                                                  child: Container(
                                                    height: double.infinity,
                                                    width: double.infinity,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                      ),
                              options: CarouselOptions(
                                autoPlay: true,
                                height: double.infinity,
                                viewportFraction: 1,
                                onPageChanged: (index, reason) {
                                  ref
                                      .read(
                                        smoothPageIndicatorIndexProvider
                                            .notifier,
                                      )
                                      .onPageChanged(index);
                                },
                              ),
                            )
                            : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.post_add_rounded,
                                  color: Colors.orange,
                                ),
                                Text(
                                  '   No banners added yet',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                error: (error, stackTrace) => Text(error.toString()),
                loading:
                    () => LoadingAnimationWidget.flickr(
                      leftDotColor: Colors.orange,
                      rightDotColor: Colors.blue,
                      size: 35,
                    ),
              );
            },
          ),
        );
      },
    );
  }
}

final smoothPageIndicatorIndexProvider =
    StateNotifierProvider.autoDispose<SmoothPageIndicatorIndexNotifier, int>((
      ref,
    ) {
      return SmoothPageIndicatorIndexNotifier();
    });

class SmoothPageIndicatorIndexNotifier extends StateNotifier<int> {
  SmoothPageIndicatorIndexNotifier() : super(0);

  void onPageChanged(int value) {
    state = value;
  }
}
