import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ecommerce_mobile_app/theme/theme.dart';
import 'package:ecommerce_mobile_app/shared/shared.dart';
import 'package:ecommerce_mobile_app/router/route_name.dart';
import 'package:ecommerce_mobile_app/cubit/cubit.dart';
import 'package:ecommerce_mobile_app/di/injector.dart';
import 'package:go_router/go_router.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CreateAccountCubit>(),
      child: const _CreateAccountScreenContent(),
    );
  }
}

class _CreateAccountScreenContent extends StatefulWidget {
  const _CreateAccountScreenContent();

  @override
  State<_CreateAccountScreenContent> createState() =>
      _CreateAccountScreenContentState();
}

class _CreateAccountScreenContentState
    extends State<_CreateAccountScreenContent> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleCreateAccount(BuildContext context) {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    context.read<CreateAccountCubit>().createAccountWithEmail(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateAccountCubit, CreateAccountState>(
      listener: (context, state) {
        if (state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account created successfully! Please sign in.'),
            ),
          );
          context.go(RouteName.signInRoute);
        } else if (state.errorMessage.isNotEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: AppColors.text,
                size: 20.sp,
              ),
              onPressed: () => context.pop(),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Create Account', style: AppTypography.headline1),
                  SizedBox(height: 32.h),
                  AppTextField(
                    hintText: 'First Name',
                    controller: _firstNameController,
                    keyboardType: TextInputType.name,
                  ),
                  SizedBox(height: 16.h),
                  AppTextField(
                    hintText: 'Last Name',
                    controller: _lastNameController,
                    keyboardType: TextInputType.name,
                  ),
                  SizedBox(height: 16.h),
                  AppTextField(
                    hintText: 'Email Address',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16.h),
                  AppTextField(
                    hintText: 'Password',
                    controller: _passwordController,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  SizedBox(height: 24.h),
                  AppButton(
                    text: 'Continue',
                    onPressed: state.isLoading
                        ? null
                        : () => _handleCreateAccount(context),
                    isLoading: state.isLoading,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
