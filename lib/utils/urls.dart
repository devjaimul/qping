class Urls {

  // Auth Endpoints
  static const String registration = '/user/register';
  static const String login = '/user/login';

  static const String forgetPass = '/user/forget-password';
  static const String changePass = '/user/change-password';

  static const String otpVerify = '/user/verify-otp';
  static  String forgetOtpVerify(String email) =>'/user/verify-forget-otp?email=$email';
  static String otpResend(String email) => '/user/resend?email=$email';

  static String updateUser(String userId) => '/users/$userId';

  static String deleteUser(String userId) => '/user/delete?id=$userId';

  static String resetPass(String email) => '/user/reset-password?email=$email';


 //App data
  static const String privacy = '/privacy';
  static const String terms = '/terms';
  static const String about = '/about';




  //shower Part

  static const String showerRegister = '/shower/register';
  static const String hostAllShowers = '/shower/given-service';
  static  String showerDetails(String showerId) => '/shower/single-service?serviceId=$showerId';
  static  String showerReview(String showerId) => '/review/host-shower-review?showerId=$showerId';
  static  String updateShower(String showerId) => '/shower/update-single-service?serviceId=$showerId';
  static  String isAvailable(String showerId) => '/shower/isAvailable?serviceId=$showerId';
  static  String confirmRequest(String showerId) => '/booking/confirm-booking?bookingId=$showerId';
  static  String cancelRequest(String showerId) => '/booking/cancel-booking?bookingId=$showerId';
  static const String hostBookingRequest= '/booking/status-booking-list?status=request';
  static  String hostBookingConfirm(String date) => "/booking/status-booking-list?status=confirm&date=$date";
  static const String hostSupport = '/user/admin-list';



//guest part
  static  String popularShower(String lat,String lon) => '/shower/popular?lat=$lat&lon=$lon';
  static  String showAllShower(String lat,String lon) => '/shower?lon=$lon&lat=$lat';
  static  String searchShower(String search) => '/shower?search=$search';

  static  String searchShowerPrice(String lowPrice,String highPrice ) => '/shower?lowPrice=$lowPrice&highPrice=$highPrice';

  static  String searchShowerRadius(String radius ) => '/shower?radius=$radius';

  static  String nearMeShower(String lat,String lon) => '/shower/near-me?lon=$lon&lat=$lat';


  static  String weeklyCalender(String date) => '/booking?date=$date&status=confirm';
  static  String applyBooking(String showerId) => '/booking/request?showerId=$showerId';

  static  String bookingType(String type) => '/booking?status=$type';

  static  String review(String showerId,bookingId,time) => '/review/give?showerId=$showerId&time=$time&bookingId=$bookingId';

  static  String bookingDetails(String showerId) => '/booking/details?bookingId=$showerId';

  static  String bookingCancel(String bookingId) => '/booking/cancel-reservation?bookingId=$bookingId';

  static const String balance = '/balance';
  static const String withdrawHistory = '/withdraw/history';
  static const String withdrawRequest ='/withdraw/request';
  static const String guestSupport = '/user/need-support';


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

}
