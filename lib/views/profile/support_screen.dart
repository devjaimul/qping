import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qping/Controller/message/profile_about_controller.dart';
import 'package:qping/Controller/profile/profile_controller.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/global_widgets/custom_text_field.dart';
import 'package:qping/helpers/prefs_helper.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:qping/utils/app_constant.dart';

class SupportScreen extends StatefulWidget {

  const SupportScreen({super.key,});

  @override
  State<SupportScreen> createState() =>
      _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final TextEditingController complaintController = TextEditingController();
  ProfileController controller =ProfileController();
  String? userId;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserId();
  }

  getUserId()async{
     userId = await PrefsHelper.getString(AppConstants.userId);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(
          text: 'Support',
          fontSize: 18.sp,
          color: AppColors.textColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            spacing: 10.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              CustomTextTwo(
                  text: 'Help us understand what’s happening',
                  fontSize: 14.sp,
                  color: Colors.black
              ),


              const CustomTextTwo(text: 'Describe the issue'),
              // Complaint Text Field
              CustomTextField(
                controller: complaintController,
                hintText: "Type your message...",
                maxLine: 5,
                borderRadio: 12,
                filColor: Colors.transparent,
              ),
              SizedBox(height: 20.h),

              // Submit Button
              CustomTextButton(
                text: "Submit",
                onTap: () {
                  if (complaintController.text.isNotEmpty) {
controller.submitSupport(complaintController.text, userId);
                    Get.back();
                  } else {
                    // Handle empty complaint
                    Get.snackbar("!!!!!", 'Please describe your complaint');
                  }
                },
                color: AppColors.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}