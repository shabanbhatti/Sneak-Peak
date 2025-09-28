import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sneak_peak/firebase_options.dart';
import 'package:sneak_peak/pages/admin%20screens/theme%20page/theme_page.dart';
import 'package:sneak_peak/routes/go_router.dart';
import 'package:sneak_peak/theme/theme.dart';
import 'package:sneak_peak/utils/snack_bar_helper.dart';

GlobalKey<ScaffoldMessengerState> snackBarContext =
    GlobalKey<ScaffoldMessengerState>();

@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
 FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);
  // var x= await GetServerKey.getServerKey();
  // log(x);
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
