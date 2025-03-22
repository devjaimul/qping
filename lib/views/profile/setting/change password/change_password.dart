import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qping/Controller/auth/reset_pass_controller.dart';
import 'package:qping/global_widgets/app_logo.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/global_widgets/custom_text_field.dart';
import 'package:qping/routes/app_routes.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:qping/utils/app_icons.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController oldPassTEController = TextEditingController();
    final TextEditingController passTEController = TextEditingController();
    final TextEditingController rePassTEController = TextEditingController();
    final ResetPassController controller = Get.put(ResetPassController());

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(
          text: "Change Password",
          fontSize: 18.sp,
          color: AppColors.textColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 15.h,
              children: [
                SizedBox(height: 50.h),
                const AppLogo(),
                SizedBox(height: 15.h),
                // Old Password Field
                CustomTextField(
                  controller: oldPassTEController,
                  hintText: "Enter Old Password",
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
                      return "Old Password cannot be empty";
                    }
                    return null;
                  },
                  borderRadio: 12.r,
                ),
                // New Password Field
                CustomTextField(
                  controller: passTEController,
                  hintText: "Enter New Password",
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
                      return "Password must be at least 8 characters";
                    }
                    if (!RegExp(r'^(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$').hasMatch(value)) {
                      return "Password must contain at least 1 special character";
                    }
                    return null;
                  },
                  borderRadio: 12.r,
                ),
                // Re-enter New Password Field
                CustomTextField(
                  controller: rePassTEController,
                  hintText: "Re-Enter New Password",
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
                      return "Please re-enter the new password";
                    }
                    if (value != passTEController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                  borderRadio: 12.r,
                ),
                SizedBox(height: 15.h),
                Obx(
                      () => CustomTextButton(
                    text: controller.isLoading.value
                        ? "Changing..."
                        : "Change Password",
                    onTap: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        // Call the API via the controller to change the password.
                        controller.changePassword(
                          oldPassTEController.text.trim(),
                          passTEController.text.trim(),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
