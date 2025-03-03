import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qping/Controller/message/message_controller.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_field.dart';
import 'package:qping/services/api_constants.dart';
import 'package:qping/themes/light_theme.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qping/views/Message/group%20message/group_message_chat_screen.dart';
import 'message_chat_screen.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final MessageController messageController = Get.put(MessageController());
  final TextEditingController searchController = TextEditingController();
  final AppLinks _appLinks = AppLinks();

  @override
  void initState() {
    super.initState();
    // Fetch initial chat list
    messageController.getAcceptChatList(type: 'accepted');
    _requestPermissions();

    // Deep link handling
    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        final String id = uri.pathSegments.last;
        Get.offAll(
          GroupMessageChatScreen(name: "Test", img: "test", groupId: id),
        );
        print("Received URI: $uri");
        print("Extracted ID: $id");
      }
    });
  }

  Future<void> _requestPermissions() async {
    await Permission.notification.request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            children: [
              /// Search Bar
              CustomTextField(
                controller: searchController,
                hintText: "Search",
                validator: (value) => null,
                onChanged: (value) {
                  // Debounce in the controller triggers the API call after 500ms
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

              /// Chat List
              Expanded(child: _buildChatList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatList() {
    return Obx(() {
      // If there's an error
      if (messageController.errorMessage.isNotEmpty) {
        return Center(
          child: CustomTextOne(
            text: "Server Off!!!!!",
            fontSize: 18.sp,
          ),
        );
      }

      // If loading and no data yet
      if (messageController.isLoading.value &&
          messageController.chatData.isEmpty) {
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

      // Possibly add an extra item if more pages exist
      int itemCount = messageController.chatData.length;
      if (messageController.currentPage.value <=
          messageController.totalPages.value) {
        itemCount++;
      }

      // If no chats
      if (itemCount == 0) {
        return Center(
          child: CustomTextOne(
            text: "No Message Available",
            fontSize: 18.sp,
          ),
        );
      }

      // Display chat list
      return ListView.separated(
        itemCount: itemCount,
        separatorBuilder: (_, __) => Divider(
          color: Colors.grey.shade300,
          thickness: 1,
        ),
        itemBuilder: (context, index) {
          // If we hit the extra item, load more
          if (index == messageController.chatData.length) {
            Future.delayed(Duration.zero, () {
              messageController.getAcceptChatList(type: 'accepted');
            });
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16),
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
                    ? NetworkImage(
                    "${ApiConstants.imageBaseUrl}/${chat["profilePicture"]}")
                    : null,
                child: chat["profilePicture"] == null
                    ? CustomTextOne(
                  text: chat["participantName"][0]
                      .toString()
                      .toUpperCase(),
                  color: Colors.white,
                )
                    : null,
              ),
              title: CustomTextOne(
                text: chat["participantName"] ?? "",
                color: AppColors.textColor,
                fontSize: 14.sp,
                maxLine: 1,
                textAlign: TextAlign.start,
                textOverflow: TextOverflow.ellipsis,
              ),
              subtitle: CustomTextOne(
                text: "${chat["lastMessage"] ?? "....."}",
                fontSize: 12.sp,
                color: AppColors.textColor.withOpacity(0.5),
                maxLine: 1,
                textAlign: TextAlign.start,
                textOverflow: TextOverflow.ellipsis,
              ),
              trailing: Column(
                spacing: 10.h,
                children: [
                  // Last message time
                  CustomTextOne(
                    text: chat["lastMessageCreatedAt"] != null
                        ? DateFormat.jm().format(
                      DateTime.parse(chat["lastMessageCreatedAt"])
                          .toLocal(),
                    )
                        : "...",
                    color: AppColors.textColor.withOpacity(0.8),
                    fontSize: 12.sp,
                    maxLine: 1,
                    textAlign: TextAlign.start,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                  // Active status indicator
                  Container(
                    height: 10.h,
                    width: 10.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (chat["isActive"] == true)
                          ? Colors.green
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
              onTap: () {
                Get.to(
                      () => MessageChatScreen(
                    name: chat["participantName"],
                    image:
                    "${ApiConstants.imageBaseUrl}/${chat["profilePicture"]}",
                    conversationId: chat["_id"],
                  ),
                );
              },
            ),
          );
        },
      );
    });
  }
}
