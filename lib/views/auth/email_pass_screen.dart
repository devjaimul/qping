import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qping/global_widgets/app_logo.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/global_widgets/custom_text_field.dart';
import 'package:qping/routes/app_routes.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:qping/utils/app_icons.dart';

class EmailPassScreen extends StatelessWidget {
  const EmailPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailTEController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(text: "E-mail Verification",fontSize: 18.sp,color: AppColors.textColor,),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 15.h,
            children: [
              SizedBox(height: 50.h,),
              const AppLogo(),
              SizedBox(height: 20.h,),
              CustomTextField(
                  controller: emailTEController,
                  hintText: "Enter E-mail",
                  isEmail: true,
                  prefixIcon: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 10.w),
                    child: Image.asset(
                      AppIcons.email,
                      height: 18.h,
                    ),
                  )),
              SizedBox(height: 50.h,),
              CustomTextButton(text: "Send Otp", onTap: (){
                Get.toNamed(AppRoutes.otpVerificationScreen);
              }),

            ],
          ),
        ),
      ),
    );
  }
}
