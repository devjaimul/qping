import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
    TextEditingController emailTEController = TextEditingController();
    TextEditingController passTEController = TextEditingController();
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
              CustomTextField(
                  controller: passTEController,
                  hintText: "Enter Password",
                  isPassword: true,
                  prefixIcon: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 10.w),
                    child: Image.asset(
                      AppIcons.password,
                      height: 18.h,
                    ),
                  )),
              Align(
                  alignment: Alignment.centerRight,
                  child: StyleTextButton(text: "Forget Password?", onTap: (){})),
              CustomTextButton(text: "Let’s Go", onTap: (){}),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 CustomTextTwo(text: "Don’t have an account?"),
                  StyleTextButton(
                    text: "Sign Up",
                    onTap: () {

                    //  Get.offAllNamed(AppRoutes.singUpScreen)

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
