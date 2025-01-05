import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qping/Controller/message/message_chat_controller.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:qping/utils/app_images.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:qping/views/Message/profile_about_screen.dart';
import 'package:qping/views/widgets/poll_widget.dart';

class MessageChatScreen extends StatelessWidget {
 final bool? isGroup;
  MessageChatScreen({super.key, this.isGroup,});

  final MessageChatController _controller = Get.put(MessageChatController());

  final TextEditingController _messageController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(bool fromCamera) async {
    final pickedFile = await _picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    );

    if (pickedFile != null) {
      _controller.addImageMessage(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: InkWell(
          onTap: () {
            Get.to(ProfileAboutScreen());
          },
          child: Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundImage: const AssetImage(AppImages.model),
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextOne(
                    text: "Jenni Miranda",
                    fontSize: 15.sp,
                    color: Colors.black,
                    maxLine: 1,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                  CustomTextTwo(
                    text: 'Active 2 hours ago',
                    fontSize: 12.sp,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(
                    () => ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  itemCount: _controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = _controller.messages[index];
                    return Column(
                      crossAxisAlignment: message['isSentByMe']
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        if (message['type'] == 'text')
                          BubbleNormal(
                            text: message['content'],
                            isSender: message['isSentByMe'],
                            color: message['isSentByMe']
                                ? AppColors.primaryColor
                                : AppColors.buttonSecondColor,
                            tail: true,
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                            ),
                          ),
                        if (message['type'] == 'image')
                          BubbleNormalImage(
                            id: index.toString(),
                            image: Image.file(
                              File(message['content']),
                              fit: BoxFit.cover,
                            ),
                            isSender: message['isSentByMe'],
                            color: Colors.transparent,
                          ),
                        if (message['type'] == 'poll')
                          PollWidget(
                            pollData: message['poll'],
                            onUpdate: (optionIndex, value) {
                              _controller.updatePoll(index, optionIndex, value);
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
                 isGroup==true? IconButton(
                    onPressed: _controller.addPoll, // Trigger poll creation
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: Colors.grey,
                      size: 35.h,
                    ),
                  ):Container(),
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
                      _controller.addTextMessage(_messageController.text);
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




