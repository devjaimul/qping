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
  static  String appData(String type) => '/settings/$type';




//common
  static const String getProfile = '/users/info/me';
  static const String updateProfile = '/users/info/me';

  static  String notification(String page,limit) => '/notifications?page=$page&limit=$limit';
  static const String notificationBadge = '/notification/badge-count';

  static const String sendImage = '/messages';
  static  String getAllMedia(String page,limit,conversationId,type) => '/chat/media/$conversationId?page=$page&limit=$limit&types=$type';
  static const String report = '/report';

  //individual message
  static  String createChat(String userId) => '/chat?participant=$userId';
  static  String getChatList (String page,limit,type,search) => '/chat?page=$page&limit=$limit&type=$type&term=$search';
  static  String chatMsgList (String page,limit,type,conversationId) => '/messages/$conversationId?type=$type&page=$page&limit=$limit';
  static  String acceptChatRequest(String conversationId) => '/chat/$conversationId/accept';


  static  String deleteRequest(String conversationId) => '/chat/$conversationId';


  static  String sendMsg(String chatID) => '/chat/create-message-with-file?chatId=$chatID';

  static  String msgReport(String chatID) => '/user/report-profile?userId=$chatID';






  //group message
  static  String participantsList(String groupId,page,limit) => '/conversation/group/$groupId?page=$page&limit=$limit';
  static  String getParticipantsRole(String groupId) => '/participant/$groupId';
  static  String joinPublicGroup(String groupId) => '/conversation/group/$groupId/join';
  static  String promoteToModerator(String groupId,userId) => '/conversation/group/$groupId/promote/$userId';
  static  String removeFromParticipantsList(String groupId,userId) => '/conversation/group/$groupId/remove/$userId';
  static const String addParticipantsList = '/users';
  static const String createGroup = '/conversation';
  static  String leaveGroup(String groupId) => '/conversation/group/$groupId/leave';
  static  String addUserToGroup (String userId)=> '/conversation/group/$userId';
  static  String showGroupList (String page,limit,searchValue,involved)=> '/conversation?page=$page&limit=$limit&searchTerm=$searchValue&involved=$involved';



  //poll
  static const String groupPoll = '/messages/poll';
  //event
  static  String getEvents (String page,limit)=> '/events?page=$page&limit=$limit';
  static const String createEvents= '/events';
  static  String updateEvents(String eventId)=> '/events/$eventId';
  static  String deleteEvents(String eventId)=> '/events/$eventId';
  static  String joinEvents(String eventId)=> '/events/$eventId';

}
