import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qping/Controller/message/message%20request/message_request_screen_controller.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:chat_bubbles/chat_bubbles.dart';


class MessageRequestChatScreen extends StatefulWidget {
  final String image;
  final String name;
  final String conversationId;
   const MessageRequestChatScreen({
    super.key,
    required this.image,
    required this.name,
    required this.conversationId,
  });

  @override
  State<MessageRequestChatScreen> createState() => _MessageRequestChatScreenState();
}


class _MessageRequestChatScreenState extends State<MessageRequestChatScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.fetchChatMessages(widget.conversationId, refresh: true);
  }
  final MessageRequestController _controller = Get.put(MessageRequestController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundImage: widget.image.isNotEmpty ? NetworkImage(widget.image) : null,
              child: widget.image.isEmpty
                  ? CustomTextTwo(
                text: widget.name.isNotEmpty ? widget.name[0].toUpperCase() : "",
                fontSize: 16.sp,
                color: Colors.white,
              )
                  : null,
            ),
            SizedBox(width: 15.w),
            CustomTextTwo(text: widget.name, fontSize: 16.sp, color: Colors.black),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              // Message Request Notification
              CustomTextOne(
                text: "${widget.name} sent you a message request",
                fontSize: 15.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 20.h),
              // Accept and Reject Buttons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: CustomTextButton(text: "Accept", onTap: () {
                      _controller.acceptRequestChat(widget.conversationId);

                    }, radius: 8)),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: CustomTextButton(
                        text: "Delete",
                        onTap: () {
                          _controller.deleteRequest(widget.conversationId);
                        },
                        color: Colors.transparent,
                        borderColor: AppColors.primaryColor,
                        textColor: AppColors.primaryColor,
                        radius: 8,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              // Messages List with Pagination
              Expanded(
                child: Obx(() {
                  if (_controller.isLoadingMessages.value && _controller.messages.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // Calculate item count. If there are more pages, add one extra item.
                  int itemCount = _controller.messages.length;
                  if (_controller.currentPage.value <= _controller.totalPages.value) {
                    itemCount++;
                  }
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      if (index == _controller.messages.length) {
                        // Trigger load-more when reaching the bottom.
                        Future.delayed(Duration.zero, () {
                          _controller.fetchChatMessages(widget.conversationId);
                        });
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.r),
                            child: const CircularProgressIndicator(),
                          ),
                        );
                      }
                      final message = _controller.messages[index];
                      return Column(
                        crossAxisAlignment: message['isSentByMe'] ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          if (message['type'] == 'text')
                            BubbleNormal(
                              text: message['content'],
                              isSender: message['isSentByMe'],
                              color: message['isSentByMe'] ? AppColors.primaryColor : AppColors.chatSecondColor,
                              tail: true,
                              textStyle: TextStyle(color: Colors.white, fontSize: 16.sp),
                            ),
                          if (message['type'] == 'image')
                            BubbleNormalImage(
                              id: index.toString(),
                              image: Image.network(
                                message['content'],
                                fit: BoxFit.cover,
                              ),
                              isSender: message['isSentByMe'],
                              color: Colors.transparent,
                            ),
                          SizedBox(height: 5.h),
                          Text(
                            message['time'],
                            style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                          ),
                          SizedBox(height: 10.h),
                        ],
                      );
                    },
                  );
                }),
              ),
              SizedBox(height: 20.h),
              CustomTextOne(text: "Accept message request to continue chat with \"${widget.name}\"", fontSize: 14.sp),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
