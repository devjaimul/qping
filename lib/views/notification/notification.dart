import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qping/Controller/notification/notification_controller.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';


class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationController controller = Get.put(NotificationController());

    // Fetch notifications when the screen is initialized
    controller.fetchNotifications();

    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(
          text: 'Notification',
          fontSize: 18.sp,
          color: AppColors.textColor,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Obx(
                    () {
                  // Show shimmer effect while loading
                  if (controller.isLoading.value) {
                    return ListView.builder(
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return ShimmerLoading(
                          width: double.infinity,
                          height: 70.h,
                        );
                      },
                    );
                  }

                  // Display notifications after loading
                  if (controller.notifications.isEmpty) {
                    return const Center(
                      child: CustomTextTwo(text: 'No notifications available'),
                    );
                  }

                  return ListView.builder(
                    itemCount: controller.notifications.length,
                    itemBuilder: (context, index) {
                      var notification = controller.notifications[index];
                      DateTime createdAt = DateTime.parse(notification['createdAt']);
                      String formattedTime = DateFormat.jm().format(createdAt);
                      String formattedDate = DateFormat.yMMMd().format(createdAt);

                      return Column(
                        children: [
                          Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            color: Colors.transparent,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.w),
                              child: ListTile(
                                leading: Container(
                                  height: 40.h,
                                  width: 40.w,
                                  decoration: BoxDecoration(
                                    color:  AppColors.primaryColor.withOpacity(0.4),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.notifications_none,
                                    color:Colors.white,
                                  ),
                                ),
                                title: CustomTextOne(
                                  text: "Notification",
                                  color:  Colors.black,
                                  fontSize: 14.sp,
                                  maxLine: 1,
                                  textOverflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomTextOne(
                                      text: notification['message']??"",
                                      color:  AppColors.textColor,
                                      fontSize: 12.sp,
                                      maxLine: 3,
                                      textOverflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.start,
                                    ),
                                    Row(
                                      children: [
                                        CustomTextOne(
                                          text: formattedDate,
                                          color:  Colors.black,
                                          fontSize: 12.sp,
                                          maxLine: 1,
                                          textOverflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(width: 5.w),
                                        CustomTextOne(
                                          text: formattedTime,
                                          color:  Colors.black,
                                          fontSize: 12.sp,
                                          maxLine: 1,
                                          textOverflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            color: AppColors.primaryColor,
                            thickness: 1,
                            indent: 20.w,
                            endIndent: 20.w,
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom shimmer widget for a more appealing shimmer effect
class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.grey[300]!, Colors.grey[100]!],
            ),
          ),
        ),
      ),
    );
  }
}
