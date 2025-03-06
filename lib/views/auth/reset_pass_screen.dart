import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qping/Controller/auth/reset_pass_controller.dart';
import 'package:qping/global_widgets/app_logo.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/global_widgets/custom_text_field.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:qping/utils/app_icons.dart';

class ResetPassScreen extends StatelessWidget {
  const ResetPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ResetPassController resetPassController = Get.put(ResetPassController());
    TextEditingController passTEController = TextEditingController();
    TextEditingController rePassTEController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(
          text: "Reset Password",
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
              SizedBox(height: 15.h),
              CustomTextField(
                controller: passTEController,
                hintText: "Enter Password",
                isPassword: true,
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Image.asset(
                    AppIcons.password,
                    height: 18.h,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password cannot be empty";
                  }
                  if (value.length < 8) {
                    return "Password must be at least 8 characters and include uppercase, lowercase, numbers, and special characters (e.g., Abc123@!)";
                  }
                  if (!RegExp(
                      r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
                      .hasMatch(value)) {
                    return "Password must contain letters, numbers, uppercase, and special characters";
                  }
                  return null;
                },
              ),
              CustomTextField(
                controller: rePassTEController,
                hintText: "Re-enter Password",
                isPassword: true,
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Image.asset(
                    AppIcons.password,
                    height: 18.h,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please confirm your password";
                  }
                  if (value != passTEController.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),
              SizedBox(height: 15.h),
              Obx(
                    () => CustomTextButton(
                  text: resetPassController.isLoading.value ? "Resetting..." : "Reset Password",
                  onTap: () {

    if (formKey.currentState?.validate() ?? false) {
                    final password = passTEController.text.trim();
                    final confirmPassword = rePassTEController.text.trim();
                    resetPassController.resetPassword(password, confirmPassword);
                  }},
                ),
              ),
            ],
          ),)
        ),
      ),
    );
  }
}
