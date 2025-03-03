import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

import 'package:qping/Controller/message/group%20message/group_message_chat_screen_controller.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/helpers/prefs_helper.dart';
import 'package:qping/services/api_constants.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:qping/utils/app_constant.dart';
import 'package:qping/utils/app_images.dart';
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
  final GroupMessageChatScreenController _controller =
  Get.put(GroupMessageChatScreenController());
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.isInInbox.value = false;
    _getMyIdAndMessages();

    // Load more messages when scrolling near top (because reverse=true)
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 50 &&
          !_controller.isLoadingMessages.value) {
        _controller.fetchGroupMessages(widget.groupId);
      }
    });
  }

  @override
  void dispose() {
    _controller.isInInbox.value = true;
    super.dispose();
  }

  Future<void> _getMyIdAndMessages() async {
    String? userId = await PrefsHelper.getString(AppConstants.userId);
    if (userId != null) {
      _controller.setMyUserId(userId);
    }
    // Initial fetch
    await _controller.fetchGroupMessages(widget.groupId, refresh: true);
    _controller.initSocketAndJoinGroup(widget.groupId, widget.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            // Show group profile
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
            // Messages list
            Expanded(
              child: Obx(
                    () => ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  itemCount: _controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = _controller.messages[index];

                    return GestureDetector(
                      onDoubleTap: () => _showReactionPicker(index),
                      child: Column(
                        crossAxisAlignment: message['isSentByMe']
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          // Show avatar + name if not me
                          if (!message['isSentByMe'])
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 15.r,
                                  backgroundImage: (message['profilePicture'] != null)
                                      ? NetworkImage(
                                      "${ApiConstants.imageBaseUrl}/${message['profilePicture']}")
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

                          // Bubble (text or image)
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
                            _buildImageBubble(message, index),

                          // Reaction row
                          if (message['reactions'] != null &&
                              message['reactions'].isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: 4.h),
                              child: _buildReactionRow(
                                message['reactions'] as Map<String, dynamic>,
                              ),
                            ),

                          // Timestamp
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
                      ),
                    );
                  },
                ),
              ),
            ),

            // Input row
            Padding(
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
                      final text = _messageController.text.trim();
                      if (text.isNotEmpty) {
                        _controller.sendMessageToSocket(widget.groupId, text, type: 'group');
                        _messageController.clear();
                      }
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

  /// Show camera/gallery picker
  void _showImageSourceOptions() {
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
      File imageFile = File(pickedFile.path);
      await _controller.sendImageMessage(widget.groupId, imageFile);
    }
  }

  /// Reaction bottom sheet
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

  Widget _reactionIcon(String emoji, String reactionKey, int index) {
    return IconButton(
      icon: Text(emoji, style: TextStyle(fontSize: 24.sp)),
      onPressed: () {
        _controller.reactToGroupMessage(index, reactionKey);
        Get.back();
      },
    );
  }

  /// Build the bubble for an image message
  Widget _buildImageBubble(Map<String, dynamic> message, int index) {
    final content = message['content'] ?? '';
    final imageUrl = content.startsWith('http')
        ? content
        : '${ApiConstants.imageBaseUrl}/$content';

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
  }

  /// Reaction row that shows each reaction + count
  Widget _buildReactionRow(Map<String, dynamic> reactions) {
    List<Widget> reactionWidgets = [];
    reactions.forEach((key, count) {
      if (count is int && count > 0) {
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
                Text('$count', style: TextStyle(fontSize: 14.sp)),
              ],
            ),
          ),
        );
      }
    });

    if (reactionWidgets.isEmpty) {
      return SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: reactionWidgets,
    );
  }

  /// Map reaction keys to emojis
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
        return key;
    }
  }
}
