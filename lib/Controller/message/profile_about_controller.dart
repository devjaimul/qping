import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qping/routes/app_routes.dart';
import 'package:qping/services/api_client.dart';
import 'package:qping/utils/urls.dart';
import 'package:qping/views/Message/describe_complaint_screen.dart';
import 'package:qping/utils/app_colors.dart';

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
                    // Optionally, add functionality for blocking
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

  var isLoading = false.obs;


  Future<void> submitReport(String selectedOption,description,userId) async {
    isLoading.value = true;



    final body = {
      "title": selectedOption,
      "description": description,
      "userID": userId,
    };


    // Call the POST API using your ApiClient.
    final response = await ApiClient.postData(Urls.report, body);
    isLoading.value = false;

    if (response.statusCode == 200) {
      Get.snackbar("Success", "Report submitted successfully");
      Get.offAllNamed(AppRoutes.customNavBar);
    } else {
      Get.snackbar("Error", response.statusText ?? "Failed to submit report");
    }
  }
}
