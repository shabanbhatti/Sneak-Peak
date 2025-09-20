import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sneak_peak/utils/constants_colors.dart';

class ViewProductImgPage extends StatefulWidget {
  const ViewProductImgPage({
    super.key,
    required this.imgList,
    required this.index,
  });
  static const pageName = 'view_product_img';
  final List<String> imgList;
  final String index;

  @override
  State<ViewProductImgPage> createState() => _ViewProductImgPageState();
}

class _ViewProductImgPageState extends State<ViewProductImgPage> {
  PageController? pageController;
  @override
  void initState() {
    super.initState();
    var index = int.parse(widget.index);
    pageController = PageController(initialPage: index);
  }

  @override
  void dispose() {
    pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: CircleAvatar(
            backgroundColor: Colors.grey.withAlpha(70),
            child: IconButton(
              onPressed: () {
                GoRouter.of(context).pop();
              },
              icon: Icon(CupertinoIcons.back, color: appGreyColor),
            ),
          ),
        ),
      ),

      body: Center(
        child: SizedBox(
          child: Stack(
            children: [
              Align(
                alignment: Alignment(0, -1),
                child: PageView.builder(
                  physics: const BouncingScrollPhysics(),
                  controller: pageController,
                  itemCount: widget.imgList.length,
                  itemBuilder: (context, index) {
                    return CachedNetworkImage(
                      imageUrl: widget.imgList[index],
                      fit: BoxFit.contain,
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment(0, 0.7),
                child: SmoothPageIndicator(
                  controller: pageController!,
                  count: widget.imgList.length,
                  effect: JumpingDotEffect(
                    dotColor: Colors.grey,
                    activeDotColor: Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
