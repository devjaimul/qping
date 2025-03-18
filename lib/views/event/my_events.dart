import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qping/Controller/event/event_controller.dart';
import 'package:qping/Controller/event/my_events_controller.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/global_widgets/dialog.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';

import 'event_create_screen.dart';

class MyEvents extends StatefulWidget {

  MyEvents({super.key});

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  final MyEventController myEventController = Get.put(MyEventController());
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    myEventController.fetchMyEvents(limit: 10,page: 1);
  }
  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (myEventController.currentPage.value < myEventController.totalPages.value && !myEventController.isLoading.value) {
          myEventController.fetchMyEvents(page: myEventController.currentPage.value + 1, limit: 15);
        }
      }
    });

    return Scaffold(
      body: Obx(
            () {
          if (myEventController.isLoading.value && myEventController.events.isEmpty) {
            return Center(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: ListView.builder(
                  itemCount: 5, // simulate loading state for 5 items
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(16),
                      child: Container(
                        height: 120,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            );
          }

          return ListView.builder(
            controller: scrollController,
            itemCount: myEventController.events.length + (myEventController.isLoading.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (myEventController.isLoading.value && index == myEventController.events.length) {
                return Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              var event = myEventController.events[index];

              // Format eventDate and eventTime
              String formattedDate = "No Date";
              String formattedTime = "No Time";
              if (event['createdAt'] != null) {
                DateTime eventDate = DateTime.parse(event['createdAt']);
                formattedDate = "${eventDate.day}-${eventDate.month}-${eventDate.year}";
              }

              if (event['eventTime'] != null) {
                formattedTime = event['eventTime'];
              }
              GlobalKey iconKey = GlobalKey();
              return Padding(
                padding:  EdgeInsets.all(16.h),
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(15.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 5.h,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextOne(
                              text: event['eventName'] ?? 'No name',
                              fontSize: 16,
                              textAlign: TextAlign.start,
                            ),
                            IconButton(
                              key: iconKey,
                              icon: Icon(Icons.more_vert),
                              onPressed: () {
                                _showPopupMenu(context, event, iconKey);
                              },
                            ),
                          ],
                        ),
                        CustomTextTwo(
                          text: "Date: $formattedDate",
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        CustomTextTwo(
                          text: "Time: $formattedTime",
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        CustomTextTwo(
                          text: "Location: ${event['eventLocation'] ?? '--'}",
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
                          onTap: () {},
                          fontSize: 14,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
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
                  await  myEventController.deleteEvent(event['_id']);
                  Get.back();
                },
              );
            },
          );
        }
      });
    }
  }

  void _onEditEvent(Map<String, dynamic> event) {

    Get.to(() => EventCreateScreen(eventData: event, eventId: event['_id']));
  }
}
