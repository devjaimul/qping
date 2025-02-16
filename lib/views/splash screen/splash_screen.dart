import 'dart:async'; // Correct import for Timer
import 'package:flutter/material.dart';
import 'package:qping/global_widgets/app_logo.dart';
import 'package:qping/helpers/prefs_helper.dart';
import 'package:qping/routes/app_routes.dart';
import 'package:qping/routes/exports.dart';
import 'package:qping/utils/app_constant.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
_checkUserLogin();
    });
  }
  Future<void> _checkUserLogin() async {
    var token = await PrefsHelper.getString(AppConstants.bearerToken);
    var isLogged = await PrefsHelper.getString(AppConstants.isLogged);
    var isEmailVerified = await PrefsHelper.getString(AppConstants.isEmailVerified);
    var isResetPass = await PrefsHelper.getString(AppConstants.isResetPass);
    var isProfileID = await PrefsHelper.getString(AppConstants.isProfileID);
    var isProfilePicture = await PrefsHelper.getString(AppConstants.isProfilePicture);
    var email = await PrefsHelper.getString(AppConstants.email);

    print("=============token $token ==============isLogged ===========> $isLogged==============isEmailVerified ===========> $isEmailVerified==============isProfileID ===========> $isProfileID==============isProfilePicture ===========> $isProfilePicture==============email ===========> $email");

    if(token.isNotEmpty){

      if(isLogged=="true"){
        Get.offAllNamed(AppRoutes.customNavBar);
      }else if(isResetPass=="true"){
        Get.offAllNamed(AppRoutes.resetPassScreen);
      }
     else if(isEmailVerified=="true"){
        Get.to(OtpVerificationScreen(email: email,));
      }
      else if(isProfileID=="true"){
        Get.offAllNamed(AppRoutes.registrationScreen);
      }
      else if(isProfilePicture=="true"){
        Get.offAllNamed(AppRoutes.uploadPhotosScreen);
      }else{
        Get.offAllNamed(AppRoutes.onboardingScreen);
       // Get.snackbar("!!!!", "Something Went Wrong!!!");
      }

    }
    else{
      Get.offAllNamed(AppRoutes.onboardingScreen);
    }


  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: AppLogo(),
      ),
    );
  }
}
