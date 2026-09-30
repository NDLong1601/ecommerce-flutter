import 'package:ecommerce_mobile_app/shared/shared.dart';
import 'package:ecommerce_mobile_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfileBottomSheet extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String dateOfBirth;
  final String imageUrl;
  final void Function({
    required String firstName,
    required String lastName,
    required String dateOfBirth,
    String? imageUrl,
  })
  onSave;

  const EditProfileBottomSheet({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.imageUrl,
    required this.onSave,
  });

  @override
  State<EditProfileBottomSheet> createState() => _EditProfileBottomSheetState();
}

class _EditProfileBottomSheetState extends State<EditProfileBottomSheet> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _dateOfBirthController;
  late TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.firstName);
    _lastNameController = TextEditingController(text: widget.lastName);
    _dateOfBirthController = TextEditingController(text: widget.dateOfBirth);
    _imageUrlController = TextEditingController(text: widget.imageUrl);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dateOfBirthController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1995, 1, 12),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateOfBirthController.text =
            '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24.w,
        right: 24.w,
        top: 16.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Center(child: Text('Edit Profile', style: AppTypography.headline2)),
            SizedBox(height: 24.h),
            Text(
              'Profile Image URL',
              style: AppTypography.bodyText2.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            AppTextField(
              hintText: 'Enter image URL',
              controller: _imageUrlController,
              keyboardType: TextInputType.url,
            ),
            SizedBox(height: 16.h),
            Text(
              'First Name',
              style: AppTypography.bodyText2.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            AppTextField(
              hintText: 'Enter first name',
              controller: _firstNameController,
            ),
            SizedBox(height: 16.h),
            Text(
              'Last Name',
              style: AppTypography.bodyText2.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            AppTextField(
              hintText: 'Enter last name',
              controller: _lastNameController,
            ),
            SizedBox(height: 16.h),
            Text(
              'Date of Birth',
              style: AppTypography.bodyText2.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            GestureDetector(
              onTap: _selectDate,
              child: AbsorbPointer(
                child: AppTextField(
                  hintText: 'DD-MM-YYYY',
                  controller: _dateOfBirthController,
                  suffixIcon: Icon(
                    Icons.calendar_today_outlined,
                    size: 20.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            AppButton(
              text: 'Save Changes',
              onPressed: () {
                widget.onSave(
                  firstName: _firstNameController.text.trim(),
                  lastName: _lastNameController.text.trim(),
                  dateOfBirth: _dateOfBirthController.text.trim(),
                  imageUrl: _imageUrlController.text.trim(),
                );
                Navigator.of(context).pop();
              },
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}
