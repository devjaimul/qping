import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

import 'package:qping/Controller/message/message_chat_controller.dart';
import 'package:qping/Controller/message/message_controller.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/helpers/prefs_helper.dart';
import 'package:qping/services/api_constants.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:qping/utils/app_constant.dart';
import 'package:qping/utils/app_images.dart';
import 'package:qping/views/Message/single%20message/profile_about_screen.dart';

class MessageChatScreen extends StatefulWidget {
  final String image;
  final String name;
  final String conversationId;
  const MessageChatScreen({
    super.key,
    required this.image,
    required this.name,
    required this.conversationId,
  });

  @override
  State<MessageChatScreen> createState() => _MessageChatScreenState();
}

class _MessageChatScreenState extends State<MessageChatScreen> {
  final MessageChatController _chatController = Get.put(MessageChatController());
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final ScrollController _scrollController = ScrollController();
  String? userId;

  @override
  void initState() {
    super.initState();
    _chatController.isInInbox.value = false;
    _getUserIdAndFetchMessages();

    // Add the scroll listener
    _scrollController.addListener(() {
      if (!_chatController.isLoadingMessages.value &&
          _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
        _chatController.fetchChatMessages(widget.conversationId);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _chatController.isInInbox.value = true;
    super.dispose();
  }

  Future<void> _getUserIdAndFetchMessages() async {
    userId = await PrefsHelper.getString(AppConstants.userId);
    if (userId != null) {
      _chatController.setMyUserId(userId!);
      await _chatController.fetchChatMessages(widget.conversationId);
      _chatController.initSocketAndJoinConversation(widget.conversationId, widget.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            // Show profile screen
            Get.to(
              ProfileAboutScreen(
                conversationId: widget.conversationId,
                name: widget.name,
                image: widget.image,
              ),
            );
          },
          child: Obx(() {
            // Check if user is active from the global message list
            final mc = Get.find<MessageController>();
            final conversation = mc.chatData.firstWhere(
                  (c) => c["_id"] == widget.conversationId,
              orElse: () => {},
            );
            bool isActive = conversation["isActive"] ?? false;

            return Row(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundImage: NetworkImage(widget.image),
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextOne(
                      text: widget.name,
                      fontSize: 15.sp,
                      color: Colors.black,
                      maxLine: 1,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 10.h,
                          width: 10.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isActive ? Colors.green : Colors.grey,
                          ),
                        ),
                        SizedBox(width: 5.w),
                        CustomTextOne(
                          text: isActive ? "Active" : "Offline",
                          color: Colors.black54,
                          fontSize: 12.sp,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Chat messages
            Expanded(
              child: Obx(
                    () => ListView.builder(
                      controller: _scrollController,
                  itemCount: _chatController.messages.length,
                  reverse: true,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  itemBuilder: (context, index) {
                    final message = _chatController.messages[index];

                    return GestureDetector(
                      onLongPress:  () => _showReactionPicker(index),
                      child: Column(
                        crossAxisAlignment: message['isSentByMe']
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          // Bubble: text or image

                          if (message['type'] == 'text')
                            BubbleNormal(
                              text: message['content'],
                              isSender: message['isSentByMe'],
                              color: message['isSentByMe']
                                  ? AppColors.primaryColor
                                  : AppColors.chatSecondColor,
                              tail: true,
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                              ),
                            )
                          else if (message['type'] == 'image')
                            BubbleNormalImage(
                              id: index.toString(),
                              image: Image.network(
                                _resolveImageUrl(message['content']),
                                fit: BoxFit.cover,
                              ),
                              isSender: message['isSentByMe'],
                              color: Colors.transparent,
                            ),

                          // Reaction row (if any reaction counts > 0)
                          if (message['reactions'] != null && message['reactions'].isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: 4.h),
                              child: _buildReactionRow(
                                message['reactions'] as Map<String, dynamic>,
                              ),
                            ),

                          // Time
                          SizedBox(height: 5.h),
                          Text(
                            message['time'] ?? '',
                            style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                          ),
                          SizedBox(height: 10.h),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            // Input row
            _buildInputRow(),
          ],
        ),
      ),
    );
  }

  /// Helper to resolve a relative or absolute image URL
  String _resolveImageUrl(String content) {
    return content.startsWith('http')
        ? content
        : '${ApiConstants.imageBaseUrl}/$content';
  }

  /// Reaction row for each message
  Widget _buildReactionRow(Map<String, dynamic> reactions) {
    // Show only those with count > 0
    final reactionWidgets = <Widget>[];
    reactions.forEach((key, value) {
      if (value is int && value > 0) {
        reactionWidgets.add(
          Container(
            margin: EdgeInsets.only(right: 6.w),
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_mapReactionToEmoji(key)),
                SizedBox(width: 3.w),
                Text(
                  '$value',
                  style: TextStyle(fontSize: 14.sp, color: Colors.black),
                ),
              ],
            ),
          ),
        );
      }
    });

    if (reactionWidgets.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: reactionWidgets,
    );
  }

  /// Map your reaction keys (haha, love, etc.) to emojis
  String _mapReactionToEmoji(String key) {
    switch (key) {
      case "haha":
        return "😂";
      case "love":
        return "❤️";
      case "like":
        return "👍";
      case "angry":
        return "😡";
      case "ok":
        return "👌";
      case "cancel":
        return "❌";
      default:
        return key; // fallback to the raw key
    }
  }

  /// Show bottom sheet with reaction icons
  void _showReactionPicker(int index) {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _reactionIcon("😂", "haha", index),
            _reactionIcon("❤️", "love", index),
            _reactionIcon("👍", "like", index),
            _reactionIcon("😡", "angry", index),
            _reactionIcon("👌", "ok", index),
            _reactionIcon("❌", "cancel", index),
          ],
        ),
      ),
    );
  }

  Widget _reactionIcon(String emoji, String key, int index) {
    return IconButton(
      icon: Text(emoji, style: TextStyle(fontSize: 24.sp)),
      onPressed: () {
        _chatController.reactToMessage(index, key);
        Get.back();
      },
    );
  }

  /// The bottom input row with attach & send
  Widget _buildInputRow() {
    return Padding(
      padding: EdgeInsets.all(10.w),
      child: Row(
        children: [
          InkWell(
            onTap: _showImageSourceOptions,
            child: Image.asset(
              AppImages.attach,
              height: 35.h,
              width: 35.w,
            ),
          ),
          SizedBox(width: 5.w),
          Expanded(
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
              final text = _messageController.text.trim();
              if (text.isNotEmpty) {
                _chatController.sendMessageToSocket(widget.conversationId, text);
                _messageController.clear();
              }
            },
            icon: const Icon(Icons.send, color: AppColors.primaryColor),
          ),
        ],
      ),
    );
  }

  /// Show a bottom sheet to pick camera/gallery
  void _showImageSourceOptions() async {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera"),
              onTap: () {
                Get.back();
                _pickImage(true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Gallery"),
              onTap: () {
                Get.back();
                _pickImage(false);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(bool fromCamera) async {
    final pickedFile = await _picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    );
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      await _chatController.sendMessageWithImage(widget.conversationId, file);
    }
  }
}
