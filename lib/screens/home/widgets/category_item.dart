import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ecommerce_mobile_app/theme/app_typography.dart';

class CategoryItem extends StatelessWidget {
  final String image;
  final String label;
  final VoidCallback onTap;

  const CategoryItem({
    super.key,
    required this.image,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56.w,
            height: 56.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(28.r),
            ),
            child: Center(
              child: Image.asset(
                image,
                width: 32.w,
                height: 32.h,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: AppTypography.bodyText2.copyWith(
              fontSize: 12.sp,
              color: const Color(0xFF272727),
            ),
          ),
        ],
      ),
    );
  }
}
