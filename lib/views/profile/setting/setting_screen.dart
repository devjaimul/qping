
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:qping/views/profile/setting/about_screen.dart';
import 'package:qping/views/profile/setting/change%20password/change_password.dart';
import 'package:qping/views/profile/setting/privacy_policy_screen.dart';
import 'package:qping/views/profile/setting/terms_screen.dart';



class SettingScreen extends StatelessWidget {

  const SettingScreen({super.key,});

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(text: "Setting",fontSize: 18.sp,color: AppColors.textColor,),
      ),
      body: Padding(
        padding: EdgeInsets.all(sizeH * .008),
        child: Column(
          children: [
            _buildProfileOption(
              icon: Icons.lock,
              label: 'Change Password',
              onTap: () {
              Get.to(()=>const ChangePassword());
              },
            ),
            _buildProfileOption(
              icon: Icons.privacy_tip,
              label: 'Privacy Policy',
              onTap: () {
                Get.to(const PrivacyPolicyScreen());
              },
            ),
            _buildProfileOption(
              icon: Icons.info_outline,
              label: 'Terms & Services',
              onTap: () {
                Get.to(const TermsScreen());
              },
            ),
            _buildProfileOption(
              icon: Icons.help_outline,
              label: 'About Us',
              onTap: () {
                Get.to(const AboutScreen());
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to build the profile options
  Widget _buildProfileOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color borderColor = AppColors.primaryColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.r),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              SizedBox(width: 10.w),
              Icon(icon, color: AppColors.primaryColor.withOpacity(0.5), size: 20.h),
              SizedBox(width: 20.w),
              CustomTextTwo(text: label),
              const Spacer(),
              Icon(Icons.arrow_forward_ios, color: AppColors.primaryColor.withOpacity(0.5 ), size: 18.h),
              SizedBox(width: 10.w),
            ],
          ),
        ),
      ),
    );
  }
}
