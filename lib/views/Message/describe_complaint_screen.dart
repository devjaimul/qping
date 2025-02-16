import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/global_widgets/custom_text_field.dart';
import 'package:qping/utils/app_colors.dart';

class DescribeComplaintScreen extends StatefulWidget {
  final String selectedOption;

  const DescribeComplaintScreen({required this.selectedOption, super.key});

  @override
  State<DescribeComplaintScreen> createState() =>
      _DescribeComplaintScreenState();
}

class _DescribeComplaintScreenState extends State<DescribeComplaintScreen> {
  final TextEditingController complaintController = TextEditingController();

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
                  text: 'Help us understanding what’s happening',
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
              const CustomTextTwo(text: 'Describe your Complaint'),
              // Complaint Text Field
              CustomTextField(
                controller: complaintController,
                hintText: "Type Your message...",
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
                    // Handle complaint submission
                    print('Complaint Submitted: ${complaintController.text}');
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