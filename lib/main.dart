import 'package:ecommerce_mobile_app/di/injector.dart';
import 'package:ecommerce_mobile_app/firebase_options.dart';
import 'package:ecommerce_mobile_app/router/app_router.dart';
import 'package:ecommerce_mobile_app/services/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Configure dependencies
    await configureDependencies();

    // Initialize notification service
    final notificationService = getIt<NotificationService>();
    await notificationService.initialize();

    // Initialize remote config service
    try {
      final remoteConfigService = getIt<RemoteConfigService>();
      await remoteConfigService.initialize();
    } catch (e) {
      debugPrint('Remote Config initialization failed: $e');
    }
  } catch (e) {
    debugPrint('App initialization failed: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp.router(
        routerConfig: router,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
      ),
    );
  }
}
