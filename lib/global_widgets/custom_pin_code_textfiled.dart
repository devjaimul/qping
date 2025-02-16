import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:qping/utils/app_colors.dart';

class CustomPinCodeTextField extends StatelessWidget {
  const CustomPinCodeTextField({super.key, this.textEditingController, this.validator});

  final TextEditingController? textEditingController;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return Pinput(
      controller: textEditingController,
      length: 6, // OTP length
      autofocus: true, // Auto focus on the OTP field
      keyboardType: TextInputType.number,
      autofillHints: const [AutofillHints.oneTimeCode], // ✅ Auto-fill OTP from SMS/email
      validator: validator,
      defaultPinTheme: PinTheme(
        width: 40.w,
        height: 45.h,
        textStyle:  TextStyle(fontSize: 18.sp, color: Colors.black),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primaryColor),
        ),
      ),
      onCompleted: (pin) {
        print("OTP Entered: $pin"); // ✅ Logs OTP when completed
      },
    );
  }
}
