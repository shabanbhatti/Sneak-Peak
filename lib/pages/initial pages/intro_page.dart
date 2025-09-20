import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sneak_peak/pages/initial%20pages/decide_page.dart';
import 'package:sneak_peak/utils/constants_imgs_paths.dart';

class IntroPage extends ConsumerStatefulWidget {
  const IntroPage({super.key});
  static const pageName = 'intro_page';

  @override
  ConsumerState<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends ConsumerState<IntroPage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  late Animation<double> fade;
  late Animation<Offset> leftSlide;
  late Animation<Offset> rightSlide;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    fade = Tween<double>(begin: 0.0, end: 1.0).animate(animationController);
    leftSlide = Tween<Offset>(
      begin: const Offset(-2, 0),
      end: Offset.zero,
    ).animate(animationController);
    rightSlide = Tween<Offset>(
      begin: const Offset(2, 0),
      end: Offset.zero,
    ).animate(animationController);

    Future.delayed(const Duration(milliseconds: 500), () {
      animationController.forward().then((value) {
        ref.read(isLoadingProvider.notifier).isLoading().then((value) {
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              GoRouter.of(context).goNamed(DecidePage.pageName);
            }
          });
        });
      });
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('INTO PAGE BUILD CALLED');
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.3),
              FadeTransition(
                opacity: fade,
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage(imgLogo),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _textLogoWidget(leftSlide, fade, textSneakLogo, context),
                  _textLogoWidget(rightSlide, fade, textPeakLogo, context),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              Consumer(
                builder: (context, isLoadingRef, child) {
                  var isLoading = isLoadingRef.watch(isLoadingProvider);
                  return (isLoading)
                      ? LoadingAnimationWidget.flickr(
                        leftDotColor: Colors.orange,
                        rightDotColor: Colors.blue,
                        size: 35,
                      )
                      : const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _textLogoWidget(
  Animation<Offset> position,
  Animation<double> opacity,
  String imgPath,
  BuildContext context,
) {
  return SlideTransition(
    position: position,
    child: Image.asset(
      imgPath,
      height: MediaQuery.of(context).size.height * 0.05,
      fit: BoxFit.fitHeight,
    ),
  );
}

final isLoadingProvider = StateNotifierProvider<IsLoadingNotifier, bool>((ref) {
  return IsLoadingNotifier();
});

class IsLoadingNotifier extends StateNotifier<bool> {
  IsLoadingNotifier() : super(false);

  Future<void> isLoading() async {
    state = true;
  }
}
