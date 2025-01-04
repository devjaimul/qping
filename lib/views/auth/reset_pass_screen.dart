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

class ResetPassScreen extends StatelessWidget {
  const ResetPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController passTEController = TextEditingController();
    TextEditingController rePassTEController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(text: "Reset Password",fontSize: 18.sp,color: AppColors.textColor,),
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
              SizedBox(height: 15.h,),
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
              CustomTextField(
                  controller: rePassTEController,
                  hintText: "Re-enter Password",
                  isPassword: true,
                  prefixIcon: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 10.w),
                    child: Image.asset(
                      AppIcons.password,
                      height: 18.h,
                    ),
                  )),
              SizedBox(height: 15.h,),
              CustomTextButton(text: "Reset Password", onTap: (){

                Get.offAllNamed(AppRoutes.customNavBar);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
