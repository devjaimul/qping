import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qping/Controller/message/group%20message/group_message_chat_screen_controller.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/helpers/prefs_helper.dart';
import 'package:qping/services/api_constants.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:qping/utils/app_constant.dart';
import 'package:qping/utils/app_images.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:qping/views/Message/group%20message/group_profile_about_screen.dart';

class GroupMessageChatScreen extends StatefulWidget {
  final String groupId;
  final String name;
  final String img;
  const GroupMessageChatScreen({
    super.key,
    required this.groupId,
    required this.name,
    required this.img,
  });

  @override
  State<GroupMessageChatScreen> createState() => _GroupMessageChatScreenState();
}

class _GroupMessageChatScreenState extends State<GroupMessageChatScreen> {
  final GroupMessageChatScreenController _controller = Get.put(GroupMessageChatScreenController());
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final ScrollController _scrollController = ScrollController();

  Future<void> getMyIdAndMessages() async {
    String? userId = await PrefsHelper.getString(AppConstants.userId);
    if (userId != null) {
      _controller.setMyUserId(userId);
    }
    // Initial fetch with refresh true
    await _controller.fetchGroupMessages(widget.groupId, refresh: true);
    _controller.initSocketAndJoinGroup(widget.groupId,widget.name);
  }

  Future<void> _pickImage(bool fromCamera) async {
    final pickedFile = await _picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    );
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      // Call the group image sending method
      await _controller.sendImageMessage(widget.groupId, imageFile);
    }
  }


  @override
  void initState() {
    super.initState();
    getMyIdAndMessages();
    _controller.isInInbox.value = false;
    _scrollController.addListener(() {
      // When near the top (since list is reversed) load more messages.
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 50 &&
          !_controller.isLoadingMessages.value) {
        _controller.fetchGroupMessages(widget.groupId);
      }
    });
  }
  @override
  void dispose() {
    super.dispose();
    _controller.isInInbox.value = true;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            Get.to(() => GroupProfileAboutScreen(
              groupId: widget.groupId,
              img: widget.img,
              name: widget.name,
            ));
          },
          child: Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundImage: NetworkImage(widget.img),
              ),
              SizedBox(width: 10.w),
              CustomTextOne(
                text: widget.name,
                fontSize: 15.sp,
                color: Colors.black,
                maxLine: 1,
                textOverflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(
                    () => ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  itemCount: _controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = _controller.messages[index];
                    return Column(
                      crossAxisAlignment: message['isSentByMe']
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        // If not sent by me, show avatar and sender name.
                        if (!message['isSentByMe'])
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 15.r,
                                backgroundImage: message['profilePicture'] != null
                                    ? NetworkImage("${ApiConstants.imageBaseUrl}/${message['profilePicture']}")
                                    : null,
                              ),
                              SizedBox(width: 5.w),
                              CustomTextOne(
                                text: message['senderName'] ?? "Unknown",
                                fontSize: 12.sp,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        if (message['type'] == 'text')
                          BubbleNormal(
                            text: message['content'],
                            isSender: message['isSentByMe'],
                            color: message['isSentByMe'] ? AppColors.primaryColor : AppColors.chatSecondColor,
                            tail: true,
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                            ),
                          ),
                        if (message['type'] == 'image')
                          Builder(
                            builder: (context) {
                              final imageUrl = message['content'].toString().startsWith('http')
                                  ? message['content']
                                  : '${ApiConstants.imageBaseUrl}/${message['content']}';
                              return BubbleNormalImage(
                                id: index.toString(),
                                image: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return SizedBox(
                                      width: 100.w,
                                      height: 100.h,
                                      child: const Center(child: CircularProgressIndicator()),
                                    );
                                  },
                                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                    return Container(
                                      width: 100.w,
                                      height: 100.h,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.error, color: Colors.red),
                                    );
                                  },
                                ),
                                isSender: message['isSentByMe'],
                                color: Colors.transparent,
                              );
                            },
                          ),
                        SizedBox(height: 5.h),
                        Text(
                          message['time'],
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(height: 10.h),
                      ],
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _controller.addPoll, // Poll creation as per your code.
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: Colors.grey,
                      size: 35.h,
                    ),
                  ),
                  InkWell(
                    onTap: () => _pickImage(false),
                    child: Image.asset(
                      AppImages.attach,
                      height: 35.h,
                      width: 35.w,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Flexible(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type Your Message',
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.r),
                          borderSide: BorderSide(
                            color: AppColors.primaryColor.withOpacity(0.5),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 15.w,
                          vertical: 10.h,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _controller.sendMessageToSocket(widget.groupId, _messageController.text, type: 'group');
                      _messageController.clear();
                    },
                    icon: const Icon(Icons.send, color: AppColors.primaryColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
