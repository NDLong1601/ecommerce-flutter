import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ecommerce_mobile_app/theme/app_colors.dart';
import 'package:ecommerce_mobile_app/theme/app_typography.dart';
import 'package:ecommerce_mobile_app/screens/home/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Set<int> _favoriteProducts = {};

  final List<Map<String, dynamic>> _categories = [
    {'image': 'assets/images/img_logo.png', 'label': 'Hoodies'},
    {'image': 'assets/images/img_logo.png', 'label': 'Shorts'},
    {'image': 'assets/images/img_logo.png', 'label': 'Shoes'},
    {'image': 'assets/images/img_logo.png', 'label': 'Bag'},
    {'image': 'assets/images/img_logo.png', 'label': 'Accessories'},
  ];

  final List<Map<String, dynamic>> _topSellingProducts = [
    {
      'image': 'assets/images/img_logo.png',
      'name': 'Men\'s Harrington Jacket',
      'price': 148.00,
      'oldPrice': null,
    },
    {
      'image': 'assets/images/img_logo.png',
      'name': 'Max Cirro Men\'s Slides',
      'price': 55.00,
      'oldPrice': 100.97,
    },
    {
      'image': 'assets/images/img_logo.png',
      'name': 'Men\'s Sneakers',
      'price': 66.00,
      'oldPrice': null,
    },
  ];

  final List<Map<String, dynamic>> _newInProducts = [
    {
      'image': 'assets/images/img_logo.png',
      'name': 'Men\'s Casual Shirt',
      'price': 89.00,
      'oldPrice': null,
    },
    {
      'image': 'assets/images/img_logo.png',
      'name': 'Men\'s Cap',
      'price': 25.00,
      'oldPrice': 45.00,
    },
  ];

  void _toggleFavorite(int index) {
    setState(() {
      if (_favoriteProducts.contains(index)) {
        _favoriteProducts.remove(index);
      } else {
        _favoriteProducts.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    _buildSearchBar(),
                    SizedBox(height: 24.h),
                    _buildCategoriesSection(),
                    SizedBox(height: 24.h),
                    _buildTopSellingSection(),
                    SizedBox(height: 24.h),
                    _buildNewInSection(),
                    SizedBox(height: 80.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/img_logo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              children: [
                Text(
                  'Men',
                  style: AppTypography.bodyText1.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF272727),
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 20.sp,
                  color: const Color(0xFF272727),
                ),
              ],
            ),
          ),
          Container(
            width: 40.w,
            height: 40.h,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              size: 20.sp,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(28.r),
        ),
        child: Row(
          children: [
            Icon(Icons.search, size: 20.sp, color: const Color(0xFF9E9E9E)),
            SizedBox(width: 12.w),
            Text(
              'Search',
              style: AppTypography.bodyText2.copyWith(
                fontSize: 14.sp,
                color: const Color(0xFF9E9E9E),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      children: [
        SectionHeader(
          title: 'Categories',
          onSeeAllTap: () {
            // Navigate to categories
          },
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 90.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              return Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: CategoryItem(
                  image: category['image'],
                  label: category['label'],
                  onTap: () {
                    // Navigate to category
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTopSellingSection() {
    return Column(
      children: [
        SectionHeader(
          title: 'Top Selling',
          onSeeAllTap: () {
            // Navigate to top selling
          },
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 260.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: _topSellingProducts.length,
            itemBuilder: (context, index) {
              final product = _topSellingProducts[index];
              return Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: ProductCard(
                  image: product['image'],
                  name: product['name'],
                  price: product['price'],
                  oldPrice: product['oldPrice'],
                  isFavorite: _favoriteProducts.contains(index),
                  onTap: () {
                    // Navigate to product detail
                  },
                  onFavorite: () => _toggleFavorite(index),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNewInSection() {
    return Column(
      children: [
        SectionHeader(
          title: 'New In',
          onSeeAllTap: () {
            // Navigate to new in
          },
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 260.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: _newInProducts.length,
            itemBuilder: (context, index) {
              final product = _newInProducts[index];
              final favoriteIndex = _topSellingProducts.length + index;
              return Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: ProductCard(
                  image: product['image'],
                  name: product['name'],
                  price: product['price'],
                  oldPrice: product['oldPrice'],
                  isFavorite: _favoriteProducts.contains(favoriteIndex),
                  onTap: () {
                    // Navigate to product detail
                  },
                  onFavorite: () => _toggleFavorite(favoriteIndex),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
