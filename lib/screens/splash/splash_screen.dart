import 'package:flutter/material.dart';
import 'package:ecommerce_mobile_app/theme/theme.dart';
import 'package:ecommerce_mobile_app/router/route_name.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToSignIn();
  }

  Future<void> _navigateToSignIn() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      context.go(RouteName.signInRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(child: Text('Clot', style: AppTypography.splashTitle)),
    );
  }
}
