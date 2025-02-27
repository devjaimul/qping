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

    // Initial fetch of events (first page)
    controller.fetchEvents(page: 1, limit: 15);

    // ScrollController to listen for when the user reaches the bottom
    ScrollController scrollController = ScrollController();

    // Add listener to scrollController
    scrollController.addListener(() {
      // Check if the user has reached the bottom of the list
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        // Fetch more events if there are more pages
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
            // Show shimmer effect while loading
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
            return ListView.builder(
              controller: scrollController,  // Add scroll controller here
              itemCount: controller.events.length + (controller.isLoading.value ? 1 : 0),  // Add 1 more for loading indicator
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
                  formattedDate = DateFormat('dd MMM yyyy').format(eventDate);  // Format date
                }

                if (event['eventTime'] != null) {
                  formattedTime = event['eventTime'];
                }
                GlobalKey iconKey = GlobalKey();
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
                              child: Row(
                                children: [
                                  CustomTextOne(
                                    text: event['eventName'] ?? 'No name',
                                    fontSize: 16.sp,
                                    textAlign: TextAlign.start,
                                  ),
                                  event['isMyEvent'] == true?Icon(Icons.person,size: 18.h,):const SizedBox.shrink()
                                ],
                              ),
                            ),
                            // Show options only if this is the user's event
                            if (event['isMyEvent'] == true)
                              IconButton(
                                key: iconKey, // Set the key for the IconButton
                                icon: const Icon(Icons.more_vert_outlined),
                                onPressed: () {
                                  _showPopupMenu(context, event, iconKey);  // Pass the key along with event data
                                },
                              ),
                          ],
                        ),
                        CustomTextTwo(
                          text: "Date: $formattedDate",  // Use formatted date
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        CustomTextTwo(
                          text: "Time: $formattedTime",  // Use formatted time
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
            );
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const EventCreateScreen());
        },
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Method to show the popup menu
  void _showPopupMenu(BuildContext context, Map<String, dynamic> event, GlobalKey iconKey) async {
    // Find the position of the icon button using RenderBox
    final RenderBox? renderBox = iconKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final position = renderBox.localToGlobal(Offset.zero);
      final width = renderBox.size.width;

      // Show the menu near the icon button
      await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(position.dx + width, position.dy, 0, 0), // Position right next to the icon
        items: [
          const PopupMenuItem(
            value: 'edit',
            child: Text('Edit'),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: Text('Delete'),
          ),
        ],
        elevation: 8.0,
      ).then((value) {
        if (value == 'edit') {
          _onEditEvent(event);  // Trigger edit functionality
        } else if (value == 'delete') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialog(
                title: "Are you sure you want to delete this event?",
                confirmButtonText: "Delete Event",
                onCancel: () {
                  Get.back();
                },
                onConfirm: () async {
                  await EventController().deleteEvent(event['_id']);
                  Get.back();
                },
              );
            },
          );
        }
      });
    }
  }

  // Edit event function
  void _onEditEvent(Map<String, dynamic> event) {
    // You can navigate to the event update screen or handle editing directly
    Get.to(() => EventCreateScreen(eventData: event, eventId: event['_id']));  // Pass the event data to the create/update screen
  }
}
