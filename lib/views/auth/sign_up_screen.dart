import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:qping/Controller/auth/sign_up_controller.dart';
import 'package:qping/global_widgets/app_logo.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/global_widgets/custom_text_field.dart';
import 'package:qping/routes/app_routes.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:qping/utils/app_icons.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final SignUpController _signUpController = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Center(
            child: Form(
              key: formKey,
              child: Column(
                spacing: 15.h,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50.h),
                  const Center(child: AppLogo()),
                  SizedBox(height: 10.h),

                  // Username Field
                  CustomTextField(
                    controller: _signUpController.userNameController,
                    hintText: "Enter User Name",
                    keyboardType: TextInputType.name,
                    prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Image.asset(
                        AppIcons.person,
                        height: 18.h,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Username cannot be empty";
                      }
                      return null;
                    },
                  ),

                  // Email Field
                  CustomTextField(
                    controller: _signUpController.emailController,
                    hintText: "Enter Email",
                    keyboardType: TextInputType.emailAddress,
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

                  // Phone Field with intl_phone_field
                  IntlPhoneField(
                    decoration: InputDecoration(
                      hintText: 'Phone Number',
                      fillColor: AppColors.textFieldFillColor,
                      filled: true,
                      hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Outfit"
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: const BorderSide(color: AppColors.primaryColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: const BorderSide(color: AppColors.primaryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                    ),
                    initialCountryCode: 'US', // Default country
                    onChanged: (phone) {
                      _signUpController.selectedPhoneNumber = phone.completeNumber; // Store the full phone number
                      // Debugging: Print the full number
                    },
                    onCountryChanged: (country) {
                    },
                    validator: (value) {
                      if (value == null||value=="" ) {
                        return "Phone number cannot be empty";
                      }
                      return null;
                    },
                    showCursor: true, // This ensures the cursor is shown but no unnecessary counters
                    showCountryFlag: true, // Optional: Show the country flag
                    disableLengthCheck: true, // Prevents length enforcement on numbers
                  ),

                  // Password Field
                  CustomTextField(
                    controller: _signUpController.passwordController,
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
                      if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
                          .hasMatch(value)) {
                        return "Password must contain letters, numbers, uppercase, and special characters";
                      }
                      return null;
                    },
                  ),

                  // Confirm Password Field
                  CustomTextField(
                    controller: _signUpController.confirmPasswordController,
                    hintText: "Re-Enter Password",
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
                      if (value != _signUpController.passwordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),

                  // Sign Up Button
                  Obx(
                        () => CustomTextButton(
                      text: _signUpController.isLoading.value ? "Signing Up..." : "Sign Up",
                      onTap: () {
                        if (formKey.currentState?.validate() ?? false) {
                          _signUpController.createAccount();
                        } else {
                        }
                      },
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CustomTextTwo(text: "Already have an account?"),
                      StyleTextButton(
                        text: "Sign In",
                        onTap: () => Get.toNamed(AppRoutes.signInScreen),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
