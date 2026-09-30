import 'package:ecommerce_mobile_app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTypography {
  static const TextStyle splashTitle = TextStyle(
    fontSize: 72,
    fontWeight: FontWeight.bold,
    fontFamily: 'CircularStd',
    color: AppColors.white,
    letterSpacing: 8,
  );

  static const TextStyle headline1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    fontFamily: 'CircularStd',
    color: AppColors.text,
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    fontFamily: 'CircularStd',
  );

  static const TextStyle headline3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    fontFamily: 'CircularStd',
  );

  static const TextStyle bodyText1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    fontFamily: 'CircularStd',
    color: AppColors.text,
  );

  static const TextStyle bodyText2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    fontFamily: 'CircularStd',
    color: AppColors.textSecondary,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: 'CircularStd',
    color: AppColors.white,
  );
}
