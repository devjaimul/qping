import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qping/Controller/auth/sign_up_controller.dart';
import 'package:qping/global_widgets/app_logo.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/global_widgets/custom_text_field.dart';
import 'package:qping/routes/app_routes.dart';
import 'package:qping/utils/app_icons.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {



  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String selectedCountryCode = '+1';

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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 15.h,
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

                  CustomTextField(
                    controller: _signUpController.phoneController,
                    hintText: "Enter Phone Number",
                    keyboardType: TextInputType.number,
                    prefixIcon: CountryCodePicker(
                      onChanged: (CountryCode countryCode) {
                        // Update the country code in the controller
                        _signUpController.selectedCountryCode = countryCode.dialCode ?? '+1';
                      },
                      initialSelection: 'US',
                      favorite: const ['+1', 'US'],
                      showCountryOnly: false,
                      alignLeft: false,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Phone number cannot be empty";
                      }
                      if (value.length < 8) {
                        return "Invalid phone number";
                      }
                      return null;
                    },
                  ),


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
                        return "Password must be at least 8 characters and include uppercase, lowercase, numbers, and special characters,(eg. Abc123@!).";
                      }
                      if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
                          .hasMatch(value)) {
                        return "Password must contain letters, numbers, Capital Letter and special characters";
                      }
                      return null;
                    },
                  ),

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
