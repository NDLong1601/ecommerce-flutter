import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ecommerce_mobile_app/theme/app_typography.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAllTap;

  const SectionHeader({
    super.key,
    required this.title,
    required this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTypography.headline2.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF272727),
            ),
          ),
          GestureDetector(
            onTap: onSeeAllTap,
            child: Text(
              'See All',
              style: AppTypography.bodyText2.copyWith(
                fontSize: 14.sp,
                color: const Color(0xFF8E6CEF),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
