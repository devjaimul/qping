import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qping/Controller/auth/otp_verification_controller.dart';
import 'package:qping/global_widgets/app_logo.dart';
import 'package:qping/global_widgets/custom_pin_code_textfiled.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:flutter/services.dart';

class OtpVerificationScreen extends StatelessWidget {
  final String email;
  final bool? isFormForget;
  const OtpVerificationScreen({super.key, required this.email, this.isFormForget});

  @override
  Widget build(BuildContext context) {
    final OtpVerificationController otpController = Get.put(OtpVerificationController());
    TextEditingController otpTEController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(
          text: "OTP Verification",
          fontSize: 18.sp,
          color: AppColors.textColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 15.h,
            children: [
              SizedBox(height: 50.h),
              const AppLogo(),
              SizedBox(height: 20.h),

              // OTP Text Field with Autofill
              AutofillGroup( // ✅ Autofill enabled
                child: CustomPinCodeTextField(
                  textEditingController: otpTEController,
                ),
              ),

              // Resend OTP Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomTextTwo(text: "Didn’t get the code?"),
                  Obx(
                        () => StyleTextButton(
                      text: otpController.isLoading.value ? "Resending..." : "Resend OTP",
                      onTap: () {
                        otpController.resendOtp(email);
                      },
                    ),
                  ),
                ],
              ),

              // Verify Button
              Obx(
                    () => CustomTextButton(
                  text: otpController.isLoading.value ? "Verifying..." : "Verify",
                  onTap: () {
                    final otp = otpTEController.text.trim();
                    if (otp.isEmpty) {
                      Get.snackbar("Error", "Please enter the OTP code.");
                    } else {
                      otpController.verifyOtp(otp, isFormForget);

                      // ✅ Close autofill context after verification
                      TextInput.finishAutofillContext();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
