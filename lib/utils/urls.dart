class Urls {

  // Auth Endpoints
  static const String signUp = '/auth/register';
  static const String otpVerify = '/auth/otp/verify';
  static const String otpResend = '/auth/otp/resend';
  static const String registration = '/profiles';
  static const String profilePicture = '/users/profile-picture';
  static const String login = '/auth/login';
  static const String emailVerify = '/auth/otp/send-for-forgot-password';
  static const String forgetPass = '/auth/password/forgot';
  static const String changePass = '/user/change-password';
  static String updateUser(String userId) => '/users/$userId';
  static String deleteUser(String userId) => '/user/delete?id=$userId';
  static String resetPass(String email) => '/user/reset-password?email=$email';


 //App data
  static const String privacy = '/privacy';
  static const String terms = '/terms';
  static const String about = '/about';




//common
  static const String getProfile = '/user/my-profile';
  static const String updateProfile = '/user/profile-update';
  static const String verifyProfile = '/user/verify-profile-request';
  static const String notification = '/notification';
  static const String notificationBadge = '/notification/badge-count';
  static const String payments = '/purchase';
  static const String hostFeatureMode = '/user/guest-mode';

//message
  static const String chatList = '/chat/list';

  static  String chatMsgList(String chatID) => '/chat/message?chatId=$chatID';

  static  String sendMsg(String chatID) => '/chat/create-message-with-file?chatId=$chatID';

  static  String msgReport(String chatID) => '/user/report-profile?userId=$chatID';

  static  String msgBlock(String userId) => '/user/block-user?blockUserId=$userId';

  static  String msgUnBlock(String userId) => '/user/unblock-user?blockUserId=$userId';

  static  String createChat(String chatID) => '/chat/create?receiverId=$chatID';


  //group message
  static  String participantsList(String groupId) => '/conversation/group/$groupId';
  static  String removeFromParticipantsList(String userId) => '/conversation/$userId';
  static const String addParticipantsList = '/users';
  static const String createGroup = '/conversation';
}
