import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:qping/Controller/auth/sign_up_controller.dart';
import 'package:qping/utils/app_colors.dart';

class CustomCountryCode extends StatelessWidget {
  const CustomCountryCode({
    super.key,
    required SignUpController signUpController,
  }) : _signUpController = signUpController;

  final SignUpController _signUpController;

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      decoration: InputDecoration(
        hintText: 'Phone Number',
        fillColor: AppColors.textFieldFillColor,
        filled: true,
        hintStyle: TextStyle(
            color: Colors.black,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            fontFamily: "Outfit"),
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
      countries: countries.map((country) {
        // Clone and modify the country list
        if (country.code == 'PS') {
          return Country(
            code: country.code, // Country code (PS for Palestine)
            dialCode: country.dialCode, // Dial code
            name: 'Palestine 👑', // Custom name
            flag: country.flag, // Use the existing flag
            maxLength: 1, // Use the existing maxLength
            minLength: 1, nameTranslations: {}, // Use the existing minLength

          );
        }else if(country.code == 'IN') {
          return Country(
            code: country.code, // Country code (PS for Palestine)
            dialCode: country.dialCode, // Dial code
            name: 'India (son of Bangladesh)', // Custom name
            flag: country.flag, // Use the existing flag
            maxLength: 1, // Use the existing maxLength
            minLength: 1, nameTranslations: {}, // Use the existing minLength

          );
        }
        return country; // Keep other countries unchanged
      }).where((country) => country.code != 'IL').toList(), // Exclude Israel
      onChanged: (phone) {
        _signUpController.selectedPhoneNumber = phone.completeNumber; // Store the full phone number
      },
      onCountryChanged: (country) {},
      validator: (value) {
        if (value == null || value == "") {
          return "Phone number cannot be empty";
        }
        return null;
      },
      showCursor: true, // This ensures the cursor is shown but no unnecessary counters
      showCountryFlag: true, // Ensure the country flag is displayed
      disableLengthCheck: true, // Prevents length enforcement on numbers
    );
  }
}