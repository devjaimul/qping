
import 'exports.dart';



class AppRoutes{
  static const String splashScreen = "/SplashScreen";
  static const String onboardingScreen = "/OnboardingScreen";
  static const String signInScreen = "/SignInScreen";


  static List<GetPage> get routes => [
   GetPage(name: splashScreen, page: () =>  const SplashScreen()),
   GetPage(name: onboardingScreen, page: () =>  const OnboardingScreen()),
    GetPage(name: signInScreen, page: () =>  const SignInScreen()),

  ];
}