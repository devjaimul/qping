
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/dialog.dart';
import 'package:qping/routes/app_routes.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:qping/utils/app_icons.dart';
import 'package:qping/utils/app_images.dart';
import 'package:qping/views/profile/profile_information.dart';
import 'package:qping/views/profile/setting/setting_screen.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;
    final sizeW = MediaQuery.sizeOf(context).width;


    return Scaffold(
    
      body:Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: sizeH * .05),
          // Profile picture
          Container(
            width: 120.r,
            height: 120.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 10.r,
                  offset: const Offset(0, 5),
                ),
              ],
              border: Border.all(
                color: AppColors.primaryColor.withOpacity(0.5), // Outer blue border
                width: 2.w,
              ),
            ),
            child: CircleAvatar(
              radius: 50.r,
              backgroundColor: Colors.grey[300],
              backgroundImage: AssetImage(AppImages.model),
            ),
          ),

          SizedBox(height: sizeH * .02),
          // Name
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: CustomTextOne(
              text: "Lucy",
              fontSize: 18.sp,
              color: AppColors.textColor,
              maxLine: 1,
              textOverflow: TextOverflow.ellipsis,
            ),
          ),


          SizedBox(height: sizeH * .016),
          const Divider(
            thickness: 1,
            indent: 40,
            endIndent: 40,
          ),
          SizedBox(height: sizeH * .02),
          // Profile buttons
          _buildProfileOption(
            icon: Image.asset(AppIcons.person,height: 18.h),
            label: 'Profile Information',
            onTap: () async {
              await Get.to(()=> ProfileInformation());
            },
          ),
          const Divider(
            thickness: 1,
            indent: 40,
            endIndent: 40,
          ),
          _buildProfileOption(
            icon: Icon(Icons.settings_outlined,color: AppColors.primaryColor.withOpacity(0.5),size: 22.sp,),
            label: 'Settings',
            onTap: () {
              Get.to( ()=> SettingScreen());
            },
          ),
          const Divider(
            thickness: 1,
            indent: 40,
            endIndent: 40,
          ),

          // Logout button
          _buildProfileOption(
            isTrue: true,
            icon: Icon(Icons.logout,color: AppColors.primaryColor.withOpacity(0.5),size: 22.sp,),
            label: 'Logout',
            iconColor: Colors.red,
            labelColor: Colors.red,
            borderColor: Colors.red,
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialog(
                    title: "Are you sure you want to \n LogOut ",
                    onCancel: () {
                  Get.back();
                    },
                    onConfirm: () {
                      // Perform logout logic
                     Get.offAllNamed(AppRoutes.signInScreen);
                    },
                  );
                },
              );
            },

          ),
          const Divider(
            thickness: 1,
            indent: 40,
            endIndent: 40,
          ),
        ],
      ),
    );
  }

  // Helper widget to build the profile options
  Widget _buildProfileOption({
    required Widget icon,
    required String label,
    required VoidCallback onTap,
    Color iconColor = Colors.white,
    Color labelColor = Colors.white,
    Color borderColor = Colors.white24,
    final bool? isTrue,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric( horizontal: 25.w),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            children: [
              SizedBox(width: 10.w),
             icon,
              SizedBox(width: 20.w),
              CustomTextTwo(text: label),
              const Spacer(),
              isTrue == true
                  ? const Icon(null)
                  : Icon(Icons.arrow_forward_ios, color: AppColors.primaryColor.withOpacity(0.5), size: 20.h),
              SizedBox(width: 10.w),
            ],
          ),
        ),
      ),
    );
  }
  


}
