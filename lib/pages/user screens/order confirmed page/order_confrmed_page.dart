import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/pages/user%20screens/user_main.dart';
import 'package:sneak_peak/utils/constant_imgs.dart';
import 'package:sneak_peak/widgets/custom%20btn/custom_button.dart';

class OrderConfirmedPage extends StatelessWidget {
  const OrderConfirmedPage({super.key});
  static const pageName = 'order_confirmed';
  @override
  Widget build(BuildContext context) {
    print('CONFIRMED ORDER BUILD CALLED');
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.transparent,
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: orderConfirmedUrl,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),

              Align(
                alignment: Alignment.center,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.7,
                  color: Theme.of(
                    context,
                  ).scaffoldBackgroundColor.withAlpha(150),
                  alignment: Alignment.center,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 70,
                        ),
                      ),

                      Flexible(
                        child: Text(
                          'Order confirmed',
                          style: TextStyle(
                            fontSize: 30,

                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Flexible(
                        child: Text(
                          'Thank you for your order.',
                          style: TextStyle(fontSize: 12, color: Colors.orange),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Align(
                alignment: Alignment(0, 0.5),
                child: CustomButton(
                  btnTitle: 'Continue shopping',
                  onTap:
                      () => GoRouter.of(context).goNamed(UserMainPage.pageName),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
