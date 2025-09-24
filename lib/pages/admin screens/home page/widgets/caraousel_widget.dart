import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sneak_peak/controllers/admin%20controllers/banners_riverpod.dart';
import 'package:sneak_peak/controllers/banners_stream.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';

class CaraouselWidget extends StatelessWidget {
  const CaraouselWidget({super.key});

  @override
  Widget build(BuildContext contextX) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var mqSize = Size(constraints.maxWidth, constraints.maxHeight);
        return Container(
          height: 170,
          width: mqSize.width * 0.95,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(150),
                offset:const Offset(0, 1),
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
                                  (context, index, realIndex) => Container(
                                    child: Stack(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl:
                                              data[index].caraouselImages!,
                                          height: double.infinity,
                                          width: double.infinity,
                                          fit: BoxFit.fitHeight,
                                           progressIndicatorBuilder:
                              (context, url, progress) => Skeletonizer(
                                enabled: true,
                                child: Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  color: Colors.grey,
                                ),
                              ),
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: IconButton(
                                            onPressed: ()async{
                         loadingDialog(contextX, 'Deleting image...');
                         var isDeleted= await ref.read(caraouselSliderImagesProvider.notifier,).deleteBanners(data[index].id.toString(),data[index].caraouselImagesPaths??'');
                         Navigator.pop(contextX);
                         if (isDeleted) {
                         SnackBarHelper.show('Deleted successfully');
                         }
                                            },
                                            icon: const Icon(
                                              Icons.cancel,
                                              color: Colors.grey,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              options: CarouselOptions(
                                autoPlay: true,
                                height: double.infinity,
                                viewportFraction: 1,
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
                loading: () =>  LoadingAnimationWidget.flickr(
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


