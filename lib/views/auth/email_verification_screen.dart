import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qping/Controller/auth/email_verification_controller.dart';
import 'package:qping/global_widgets/app_logo.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/global_widgets/custom_text_field.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:qping/utils/app_icons.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EmailVerificationController emailController = Get.put(EmailVerificationController());
    TextEditingController emailTEController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(
          text: "E-mail Verification",
          fontSize: 18.sp,
          color: AppColors.textColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Form(
              key: formKey,
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 15.h,
            children: [
              SizedBox(height: 50.h),
              const AppLogo(),
              SizedBox(height: 20.h),
              CustomTextField(
                controller: emailTEController,
                hintText: "Enter E-mail",
                isEmail: true,
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Image.asset(
                    AppIcons.email,
                    height: 18.h,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email cannot be empty";
                  }
                  if (!GetUtils.isEmail(value)) {
                    return "Invalid email address";
                  }
                  return null;
                },
              ),
              SizedBox(height: 50.h),
              Obx(
                    () => CustomTextButton(
                  text: emailController.isLoading.value ? "Sending..." : "Send Otp",
                  onTap: () {
                    if (formKey.currentState?.validate() ?? false) {
                      final email = emailTEController.text.trim();
                      emailController.sendOtp(email); // Call sendOtp method
                    }},
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
