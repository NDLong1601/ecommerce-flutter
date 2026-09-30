import 'package:ecommerce_mobile_app/router/route_name.dart';
import 'package:ecommerce_mobile_app/screens/main/main_screen.dart';
import 'package:ecommerce_mobile_app/screens/splash/splash_screen.dart';
import 'package:ecommerce_mobile_app/screens/sign_in/sign_in_screen.dart';
import 'package:ecommerce_mobile_app/screens/create_account/create_account_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: RouteName.splashRoute,
  routes: [
    GoRoute(
      path: RouteName.splashRoute,
      name: RouteName.splashRoute,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RouteName.signInRoute,
      name: RouteName.signInRoute,
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: RouteName.createAccountRoute,
      name: RouteName.createAccountRoute,
      builder: (context, state) => const CreateAccountScreen(),
    ),
    GoRoute(
      path: RouteName.mainRoute,
      name: RouteName.mainRoute,
      builder: (context, state) => const MainScreen(),
    ),
  ],
);
