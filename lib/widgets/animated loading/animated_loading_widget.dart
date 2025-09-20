import 'package:flutter/material.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';

class AnimatedLoadingWidget extends StatelessWidget {
  const AnimatedLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  LoadingAnimationWidget.flickr(
              leftDotColor: Colors.orange,
              rightDotColor: Colors.blue,
              size: 35,
            );
  }
}