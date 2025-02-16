import 'package:shared_preferences/shared_preferences.dart';

class AppConstants{
  ///=======================Prefs Helper data===============================>
 static const String role = "userRole";
 static String bearerToken = 'bearerToken';
 static String email = 'email';
 static String isEmailVerified = 'isEmailVerified';
 static String isResetPass = 'isResetPass';
 static String isProfilePicture = 'isProfilePicture';
 static String isProfileID = 'isProfileID';
 static String name = 'name';
 static String image = 'image';
 static String isLogged = 'login';
 static String userId = 'id';


  static RegExp emailValidate = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

 static bool validatePassword(String value) {
  // Regex: Minimum 6 characters, 1 capital letter, 1 number, 1 special character
  RegExp regex = RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$');
  return regex.hasMatch(value);
 }
}

enum Status { loading, completed, error, internetError }


class a{


 static Future<String> getString(String key) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  return preferences.getString(key) ?? "";
 }


 static Future<void> setString(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
 }

}