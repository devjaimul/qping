import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qping/Controller/auth/sign_in_controller.dart';
import 'package:qping/global_widgets/app_logo.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/global_widgets/custom_text_field.dart';
import 'package:qping/routes/app_routes.dart';
import 'package:qping/utils/app_icons.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SignInController signInController = Get.put(SignInController());
    TextEditingController emailTEController = TextEditingController();
    TextEditingController passTEController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Form(
            key: formKey,
            child: AutofillGroup(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 15.h,
              children: [
                SizedBox(height: 100.h),
                const AppLogo(),
                SizedBox(height: 15.h),
                CustomTextField(
                  controller: emailTEController,
                  autofillHints: const [AutofillHints.email],
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
                CustomTextField(
                  controller: passTEController,
                  hintText: "Enter Password",
                  autofillHints: const [AutofillHints.password],
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
                    }
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: StyleTextButton(
                    text: "Forgot Password?",
                    onTap: () {
                      Get.toNamed(AppRoutes.emailVerificationScreen);
                    },
                    textDecoration: TextDecoration.none,
                  ),
                ),
                Obx(
                      () => CustomTextButton(
                    text: signInController.isLoading.value ? "Logging in..." : "Let’s Go",
                    onTap: () {
              
                  if (formKey.currentState?.validate() ?? false) {
                      final email = emailTEController.text.trim();
                      final password = passTEController.text.trim();
                      TextInput.finishAutofillContext();
                      signInController.login(email, password);
                    }},
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CustomTextTwo(text: "Don’t have an account?"),
                    StyleTextButton(
                      text: "Sign Up",
                      onTap: () {
                        Get.toNamed(AppRoutes.signUpScreen);
                      },
                    ),
                  ],
                ),
              ],
                        ),
            ),)
        ),
      ),
    );
  }
}
