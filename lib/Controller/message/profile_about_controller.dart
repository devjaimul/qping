import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';

class ProfileAboutController extends GetxController {

  var notificationsEnabled = true.obs;
  void toggleNotifications() {
    notificationsEnabled.value = !notificationsEnabled.value;
  }


  void showBlockDialog(BuildContext context) {
    Get.defaultDialog(
      title: 'Block Account',
      titleStyle: TextStyle(
          color: Colors.red,
          fontSize: 20.sp,
          fontWeight: FontWeight.bold),
      titlePadding: EdgeInsets.only(top: 20.h),
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
      backgroundColor: AppColors.textColor,
      radius: 12.r,
      barrierDismissible: false,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10.h),
          Divider(
            color: Colors.grey.withOpacity(0.5),
            thickness: 1.h,
            indent: 20.w,
            endIndent: 20.w,
          ),
          SizedBox(height: 10.h),
          Text(
            'Are you sure you want to block this Account?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textColor,
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColors.primaryColor,
                    backgroundColor: AppColors.textColor,
                    fixedSize: Size(130.5.w, 60.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),

                      side: BorderSide.none,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
              ),
              SizedBox(width: 8.h),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    showCustomDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColors.textColor,
                    backgroundColor: AppColors.primaryColor,
                    fixedSize: Size(130.5.w, 60.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                      side: BorderSide.none,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
                  ),
                  child: Text(
                    'Yes',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Custom Dialog Method
  void showCustomDialog(BuildContext context) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.h,vertical: 20.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dropdown Field
                DropdownButtonFormField<String>(
                  value: 'Fake profile',
                  items: const [
                    DropdownMenuItem(value: 'Fake profile', child: Text('Fake profile')),
                    DropdownMenuItem(value: 'Harassment', child: Text('Harassment')),
                    DropdownMenuItem(value: 'Not one person', child: Text('Not one person')),
                    DropdownMenuItem(value: 'Threatening behavior', child: Text('Threatening behavior')),
                  ],
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  ),
                ),
                SizedBox(height: 12.h),

                // Text Fields
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Details',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 20.h),

                // Submit Button
               // CustomGradientButton(
               //     onTap: () {
               //      Get.back();
               //     },
               //     title: 'Submit')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
