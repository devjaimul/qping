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
    RegExp regex = RegExp(r'^(?=.*[0-9])(?=.*[a-zA-Z]).{6,}$');
    return regex.hasMatch(value);
  }
}

enum Status { loading, completed, error, internetError }
