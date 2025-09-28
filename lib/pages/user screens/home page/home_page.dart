import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/controllers/auth%20riverpod/auth_riverpod.dart';
import 'package:sneak_peak/controllers/fcm_token_riverpod.dart';
import 'package:sneak_peak/controllers/get%20shared%20pref%20data%20riverpod/get_sp_data_riverpod.dart';
import 'package:sneak_peak/controllers/location_riverpod.dart';
import 'package:sneak_peak/pages/auth%20pages/login%20page/login_page.dart';
import 'package:sneak_peak/pages/user%20screens/home%20page/widgets/app_bar_home_widget.dart';
import 'package:sneak_peak/pages/user%20screens/home%20page/widgets/carousel_user_home_widget.dart';
import 'package:sneak_peak/pages/user%20screens/home%20page/widgets/products_widget.dart';
import 'package:sneak_peak/pages/user%20screens/home%20page/widgets/smooth_page_ind_widget.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  TextEditingController controller = TextEditingController();
  CarouselController carouselController = CarouselController();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
       ref.read(fcmTokenProvider.notifier).updateFcmTokenInInitState();
      ref.read(getSharedPrefDataProvider.notifier).getNameEmailDataFromSP();
      ref.read(locationProvider.notifier).getLocation();
      ref
          .read(authProvider('sync_email').notifier)
          .syncEmailAfterVerification();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider('sync_email'), (previous, next) {
      if (next is AuthErrorState) {
        var error = next.error;
        if (error == 'user-token-expired' ||
            error ==
                "[firebase_auth/user-token-expired] The user's credential is no longer valid. The user must sign in again.") {
          SnackBarHelper.show('Email verified! please login with new email.');
          GoRouter.of(context).pushReplacementNamed(LoginPage.pageName);
        } else {
          SnackBarHelper.show(error, color: Colors.red);
        }
      }
    });
    return Scaffold(
      body: Center(
        child: Scrollbar(
          thickness: 7,
          radius: Radius.circular(20),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              HomeAppBarWidget(controller: controller),

              SliverPadding(
                padding: EdgeInsets.only(top: 20, bottom: 10),
                sliver: SliverToBoxAdapter(
                  child: Center(
                    child: CarouselUserHomeWidget(
                      controller: carouselController,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(vertical: 10),
                sliver: SliverToBoxAdapter(
                  child: SmoothPageIndWidget(
                    carouselController: carouselController,
                  ),
                ),
              ),

              const ProductsWidget(title: 'All features', dataTitle: ''),
              const ProductsWidget(title: 'NDURE', dataTitle: 'NDURE'),
              const ProductsWidget(title: 'Bata', dataTitle: 'Bata'),
              const ProductsWidget(title: 'Stylo', dataTitle: 'Stylo'),
              const ProductsWidget(title: 'Servis', dataTitle: 'Servis'),
            ],
          ),
        ),
      ),
    );
  }
}
