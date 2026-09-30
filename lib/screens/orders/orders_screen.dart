import 'package:ecommerce_mobile_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Orders', style: AppTypography.headline2),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 80.sp,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 16.h),
            Text('No Orders Yet', style: AppTypography.headline3),
            SizedBox(height: 8.h),
            Text(
              'Your orders will appear here',
              style: AppTypography.bodyText2,
            ),
          ],
        ),
      ),
    );
  }
}
