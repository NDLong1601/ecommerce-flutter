import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ecommerce_mobile_app/theme/app_typography.dart';

class ProductCard extends StatelessWidget {
  final String image;
  final String name;
  final double price;
  final double? oldPrice;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  final bool isFavorite;

  const ProductCard({
    super.key,
    required this.image,
    required this.name,
    required this.price,
    this.oldPrice,
    required this.onTap,
    required this.onFavorite,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 156.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: 156.w,
                  height: 180.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: Image.asset(image, fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: GestureDetector(
                    onTap: onFavorite,
                    child: Container(
                      width: 32.w,
                      height: 32.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 18.sp,
                        color: isFavorite
                            ? Colors.red
                            : const Color(0xFF272727),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                name,
                style: AppTypography.bodyText2.copyWith(
                  fontSize: 14.sp,
                  color: const Color(0xFF272727),
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Row(
                children: [
                  Text(
                    '\$${price.toStringAsFixed(2)}',
                    style: AppTypography.bodyText1.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF272727),
                    ),
                  ),
                  if (oldPrice != null) ...[
                    SizedBox(width: 8.w),
                    Text(
                      '\$${oldPrice!.toStringAsFixed(2)}',
                      style: AppTypography.bodyText2.copyWith(
                        fontSize: 14.sp,
                        color: const Color(0xFF9E9E9E),
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 6.h),
          ],
        ),
      ),
    );
  }
}
