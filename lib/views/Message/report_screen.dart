import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/utils/app_colors.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(text: 'Report',fontSize: 18.sp,),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(

                maxLines: 10,
                decoration: InputDecoration(
                  fillColor: AppColors.buttonSecondColor,
                  filled: true,
                  hintText: 'Write your report here',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: AppColors.primaryColor)
                  ),
                  contentPadding: EdgeInsets.all(12.w),
                ),
              ),
              SizedBox(height: 60.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomTextButton(text: 'Cancel', onTap: (){},color: AppColors.buttonSecondColor,textColor: Colors.black,),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(child: CustomTextButton(text: 'Submit', onTap: (){},color: Colors.red,),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
