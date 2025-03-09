
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/dialog.dart';
import 'package:qping/routes/app_routes.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:qping/views/profile/setting/app_data_screen.dart';
import 'package:qping/views/profile/setting/change%20password/change_password.dart';




class SettingScreen extends StatelessWidget {

  const SettingScreen({super.key,});

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(text: "Settings",fontSize: 18.sp,color: AppColors.textColor,),
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
                Get.to( const AppData(type: "privacy-policy",));
              },
            ),
            _buildProfileOption(
              icon: Icons.info_outline,
              label: 'Terms & Services',
              onTap: () {
                Get.to( const AppData(type: "terms-and-conditions",));
              },
            ),
            _buildProfileOption(
              icon: Icons.help_outline,
              label: 'About Us',
              onTap: () {
                Get.to( const AppData(type: "about-us",));
              },
            ),
            const Spacer(),
            _buildProfileOption(
              icon: Icons.delete,
              fillColor: AppColors.primaryColor.withOpacity(0.8),
              iconColor: Colors.red,
              noIcon: true,
              textColor: Colors.white,
              label: 'Delete Account',
              onTap: () {
                Get.dialog(
                  CustomDialog(
                    title: "Are you sure you want to delete this account?",
                    confirmButtonText: "Yes",
                    cancelButtonText: "No",
                    onCancel: () {
                      Get.back();
                    },
                    onConfirm: () {
                      Get.offAllNamed(AppRoutes.signInScreen);
                    },
                  ),
                );
              },
            ),
            SizedBox(height: 20.h,)
          ],
        ),
      ),
    );
  }

  // Helper widget to build the profile options
  Widget _buildProfileOption({
    required IconData icon,
     Color? iconColor,
     Color? fillColor,
     Color? textColor,
    bool? noIcon,
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
            color:fillColor ,
            borderRadius: BorderRadius.circular(50.r),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              SizedBox(width: 10.w),
              Icon(icon, color:iconColor?? AppColors.primaryColor.withOpacity(0.5), size: 20.h),
              SizedBox(width: 20.w),
              CustomTextTwo(text: label,color: textColor,),
              const Spacer(),
            noIcon==true?const SizedBox.shrink():  Icon(Icons.arrow_forward_ios, color:AppColors.primaryColor.withOpacity(0.5 ), size: 18.h),
              SizedBox(width: 10.w),
            ],
          ),
        ),
      ),
    );
  }
}
