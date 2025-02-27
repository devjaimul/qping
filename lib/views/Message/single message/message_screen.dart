import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qping/Controller/message/message_chat_controller.dart';
import 'package:qping/Controller/message/message_controller.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_field.dart';
import 'package:qping/services/api_constants.dart';
import 'package:qping/themes/light_theme.dart';
import 'package:qping/utils/app_colors.dart';

import 'message_chat_screen.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final MessageController messageController = Get.put(MessageController());
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    messageController.getAcceptChatList(type: 'accepted');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  messageController.searchQuery.value = value;
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
      // Check if there's an error
      if (messageController.errorMessage.isNotEmpty) {
        return Center(
          child: CustomTextOne(
            text: "Server Off!!!!!",
            fontSize: 18.sp,
          ),
        );
      }

      // Show loader if still loading and no data available yet.
      if (messageController.isLoading.value && messageController.chatData.isEmpty) {
        final shimmerTheme = Theme.of(context).extension<ShimmerThemeExtension>()!;
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
      int itemCount = messageController.chatData.length;
      if (messageController.currentPage.value <= messageController.totalPages.value) {
        itemCount++;
      }

      return itemCount == 0
          ? Center(
        child: CustomTextOne(
          text: "No Message Available!!!",
          fontSize: 18.sp,
        ),
      )
          : ListView.separated(
        itemCount: itemCount,
        separatorBuilder: (_, __) => Divider(color: Colors.grey.shade300, thickness: 1),
        itemBuilder: (context, index) {
          // When reaching the extra item, load more data after the current build frame.
          if (index == messageController.chatData.length) {
            Future.delayed(Duration.zero, () {
              messageController.getAcceptChatList(type: 'accepted');
            });
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: const CircularProgressIndicator(),
              ),
            );
          }
          final chat = messageController.chatData[index];
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
              // Show lastMessage
              subtitle: CustomTextOne(
                text: "${chat["lastMessage"] ?? "....."}  ",
                fontSize: 12.sp,
                color: AppColors.textColor.withOpacity(0.5),
                maxLine: 1,
                textAlign: TextAlign.start,
                textOverflow: TextOverflow.ellipsis,
              ),
              trailing: Column(
                spacing: 10.h,
                children: [
                  CustomTextOne(
                    text: chat["lastMessageCreatedAt"] != null
                        ? DateFormat.jm().format(
                        DateTime.parse(chat["lastMessageCreatedAt"].toString()).toLocal())
                        : "...",
                    color: AppColors.textColor.withOpacity(0.8),
                    fontSize: 12.sp,
                    maxLine: 1,
                    textAlign: TextAlign.start,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                  // Show active status indicator based on each chat's isActive field
                  Container(
                    height: 10.h,
                    width: 10.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (chat["isActive"] == true) ? Colors.green : Colors.grey,
                    ),
                  ),
                  // SizedBox(height: 10.w),
                  // if (isUnread)
                  //   GestureDetector(
                  //     onTap: () => messageController.markAsRead(index),
                  //     child: CircleAvatar(
                  //       radius: 5.r,
                  //       backgroundColor: AppColors.primaryColor,
                  //     ),
                  //   ),
                ],
              ),
              onTap: () {
                Get.to(() => MessageChatScreen(
                  name: chat["participantName"],
                  image: "${ApiConstants.imageBaseUrl}/${chat["profilePicture"]}",
                  conversationId: chat["_id"],
                ));
              },
            ),
          );
        },
      );
    });
  }
}
