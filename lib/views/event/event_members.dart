import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qping/Controller/event/event_controller.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/services/api_constants.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class EventMembers extends StatelessWidget {
  final String eventName;
  final String eventId;
  const EventMembers({super.key, required this.eventName, required this.eventId});

  @override
  Widget build(BuildContext context) {
    final EventController controller = Get.find<EventController>();

    // Fetch event members after the screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchEventMembers(page: 1, limit: 10, eventId: eventId);
    });

    return Scaffold(
      appBar: AppBar(title: CustomTextOne(text: eventName, fontSize: 18.sp)),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Obx(() {
          if (controller.isLoading.value && controller.eventMembers.isEmpty) {
            return ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 25.r,
                        backgroundColor: Colors.grey,
                      ),
                      title: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 150.w,
                          height: 20.h,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }

          // Show a message when there are no members
          if (controller.eventMembers.isEmpty) {
            return const Center(child: CustomTextTwo(text: 'No members available'));
          }

          // Display members
          return ListView.builder(
            itemCount: controller.eventMembers.length + (controller.isLoading.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (controller.isLoading.value && index == controller.eventMembers.length) {
                return Padding(
                  padding: EdgeInsets.all(16.r),
                  child: const Center(child: CircularProgressIndicator()),
                );
              }

              var member = controller.eventMembers[index];

              return Card(
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25.r,
                      backgroundImage: member['profilePicture'] != null
                          ? CachedNetworkImageProvider("${ApiConstants.imageBaseUrl}/${member['profilePicture']}")
                          : null,
                      backgroundColor: Colors.grey,
                    ),
                    title: CustomTextOne(
                      text: member['name'] ?? 'No name',
                      fontSize: 18.sp,
                      textAlign: TextAlign.start,
                      color: AppColors.textColor,
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

