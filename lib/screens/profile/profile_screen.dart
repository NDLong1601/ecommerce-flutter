import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_mobile_app/cubit/profile/profile.dart';
import 'package:ecommerce_mobile_app/di/injector.dart';
import 'package:ecommerce_mobile_app/router/route_name.dart';
import 'package:ecommerce_mobile_app/screens/profile/widgets/widgets.dart';
import 'package:ecommerce_mobile_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileCubit>()..loadUserProfile(),
      child: const _ProfileScreenContent(),
    );
  }
}

class _ProfileScreenContent extends StatelessWidget {
  const _ProfileScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(context, state),
                SizedBox(height: 16.h),
                _buildUserInfoCard(context, state),
                SizedBox(height: 24.h),
                _buildMenuSections(context),
                SizedBox(height: 24.h),
                _buildSignOutButton(context),
                SizedBox(height: 32.h),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ProfileState state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20.h),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
      ),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          _buildUserAvatar(state.imageUrl),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildUserAvatar(String imageUrl) {
    return Container(
      width: 100.w,
      height: 100.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: imageUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.lightGrey,
                  child: Icon(
                    Icons.person,
                    size: 48.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.lightGrey,
                  child: Icon(
                    Icons.person,
                    size: 48.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              )
            : Container(
                color: AppColors.lightGrey,
                child: Icon(
                  Icons.person,
                  size: 48.sp,
                  color: AppColors.textSecondary,
                ),
              ),
      ),
    );
  }

  Widget _buildUserInfoCard(BuildContext context, ProfileState state) {
    final fullName = '${state.firstName} ${state.lastName}'.trim();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullName.isNotEmpty ? fullName : 'User Name',
                    style: AppTypography.headline3,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    state.email.isNotEmpty ? state.email : 'email@example.com',
                    style: AppTypography.bodyText2,
                  ),
                  if (state.dateOfBirth.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Text(state.dateOfBirth, style: AppTypography.bodyText2),
                  ],
                ],
              ),
            ),
            GestureDetector(
              onTap: () => _showEditProfileSheet(context, state),
              child: Text(
                'Edit',
                style: AppTypography.bodyText1.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileSheet(BuildContext context, ProfileState state) {
    final profileCubit = context.read<ProfileCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditProfileBottomSheet(
        firstName: state.firstName,
        lastName: state.lastName,
        dateOfBirth: state.dateOfBirth,
        imageUrl: state.imageUrl,
        onSave:
            ({
              required String firstName,
              required String lastName,
              required String dateOfBirth,
              String? imageUrl,
            }) {
              profileCubit.updateProfile(
                firstName: firstName,
                lastName: lastName,
                dateOfBirth: dateOfBirth,
                imageUrl: imageUrl,
              );
            },
      ),
    );
  }

  Widget _buildMenuSections(BuildContext context) {
    final menuItems = [
      _MenuItem(icon: Icons.location_on_outlined, title: 'Address'),
      _MenuItem(icon: Icons.favorite_border_rounded, title: 'Wishlist'),
      _MenuItem(icon: Icons.payment_outlined, title: 'Payment'),
      _MenuItem(icon: Icons.help_outline_rounded, title: 'Help'),
      _MenuItem(icon: Icons.support_agent_outlined, title: 'Support'),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: menuItems
            .map((item) => _buildMenuItem(context, item))
            .toList(),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, _MenuItem item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Text(item.title, style: AppTypography.bodyText1),
              const Spacer(),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
                size: 24.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignOutButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Sign Out'),
            content: const Text('Are you sure you want to sign out?'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(
                  'Cancel',
                  style: AppTypography.bodyText1.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text(
                  'Sign Out',
                  style: AppTypography.bodyText1.copyWith(color: Colors.red),
                ),
              ),
            ],
          ),
        );

        if (confirmed == true && context.mounted) {
          await context.read<ProfileCubit>().signOut();
          if (context.mounted) {
            context.go(RouteName.signInRoute);
          }
        }
      },
      child: Text(
        'Sign Out',
        style: AppTypography.bodyText1.copyWith(
          color: Colors.red,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;

  const _MenuItem({required this.icon, required this.title});
}
