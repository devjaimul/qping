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

  //individual message
  static  String createChat(String userId) => '/chat?participant=$userId';
  static  String getChatList (String page,limit,type,search) => '/chat?page=$page&limit=$limit&type=$type&term=$search';
  static  String chatMsgList (String page,limit,type,conversationId) => '/messages/$conversationId?type=$type&page=$page&limit=$limit';
  static  String acceptChatRequest(String conversationId) => '/chat/$conversationId/accept';





  static  String sendMsg(String chatID) => '/chat/create-message-with-file?chatId=$chatID';

  static  String msgReport(String chatID) => '/user/report-profile?userId=$chatID';






  //group message
  static  String participantsList(String groupId,page,limit) => '/conversation/group/$groupId?page=$page&limit=$limit';
  static  String getParticipantsRole(String groupId) => '/participant/$groupId';
  static  String promoteToModerator(String groupId,userId) => '/conversation/group/$groupId/promote/$userId';
  static  String removeFromParticipantsList(String groupId,userId) => '/conversation/group/$groupId/remove/$userId';
  static const String addParticipantsList = '/users';
  static const String createGroup = '/conversation';
  static  String leaveGroup(String groupId) => '/conversation/group/$groupId/leave';
  static  String addUserToGroup (String userId)=> '/conversation/group/$userId';
  static  String showGroupList (String page,limit,searchValue)=> '/conversation?page=$page&limit=$limit&searchTerm=$searchValue';



}
