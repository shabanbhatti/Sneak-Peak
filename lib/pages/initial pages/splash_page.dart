import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sneak_peak/pages/auth%20pages/login%20page/login_page.dart';
import 'package:sneak_peak/services/shared%20pref%20service/shared_pref_service.dart';
import 'package:sneak_peak/utils/constants_imgs_paths.dart';


class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});
  static const pageName = 'splash_page';

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Splash page BUILD CALLED');
    return Scaffold(
      appBar: null,
      body: SafeArea(
        minimum: EdgeInsets.all(10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (value){
                  
                  ref.read(pageNumberProvider.notifier).pageNumber(value);
                },
                controller: pageController,
                children: [
                  _centerWidget(
                    splash1Img,
                    'Choose Product',
                    'Discover a world of quality products at your fingertips. Browse, compare, and choose exactly what you need. Shopping has never been this simple and fun!',
                    context,
                  ),
                  _centerWidget(
                    splash2Img,
                    'Make payment',
                    'Secure and hassle-free payments, just for you. Choose from multiple payment options and checkout in seconds. Your convenience is our priority!',
                    context,
                  ),
                ],
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: SmoothPageIndicator(
                controller: pageController,
                count: 2,
                effect: const WormEffect(activeDotColor: Colors.orange),
              ),
            ),

            Align(
              alignment: Alignment.bottomRight,
              child: Consumer(
                builder: (context, pageNumRef, child) {
                  var pageNumber = pageNumRef.watch(pageNumberProvider);
                  return _clickEventButton(
                    ()async {
                      
                      if (pageNumber == 1) {
                        pageController.animateToPage(
                          1,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.linear,
                        );
                      } else {
                        SPHelper.setBool(SPHelper.splash ,true);
                        GoRouter.of(context).goNamed(LoginPage.pageName);
                      }
                    },
                    (pageNumber == 1) ? 'Next' : 'Get started',
                    color: Colors.orange,
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Consumer(
                      builder: (context, pageNumberRef, child) {
                        var pageNumber = pageNumberRef.watch(
                          pageNumberProvider,
                        );
                        return Text(
                          '$pageNumber/2',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                    _clickEventButton(()async {
                      var sp= await SharedPreferences.getInstance();
                  sp.setBool('splash', true);
                      GoRouter.of(context).goNamed(LoginPage.pageName);
                      print('--------');
                    }, 'Skip'),
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

Widget _centerWidget(
  String imgPath,
  String title,
  String des,
  BuildContext context,
) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      SizedBox(height: MediaQuery.of(context).size.height * 0.17),
      Image.asset(imgPath, width: MediaQuery.of(context).size.width * 0.8),
      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
      Text(title, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
      SizedBox(height: MediaQuery.of(context).size.height * 0.02),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          des,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color.fromARGB(255, 124, 124, 124),
            fontSize: 15,
          ),
        ),
      ),
    ],
  );
}

Widget _clickEventButton(
  void Function() onTap,
  String btnTitle, {
  Color color = Colors.black,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Text(
        btnTitle,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17,
          color: color,
        ),
      ),
    ),
  );
}

final pageNumberProvider =
    StateNotifierProvider.autoDispose<PageNumberNotifier, int>((ref) {
      return PageNumberNotifier();
    });

class PageNumberNotifier extends StateNotifier<int> {
  PageNumberNotifier() : super(1);

  Future<void> pageNumber(int pageNumber) async {
    if (pageNumber == 1) {
      state = 2;
    }
  }
}
