import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qping/Controller/message/message%20request/message_request_screen_controller.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_field.dart';
import 'package:qping/global_widgets/shimmer_loading.dart';
import 'package:qping/services/api_constants.dart';
import 'package:qping/themes/light_theme.dart';
import 'package:qping/utils/app_colors.dart';

import 'message_request_chat_screen.dart';

class MessageRequestScreen extends StatefulWidget {
  const MessageRequestScreen({super.key});

  @override
  State<MessageRequestScreen> createState() => _MessageRequestScreenState();
}

class _MessageRequestScreenState extends State<MessageRequestScreen> {
  final MessageRequestController messageRequestController = Get.put(MessageRequestController());
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  CustomTextOne(text: "Message Request",fontSize: 18.sp,),),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            children: [
              /// ==================================> Search ====================================>
              CustomTextField(
                controller: searchController,
                hintText: "Search",
                validator: (value) {
                  return null;
                },
                onChanged: (value) {
                  // Just update the searchQuery; the debounce in the controller will trigger the API call.
                  messageRequestController.searchQuery.value = value;
                },
                suffixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Icon(
                    Icons.search,
                    color: AppColors.primaryColor,
                    size: 22.sp,
                  ),
                ),
                borderRadio: 16,
                filColor: Colors.transparent,
                borderColor: Colors.black.withOpacity(0.7),
              ),
              SizedBox(height: 20.h),

              /// ===================================== ChatList ====================================>
              Expanded(child: _buildChatList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatList() {
    return Obx(() {
      // When loading and no data exists, show a list of shimmer loaders
      if (messageRequestController.isLoading.value && messageRequestController.chatData.isEmpty) {
        final shimmerTheme =
        Theme.of(context).extension<ShimmerThemeExtension>()!;
        return ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
            child: Row(
              children: [
                shimmerTheme.shimmerLoader(50.w, 50.w),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerTheme.shimmerLoader(150.w, 15.h),
                    SizedBox(height: 5.h),
                    shimmerTheme.shimmerLoader(100.w, 10.h),
                  ],
                ),
              ],
            ),
          ),
        );
      }

      // Determine the item count and add one extra item if more pages are available
      int itemCount = messageRequestController.chatData.length;
      if (messageRequestController.currentPage.value <= messageRequestController.totalPages.value) {
        itemCount++;
      }

      return itemCount == 0
          ? Center(child: CustomTextOne(text: "No Message Available!!!", fontSize: 18.sp))
          : ListView.separated(
        itemCount: itemCount,
        separatorBuilder: (_, __) => Divider(color: Colors.grey.shade300, thickness: 1),
        itemBuilder: (context, index) {
          // When reaching the extra item, load more data after the current build frame.
          if (index == messageRequestController.chatData.length) {
            Future.delayed(Duration.zero, () {
              messageRequestController.getPendingChatList(type: 'pending');
            });
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: const CircularProgressIndicator(),
              ),
            );
          }
          final chat = messageRequestController.chatData[index];
          // Provide a default value for isUnread if missing
          final bool isUnread = chat["isUnread"] ?? false;
          return Card(
            color: isUnread
                ? AppColors.primaryColor.withOpacity(0.1)
                : Colors.transparent,
            elevation: 0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: chat["profilePicture"] != null
                    ? NetworkImage("${ApiConstants.imageBaseUrl}/${chat["profilePicture"]}")
                    : null,
                child: chat["profilePicture"] == null
                    ? CustomTextTwo(
                    text: chat["participantName"][0].toString().toUpperCase())
                    : null,
              ),
              title: CustomTextOne(
                text: chat["participantName"] as String,
                color: AppColors.textColor,
                fontSize: 14.sp,
                maxLine: 1,
                textAlign: TextAlign.start,
                textOverflow: TextOverflow.ellipsis,
              ),
              subtitle: CustomTextOne(
                text: chat["lastMessage"] ?? "..........................................",
                fontSize: 12.sp,
                color: AppColors.textColor.withOpacity(0.5),
                maxLine: 1,
                textAlign: TextAlign.start,
                textOverflow: TextOverflow.ellipsis,
              ),
              trailing: Column(
                children: [
                  CustomTextOne(
                    text: chat["lastMessageCreatedAt"] != null
                        ? DateFormat.jm().format(
                        DateTime.parse(chat["lastMessageCreatedAt"].toString()).toLocal())
                        : "No Date",
                    color: AppColors.textColor.withOpacity(0.8),
                    fontSize: 12.sp,
                    maxLine: 1,
                    textAlign: TextAlign.start,
                    textOverflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 10.w),
                  if (isUnread)
                    GestureDetector(
                      onTap: () => messageRequestController.markAsRead(index),
                      child: CircleAvatar(
                        radius: 5.r,
                        backgroundColor: AppColors.primaryColor,
                      ),
                    ),
                ],
              ),
              onTap: () {
                Get.to(() =>  MessageRequestChatScreen(name: chat["participantName"], image: "${ApiConstants.imageBaseUrl}/${chat["profilePicture"]}", conversationId: chat["_id"],));
              },
            ),
          );
        },
      );
    });
  }
}