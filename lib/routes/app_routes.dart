



import 'exports.dart';



class AppRoutes{
  static const String splashScreen = "/SplashScreen";
  static const String onboardingScreen = "/OnboardingScreen";
  static const String signInScreen = "/SignInScreen";
  static const String signUpScreen = "/SignUpScreen";
  static const String registrationScreen = "/RegistrationScreen";
  static const String uploadPhotosScreen = "/UploadPhotosScreen";


  static List<GetPage> get routes => [
   GetPage(name: splashScreen, page: () =>  const SplashScreen()),
   GetPage(name: onboardingScreen, page: () =>  const OnboardingScreen()),
    GetPage(name: signInScreen, page: () =>  const SignInScreen()),
    GetPage(name: signUpScreen, page: () =>  const SignUpScreen()),
    GetPage(name: registrationScreen, page: () =>  const RegistrationScreen()),
    GetPage(name: uploadPhotosScreen, page: () =>  const UploadPhotosScreen()),

  ];
}