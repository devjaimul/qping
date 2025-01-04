import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qping/global_widgets/app_logo.dart';
import 'package:qping/global_widgets/custom_pin_code_textfiled.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/routes/app_routes.dart';
import 'package:qping/utils/app_colors.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController otpTEController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(text: "OTP Verification",fontSize: 18.sp,color: AppColors.textColor,),
      ),
      
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(16.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 15.h,
            children: [
              SizedBox(height: 50.h,),
              const AppLogo(),
              SizedBox(height: 20.h,),
          CustomPinCodeTextField(
            textEditingController: otpTEController,
          ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomTextTwo(text: "Didn’t get the code?"),
                  StyleTextButton(text: "Resend OTP", onTap: (){})
                ],
              ),
              CustomTextButton(text: "Verify", onTap: (){
                Get.toNamed(AppRoutes.resetPassScreen);
              })
            ],
          ),
        ),
      ),
    );
  }
}
