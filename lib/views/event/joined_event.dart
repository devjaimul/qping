import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:qping/Controller/event/event_controller.dart';
import 'package:get/get.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/utils/app_colors.dart' show AppColors;
import 'package:readmore/readmore.dart' show ReadMoreText, TrimMode;
import 'package:shimmer/shimmer.dart';

import 'event_members.dart';

class JoinEventScreen extends StatefulWidget {
  const JoinEventScreen({super.key});

  @override
  State<JoinEventScreen> createState() => _JoinEventScreenState();
}

class _JoinEventScreenState extends State<JoinEventScreen> {
  final EventController controller = Get.find<EventController>();

  @override
  void initState() {
    super.initState();
    // Fetch the joined events after the first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchJoinedEvents(page: 1, limit: 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (controller.currentPage.value < controller.totalPages.value && !controller.isLoading.value) {
          controller.fetchJoinedEvents(page: controller.currentPage.value + 1, limit: 15);
        }
      }
    });

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.fetchJoinedEvents(page: 1, limit: 10);
          },
          child: Obx(() {
            if (controller.isLoading.value && controller.joinedEvents.isEmpty) {
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
            if (controller.joinedEvents.isEmpty) {
              return  Center(
                child: CustomTextOne(text: 'No Events Available',fontSize: 18.sp,),
              );
            }

            // Display events
            return Column(
              children: [
                Row(
                  children: [
                    Text("✨", style: TextStyle(fontSize: 20.sp)),
                    SizedBox(width: 8.w),
                    CustomTextOne(
                      text: "Joined Events",
                      fontSize: 18.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: controller.joinedEvents.length + (controller.isLoading.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (controller.isLoading.value && index == controller.joinedEvents.length) {
                        return Padding(
                          padding: EdgeInsets.all(16.r),
                          child: const Center(child: CircularProgressIndicator()),
                        );
                      }

                      var event = controller.joinedEvents[index];

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
                                    child: CustomTextOne(
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
                              CustomTextTwo(
                                text: "Joined: ${event['joined'] ?? '--'}",
                                fontSize: 15,
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
                                text: "See Members",
                                onTap: () {
                                  Get.to(()=>EventMembers(eventName: event['eventName'], eventId: event['eventId']));
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


