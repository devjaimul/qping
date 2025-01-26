class AppConstants{
  ///=======================Prefs Helper data===============================>
 static const String role = "userRole";
 static String bearerToken = 'bearerToken';
 static String email = 'email';
 static String name = 'name';
 static String image = 'image';
 static String isLogged = 'true';
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
