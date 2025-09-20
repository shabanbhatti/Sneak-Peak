import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/Notifications/firebase_notifications_service.dart';
import 'package:sneak_peak/firebase_options.dart';
import 'package:sneak_peak/pages/admin%20screens/theme%20page/admin_theme_page.dart';
import 'package:sneak_peak/routes/go_router.dart';
import 'package:sneak_peak/utils/app%20theme/app_theme.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';

GlobalKey<ScaffoldMessengerState> snackBarContext =
    GlobalKey<ScaffoldMessengerState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseNotificationsService.onKilledApp();
  FirebaseNotificationsService.onBackgroundNotification();
  // FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

  var ref = ProviderContainer();
  await ref.read(themeProvider.notifier).getTheme();
  runApp(UncontrolledProviderScope(container: ref, child: const MyApp()));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        var themeData = ref.watch(themeProvider).themeData;
        var groupvalue = ref.watch(themeProvider).groupValue;
        return MaterialApp.router(
          theme: (groupvalue == 'system') ? lightTheme : themeData,
          darkTheme: (groupvalue == 'system') ? darkTheme : null,

          debugShowCheckedModeBanner: false,
          routerConfig: AppGoRouter.goRouter,
          scaffoldMessengerKey: SnackBarHelper.messengerKey,
        );
      },
    );
  }
}
