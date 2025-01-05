//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:qping/global_widgets/custom_text.dart';
// import 'package:qping/utils/app_colors.dart';
//
//
//
// class PackageScreen extends StatefulWidget {
//   const PackageScreen({super.key});
//
//   @override
//   State<PackageScreen> createState() => _PackageScreenState();
// }
//
// class _PackageScreenState extends State<PackageScreen> {
//
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     final sizeH = MediaQuery.sizeOf(context).height;
//     final sizeW = MediaQuery.sizeOf(context).width;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: CustomTextOne(text: 'Subscription Packages',fontSize: 18.sp,color: AppColors.textColor,),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: sizeW * .03),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Image(
//                   image: const AssetImage(""),
//                   height: sizeH * .2),
//
//               SizedBox(height: sizeH * .02),
//               Center(
//                   child: Text(
//                 'Please subscribe to a plan to use all the features',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                     fontSize: sizeH * .018,
//                     color: Colors.white.withOpacity(0.9)),
//               )),
//               SizedBox(height: sizeH * .04),
//               Obx(() {
//                 if (controller.isLoading.value) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (controller.errorMessage.isNotEmpty) {
//                   return Center(child: Text(controller.errorMessage.value, style: const TextStyle(color: Colors.red)));
//                 } else if (controller.subscriptions.isEmpty) {
//                   return const Center(child: Text('No subscriptions available'));
//                 } else {
//                   return Column(
//                     children: [
//                       ...controller.subscriptions.map((subscription) {
//                         return Padding(
//                           padding: EdgeInsets.only(bottom: sizeH * .03),
//                           child: _buildPackageCard(
//                                 () {
//                               paymentController.makePayment(
//                                 price: subscription.price.toStringAsFixed(2),
//                                 subscriptionId: subscription.id,
//                               );
//                             },
//                             subscription.name,
//                             '\$${subscription.price.toStringAsFixed(2)}',
//                             subscription.duration,
//                             backgroundColor: _getBackgroundColor(subscription.name),
//                           ),
//                         );
//                       }),
//                     ],
//                   );
//                 }
//               }),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Helper method to decide background color based on the subscription type
//   Color _getBackgroundColor(String name) {
//     switch (name) {
//       case 'Gold':
//         return Colors.amber;
//       case 'Platinum':
//         return Colors.purple;
//       default:
//         return AppColors.buttonColor;
//     }
//   }
//
//   Widget _buildPackageCard(
//       VoidCallback onTap, String title, String price, String duration,
//       {Color? backgroundColor}) {
//     final sizeH = MediaQuery.sizeOf(context).height;
//     final sizeW = MediaQuery.sizeOf(context).width;
//
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: backgroundColor,
//           borderRadius: BorderRadius.circular(50.r),
//         ),
//         padding: EdgeInsets.symmetric(
//             vertical: sizeH * .013, horizontal: sizeW * .05),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             SizedBox(
//               width: sizeW * .35,
//               height: sizeH * .06,
//               child: Container(
//                 decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.all(Radius.circular(30)),
//                   color: Colors.white,
//                 ),
//                 child: Center(
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(
//                         horizontal: sizeW * .02, vertical: sizeH * .005),
//                     child: HeadingTwo(data: title, color: Colors.black),
//                   ),
//                 ),
//               ),
//             ),
//             Row(
//               children: [
//                 // HeadingTwo(data: "$price /"),
//                 HeadingTwo(
//                     data: duration, color: Colors.white.withOpacity(0.7)),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
