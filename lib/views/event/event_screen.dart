import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/global_widgets/dialog.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:qping/views/event/event_create_screen.dart';
import 'package:readmore/readmore.dart';
import 'package:intl/intl.dart';  // For date and time formatting
import 'package:qping/Controller/event/event_controller.dart';
import 'package:shimmer/shimmer.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EventController controller = Get.put(EventController());


    controller.fetchEvents(page: 1, limit: 10);

    ScrollController scrollController = ScrollController();

    scrollController.addListener(() {

      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {

        if (controller.currentPage.value < controller.totalPages.value && !controller.isLoading.value) {
          controller.fetchEvents(page: controller.currentPage.value + 1, limit: 15);
        }
      }
    });

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.fetchEvents(page: 1, limit: 10);
          },
          child: Obx(() {

            if (controller.isLoading.value && controller.events.isEmpty) {
              return ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(10.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: double.infinity,
                              height: 20.h,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 150.w,
                              height: 20.h,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            // Show a message when there are no events
            if (controller.events.isEmpty) {
              return const Center(
                child: CustomTextTwo(text: 'No events available'),
              );
            }

            // Display events
            return Column(
              children: [
                /// Title Row
                Row(
                  children: [
                    // Example emoji or icon
                    Text(
                      "✨",
                      style: TextStyle(fontSize: 20.sp),
                    ),
                    SizedBox(width: 8.w),
                    CustomTextOne(
                      text: "Events",
                      fontSize: 18.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                SizedBox(height: 10.h,),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: controller.events.length + (controller.isLoading.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (controller.isLoading.value && index == controller.events.length) {
                        return Padding(
                          padding: EdgeInsets.all(16.r),
                          child: const Center(child: CircularProgressIndicator()),
                        );
                      }

                      var event = controller.events[index];

                      // Format eventDate and eventTime
                      String formattedDate = "No Date";
                      String formattedTime = "No Time";
                      if (event['eventDate'] != null) {
                        DateTime eventDate = DateTime.parse(event['eventDate']);
                        formattedDate = DateFormat('dd MMM yyyy').format(eventDate);
                      }

                      if (event['eventTime'] != null) {
                        formattedTime = event['eventTime'];
                      }
                      return Card(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(15.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 5.h,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child:  CustomTextOne(
                                      text: event['eventName'] ?? 'No name',
                                      fontSize: 16.sp,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ),
                              CustomTextTwo(
                                text: "Date: $formattedDate",
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              CustomTextTwo(
                                text: "Time: $formattedTime",
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              CustomTextTwo(
                                text: "Location: ${event['eventLocation'] ?? '--'}",
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              ReadMoreText(
                                "Description: ${event['eventDescription'] ?? 'No description'}",
                                trimLines: 3,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: "show more",
                                moreStyle: const TextStyle(color: AppColors.primaryColor),
                                style: TextStyle(color: AppColors.textColor, fontSize: 14.sp),
                                trimExpandedText: "show less",
                                colorClickableText: AppColors.primaryColor,
                              ),
                              CustomTextButton(
                                text: "Join",
                                onTap: () {
                                  controller.joinEvent(event['_id']);
                                },
                                fontSize: 14.sp,
                                padding: 4.r,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }


}
