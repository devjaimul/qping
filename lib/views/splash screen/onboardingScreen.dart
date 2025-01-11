import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/routes/app_routes.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:qping/utils/app_images.dart';
import 'package:qping/utils/app_strings.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;
    final sizeW = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          //main image
          Image.asset(
            AppImages.onBoarding,
            fit: BoxFit.contain,
            height: double.infinity,
            width: double.infinity,
          ),
          //dark shadow
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          //main content
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: sizeW * .12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 15.h,
                children: [
                  //app logo
                  Image.asset(
                    AppImages.appLogoWhite,
                    height: sizeH * .2,
                    width: sizeW * .7,
                  ),

                  //title
                  CustomTextTwo(
                    text: "“Connect,Play,Discover”",
                    fontSize: 20.sp,
                    color: AppColors.bgColor,
                  ),
                  SizedBox(
                    height: 100.h,
                  ),
                  //button
                  CustomTextButton(
                    text: "Get Started",
                    onTap: () {

                      Get.offAllNamed(AppRoutes.signUpScreen);
                    },
                  ),

                  //already have account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CustomTextTwo(
                        text: "Already have an account?",
                        color: Colors.white,
                      ),
                      StyleTextButton(
                        text: AppString.signIn,
                        color: AppColors.bgColor,
                        onTap: () {
                           Get.offAllNamed(AppRoutes.signInScreen);
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
