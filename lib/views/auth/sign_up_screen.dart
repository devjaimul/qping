import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qping/global_widgets/app_logo.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/global_widgets/custom_text_field.dart';
import 'package:qping/routes/app_routes.dart';
import 'package:qping/utils/app_icons.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameTEController = TextEditingController();
    TextEditingController emailTEController = TextEditingController();
    TextEditingController passTEController = TextEditingController();
    TextEditingController confirmPassTEController = TextEditingController();
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 15.h,
            children: [
              SizedBox(height: 100.h,),
              const AppLogo(),
              SizedBox(height: 15.h,),
              CustomTextField(
                keyboardType: TextInputType.name,
                  controller: nameTEController,
                  hintText: "Name",
                  prefixIcon: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 10.w),
                    child: Image.asset(
                      AppIcons.person,
                      height: 18.h,
                    ),
                  ),
              borderRadio: 12.r,
              ),
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
                  ),
              borderRadio: 12.r,
              ),
              CustomTextField(
                  controller: passTEController,
                  hintText: "Enter Password",
                  isPassword: true,
                  borderRadio: 12.r,
                  prefixIcon: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 10.w),
                    child: Image.asset(
                      AppIcons.password,
                      height: 18.h,
                    ),
                  )),
              CustomTextField(
                  controller: confirmPassTEController,
                  hintText: "Re-Enter Password",
                  isPassword: true,
                  borderRadio: 12.r,
                  prefixIcon: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 10.w),
                    child: Image.asset(
                      AppIcons.password,
                      height: 18.h,
                    ),
                  )),
              CustomTextButton(text: "Sign Up", onTap: (){     Get.toNamed(AppRoutes.registrationScreen);}),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomTextTwo(text: "Already have an account?"),
                  StyleTextButton(
                    text: "Sign In",
                    onTap: () {
                      Get.toNamed(AppRoutes.signInScreen);

                    },
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
