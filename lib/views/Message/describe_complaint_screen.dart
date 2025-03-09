import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qping/Controller/message/profile_about_controller.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/global_widgets/custom_text_field.dart';
import 'package:qping/helpers/prefs_helper.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:qping/utils/app_constant.dart';

class DescribeComplaintScreen extends StatefulWidget {
  final String selectedOption;
  final String receiverId;

  const DescribeComplaintScreen({required this.selectedOption, super.key, required this.receiverId});

  @override
  State<DescribeComplaintScreen> createState() =>
      _DescribeComplaintScreenState();
}

class _DescribeComplaintScreenState extends State<DescribeComplaintScreen> {
  final TextEditingController complaintController = TextEditingController();
  ProfileAboutController controller =ProfileAboutController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(
          text: 'Report',
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
              // Title and subtitle
              CustomTextOne(
                text: 'Find Support or Report User',
                fontSize: 20.sp,
                color: AppColors.textColor,
              ),
        
              CustomTextTwo(
                  text: 'Help us understand what’s happening',
                  fontSize: 14.sp,
                  color: Colors.black
              ),
        
        
              // Selected option
              Card(
                color: AppColors.textFieldFillColor,
                child: Padding(
                  padding:  EdgeInsets.all(12.h),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.radio_button_checked,
                        color: AppColors.primaryColor,
                      ),
                      SizedBox(width: 5.w,),
                      CustomTextTwo(
                        text: widget.selectedOption,
                        fontSize: 16.sp,
                        color: AppColors.textColor,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),
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
                    print('Complaint Submitted: ${complaintController.text}');
                    controller.submitReport(widget.selectedOption,complaintController.text,widget.receiverId);
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