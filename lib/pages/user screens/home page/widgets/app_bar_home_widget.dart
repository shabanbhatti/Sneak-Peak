import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sneak_peak/controllers/get%20shared%20pref%20data%20riverpod/get_sp_data_riverpod.dart';
import 'package:sneak_peak/controllers/location%20riverpod/location_riverpod.dart';
import 'package:sneak_peak/controllers/user%20img%20riverpod/user_img_riverpod.dart';
import 'package:sneak_peak/controllers/users%20controller/get_product_family_stream_riverpod.dart';
import 'package:sneak_peak/controllers/users%20controller/search_product_in_home_riverpod.dart';
import 'package:sneak_peak/pages/user%20screens/view%20user%20img%20page/view_user_img_page.dart';
import 'package:sneak_peak/utils/constant_imgs.dart';
import 'package:sneak_peak/utils/dialog%20boxes/loading_dialog.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';


class HomeAppBarWidget extends ConsumerStatefulWidget {
  const HomeAppBarWidget({super.key, required this.controller});
  final TextEditingController controller;

  @override
  ConsumerState<HomeAppBarWidget> createState() => _HomeAppBarWidgetState();
}

class _HomeAppBarWidgetState extends ConsumerState<HomeAppBarWidget> {

@override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(userImgProvider('user_img_home').notifier).getUserImg());
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(userImgProvider('user_img_home'), (previous, next) {
      if(next is ErrorStateUserImg){
        var error= next.error;
        SnackBarHelper.show(error, color: Colors.red);
      }
    },);
    return SliverAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      expandedHeight: 170,
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          children: [
            const Spacer(flex: 4),
            Expanded(
              flex: 10,
              child: ListTile(
                leading: Consumer(
                  builder: (context, x, child) {
                    var userImg = x.watch(userImgProvider('user_img_home'));
                    return (userImg is LoadingUserImg)
                        ? _circleAvatarWidget(
                          loadingGifUrl,
                          
                          () => '',
                        )
                        : (userImg is LoadedSuccessfulyUserImg)
                        ? InkWell(
                          onLongPress:
                              () => GoRouter.of(context).pushNamed(
                                ViewUserImgPage.pageName,
                                extra: userImg.imgUrl,
                              ),
                          child: _circleAvatarWidget(userImg.imgUrl, ()async {
                            if (userImg.imgUrl == profileIconUrl) {
                              loadingDialog(context, 'Uploading image...');
                              var isDone= await x.read(userImgProvider('user_img_home').notifier).takeImage(ImageSource.gallery, );
                                  Navigator.pop(context);
                                   if (isDone=='done') {
                    SnackBarHelper.show('Image uploaded successfully');
                  }
                            }
                          }),
                        )
                        : _circleAvatarWidget(
                          profileIconUrl,
                          ()async {
                            loadingDialog(context, 'Uploading image...');
                           var isDone= await x.read(userImgProvider('user_img_home').notifier).takeImage(ImageSource.gallery, );
                                Navigator.pop(context);
                                 if (isDone=='done') {
                    SnackBarHelper.show('Image uploaded successfully');
                  }
                          },
                        );
                  },
                ),
                title: const Text(
                  'Hello!',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                subtitle: Consumer(
                  builder: (context, x, child) {
                    var name = x.watch(getSharedPrefDataProvider);
                    return Text(
                      name.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    );
                  },
                ),
                trailing: const CircleAvatar(
                  radius: 17,
                  backgroundColor: Colors.orange,
                  child: Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),

            Flexible(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  // height: 50,
                  child: Consumer(
                    builder: (context, ref, child) {
                      var allFeature =
                          ref.watch(streamsProductDataProvider('')).value ?? [];
                      var indure =
                          ref
                              .watch(streamsProductDataProvider('NDURE'))
                              .value ??
                          [];
                      var bata =
                          ref.watch(streamsProductDataProvider('Bata')).value ??
                          [];
                      var stylo =
                          ref
                              .watch(streamsProductDataProvider('Stylo'))
                              .value ??
                          [];
                      var servis =
                          ref
                              .watch(streamsProductDataProvider('Servis'))
                              .value ??
                          [];
                      return CupertinoTextField(
                        controller: widget.controller,
                        decoration: BoxDecoration(
                          color: Colors.grey.withAlpha(50),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.transparent),
                        ),
                        placeholder: 'Search',
                        prefix: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Icon(Icons.search),
                        ),
                        onChanged: (value) {
                          ref
                              .read(userHomeSearchProductProvider('').notifier)
                              .onChanged(value, allFeature);
                          ref
                              .read(
                                userHomeSearchProductProvider('NDURE').notifier,
                              )
                              .onChanged(value, indure);
                          ref
                              .read(
                                userHomeSearchProductProvider('Bata').notifier,
                              )
                              .onChanged(value, bata);
                          ref
                              .read(
                                userHomeSearchProductProvider('Stylo').notifier,
                              )
                              .onChanged(value, stylo);
                          ref
                              .read(
                                userHomeSearchProductProvider(
                                  'Servis',
                                ).notifier,
                              )
                              .onChanged(value, servis);
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            const Spacer(flex: 2),
            Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.orange),
                    Consumer(
                      builder: (context, y, child) {
                        var placemark = y.watch(locationProvider);
                        return (placemark.country == null)
                            ? TextButton(
                              onPressed: () {
                                y.read(locationProvider.notifier).getLocation();
                              },
                              child: Text(
                                'No current location',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                            : Text(
                              ' ${placemark.locality}, ${placemark.country}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _circleAvatarWidget(String imgUrl, void Function()? onTap) {
  return InkWell(
    overlayColor: WidgetStatePropertyAll(Colors.transparent),
    onTap: onTap,
    child: Hero(
      tag: ViewUserImgPage.pageName,
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        height: 50,
        width: 50,
      
        decoration: ShapeDecoration(shape:const CircleBorder(), ),
        child: CachedNetworkImage(imageUrl: imgUrl, fit: BoxFit.cover,progressIndicatorBuilder:
                  (context, url, progress) => Skeletonizer(
                    enabled: true,
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.grey,
                    ),
                  ),),
      ),
    ),
  );
}
