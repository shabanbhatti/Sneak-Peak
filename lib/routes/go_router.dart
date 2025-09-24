import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sneak_peak/Notifications/firebase_noti_page.dart';
import 'package:sneak_peak/models/address_modal.dart';
import 'package:sneak_peak/models/cart_poduct_modal.dart';
import 'package:sneak_peak/models/orders_modals.dart';
import 'package:sneak_peak/models/products_modals.dart';
import 'package:sneak_peak/pages/admin%20screens/add%20product%20page/admin_add_product_page.dart';
import 'package:sneak_peak/pages/admin%20screens/admin_main.dart';
import 'package:sneak_peak/pages/admin%20screens/completed%20orders%20page/admin_completed_orders_page.dart';
import 'package:sneak_peak/pages/admin%20screens/edit%20name%20page/admin_edit_name_page.dart';
import 'package:sneak_peak/pages/admin%20screens/theme%20page/admin_theme_page.dart';
import 'package:sneak_peak/pages/admin%20screens/update%20product%20page/update_product_page.dart';
import 'package:sneak_peak/pages/admin%20screens/view%20order%20page%20from%20settings/view_admin_order_page.dart';
import 'package:sneak_peak/pages/admin%20screens/view%20orders%20page/view_orders_page.dart';
import 'package:sneak_peak/pages/auth%20pages/forgot%20pass%20page/forgot_pass_page.dart';
import 'package:sneak_peak/pages/auth%20pages/login%20page/login_page.dart';
import 'package:sneak_peak/pages/auth%20pages/signup%20page/signup_page.dart';
import 'package:sneak_peak/pages/initial%20pages/decide_page.dart';
import 'package:sneak_peak/pages/initial%20pages/intro_page.dart';
import 'package:sneak_peak/pages/initial%20pages/splash_page.dart';
import 'package:sneak_peak/pages/user%20screens/address%20page/address_page.dart';
import 'package:sneak_peak/pages/user%20screens/cancellation%20page/cancellation_page.dart';
import 'package:sneak_peak/pages/user%20screens/change%20password%20page/change_password_page.dart';
import 'package:sneak_peak/pages/user%20screens/check%20out%20page/check_out_page.dart';
import 'package:sneak_peak/pages/user%20screens/completed%20orders%20page/completed_orders_page.dart';
import 'package:sneak_peak/pages/user%20screens/order%20confirmed%20page/order_confrmed_page.dart';
import 'package:sneak_peak/pages/user%20screens/payment%20method%20page/payment_meth_page.dart';
import 'package:sneak_peak/pages/user%20screens/pending%20order%20page/pending_orders_page.dart';
import 'package:sneak_peak/pages/user%20screens/see%20all%20page/see_all_page.dart';
import 'package:sneak_peak/pages/user%20screens/settings%20page/settings_page.dart';
import 'package:sneak_peak/pages/user%20screens/to%20ship%20page/to_ship_page.dart';
import 'package:sneak_peak/pages/user%20screens/update%20email%20page/update_email_page.dart';
import 'package:sneak_peak/pages/user%20screens/update%20username%20page/update_username_page.dart';
import 'package:sneak_peak/pages/user%20screens/user_main.dart';
import 'package:sneak_peak/pages/user%20screens/view%20orders%20page/view_order_page.dart';
import 'package:sneak_peak/pages/user%20screens/view%20product%20image%20page/view_product_img_page.dart';
import 'package:sneak_peak/pages/user%20screens/view%20product%20page/view_product_page.dart';
import 'package:sneak_peak/pages/user%20screens/view%20user%20img%20page/view_user_img_page.dart';
import 'package:sneak_peak/pages/user%20screens/wishlist%20page/wishlist_page.dart';

class AppGoRouter {
  static GoRouter goRouter = GoRouter(
    initialLocation: '/intro',

    routes: [
      GoRoute(
        name: IntroPage.pageName,
        path: '/intro',
        builder: (context, state) => const IntroPage(),
      ),

       GoRoute(
        name: FirebaseNotiPage.pageName,
        path: '/firebase_noti',
        builder: (context, state) => const FirebaseNotiPage(),
      ),

      GoRoute(
        name: DecidePage.pageName,
        path: '/decide',
        builder: (context, state) => const DecidePage(),
      ),

      GoRoute(
        name: SplashPage.pageName,
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),

      GoRoute(
        name: LoginPage.pageName,
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),

      GoRoute(
        name: SignupPage.pageName,
        path: '/signup',
        builder: (context, state) => const SignupPage(),
      ),

      GoRoute(
        name: ForgotPasswordPage.pageName,
        path: '/forgotpassword',
        builder: (context, state) => const ForgotPasswordPage(),
      ),

      GoRoute(
        name: UserMainPage.pageName,
        path: '/usermain',
        builder: (context, state) => const UserMainPage(),
      ),

      GoRoute(
        name: AdminMain.pageName,
        path: '/admin_home',
        builder: (context, state) => const AdminMain(),
      ),

      GoRoute(
        name: AddProductPage.pageName,
        path: '/add_product',
        builder: (context, state) => const AddProductPage(),
      ),

      GoRoute(
        name: AdminUpdateProductPage.pageName,
        path: '/update/:name/:id',
        builder:
            (context, state) => AdminUpdateProductPage(
              productModal: state.extra as ProductModal,
            ),
      ),

      GoRoute(
        name: AdminEditNamePage.pageName,
        path: '/edit/:username',

        pageBuilder:
            (context, state) => CupertinoPage(child: const AdminEditNamePage()),
      ),

      GoRoute(
        name: ThemePage.pageName,
        path: '/theme',

        pageBuilder:
            (context, state) => CupertinoPage(child: const ThemePage()),
      ),

       GoRoute(
        name: UpdateEmailPage.pageName,
        path: '/update_email',

        pageBuilder:
            (context, state) => CupertinoPage(child: const UpdateEmailPage()),
      ),

      GoRoute(
        name: UpdateUsernamePage.pageName,
        path: '/update_username',

        pageBuilder:
            (context, state) => CupertinoPage(child: const UpdateUsernamePage()),
      ),

      GoRoute(
        name: ChangePasswordPage.pageName,
        path: '/change_password',

        pageBuilder:
            (context, state) => CupertinoPage(child: const ChangePasswordPage()),
      ),

      GoRoute(
        name: SeeAllPage.pageName,
        path: '/see_all',

        pageBuilder:
            (context, state) => CupertinoPage(
              child: SeeAllPage(fileName: state.extra as String),
            ),
      ),
      GoRoute(
        name: ViewUserImgPage.pageName,
        path: '/view_user_img',
        pageBuilder:
            (context, state) => MaterialPage(
              child: ViewUserImgPage(imgUrl: state.extra as String),
            ),
      ),

      GoRoute(
        name: OrderConfirmedPage.pageName,
        path: '/order_confirm',
        pageBuilder:
            (context, state) =>
                MaterialPage(canPop: false, child: const OrderConfirmedPage()),
      ),

      GoRoute(
        name: ToShipPage.pageName,
        path: '/to_ship',
        pageBuilder:
            (context, state) => CupertinoPage(child: const ToShipPage()),
      ),

      GoRoute(
        name: CompletedPage.pageName,
        path: '/completed_orders',
        pageBuilder:
            (context, state) => CupertinoPage(child: const CompletedPage()),
      ),

      GoRoute(
        name: SettingsPage.pageName,
        path: '/settings',
        pageBuilder:
            (context, state) => CupertinoPage(child: const SettingsPage()),
      ),

      GoRoute(
        name: AdminViewOrdersPage.pageName,
        path: '/admin_view_order',
        pageBuilder:
            (context, state) => CupertinoPage(
              child: AdminViewOrdersPage(
                ordersModals: state.extra as OrdersModals,
              ),
            ),
      ),

      GoRoute(
        name: ViewProductImgPage.pageName,
        path: '/view_product_img/:index',
        pageBuilder:
            (context, state) => MaterialPage(
              child: ViewProductImgPage(
                imgList: state.extra as List<String>,
                index: state.pathParameters['index'] as String,
              ),
            ),
      ),

      GoRoute(
        name: ViewOrderPage.pageName,
        path: '/view_to_ship',
        pageBuilder:
            (context, state) => CupertinoPage(
              child: ViewOrderPage(ordersModals: state.extra as OrdersModals),
            ),
      ),

      GoRoute(
        name: ViewAdminOrderPage.pageName,
        path: '/view_admin_order',
        pageBuilder:
            (context, state) => CupertinoPage(
              child: ViewAdminOrderPage(
                ordersModals: state.extra as OrdersModals,
              ),
            ),
      ),

      GoRoute(
        name: ViewProductPage.pageName,
        path: '/view_product/:title',

        pageBuilder: (context, state) {
          Map<String, dynamic> data = state.extra as Map<String, dynamic>;
          ProductModal? productModal = data['productModal'];
          String id = data['id'] as String;
          return CupertinoPage(
            child: ViewProductPage(productModal: productModal, id: id),
          );
        },
      ),

      GoRoute(
        name: CheckOutPage.pageName,
        path: '/checkout',

        pageBuilder:
            (context, state) => CustomTransitionPage(
              barrierDismissible: true,
              child: CheckOutPage(),
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                return ScaleTransition(
                  scale: animation.drive(Tween(begin: 0.0, end: 1.0)),
                  child: child,
                );
              },
              barrierColor: Colors.black.withAlpha(100),
            ),
      ),

      GoRoute(
        name: AddHomeAddress.pageName,
        path: '/home_addess',

        pageBuilder: (context, state) {
          return CupertinoPage(
            child: AddHomeAddress(addressModal: state.extra as AddressModal),
          );
        },
      ),

      GoRoute(
        name: PaymentMethPage.pageName,
        path: '/payment_methods',

        pageBuilder: (context, state) {
          Map<String, dynamic> data = state.extra as Map<String, dynamic>;

          List<CartProductModal> cartList =
              data['cartList'] as List<CartProductModal>;
          bool isFromPendingPayentPage = data['pendingPageOrNot'] as bool;

          return CupertinoPage(
            canPop: false,
            child: PaymentMethPage(
              cartList: cartList,
              isFromPendingPayentPage: isFromPendingPayentPage,
            ),
          );
        },
      ),

      GoRoute(
        name: PendingOrders.pageName,
        path: '/pending_orders',

        pageBuilder: (context, state) {
          return CupertinoPage(child: const PendingOrders());
        },
      ),

      GoRoute(
        name: CancellationPage.pageName,
        path: '/cancellations',

        pageBuilder: (context, state) {
          return CupertinoPage(child: const CancellationPage());
        },
      ),

      GoRoute(
        name: AdminCompletedOrdersPage.pageName,
        path: '/admin_completed_orders',

        pageBuilder: (context, state) {
          return CupertinoPage(child: const AdminCompletedOrdersPage());
        },
      ),

      GoRoute(
        name: WishlistPage.pageName,
        path: '/wishlist',

        pageBuilder: (context, state) {
          return CupertinoPage(child: const WishlistPage());
        },
      ),
    ],
  );
}
