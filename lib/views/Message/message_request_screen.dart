import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qping/Controller/message/message_controller.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_field.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:qping/utils/app_images.dart';
import 'package:qping/views/Message/message_request_chat_screen.dart';

class MessageRequestScreen extends StatelessWidget {
  MessageRequestScreen({super.key});

  final MessageController messageController = Get.put(MessageController());

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
                controller: TextEditingController(),
                hintText: "Search",
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


  /// ===================================== _buildChatList ====================================>
  Widget _buildChatList()  {
    return Obx(() {
      return ListView.separated(
        itemCount: messageController.chatData.length,
        separatorBuilder: (_, __) =>
            Divider(color: Colors.grey.shade300, thickness: 1),
        itemBuilder: (context, index) {
          final chat = messageController.chatData[index];
          return  Card(
            color:chat["isUnread"] as bool? AppColors.primaryColor.withOpacity(0.1):Colors.transparent ,
            elevation: 0,
            child: ListTile(
              leading: CircleAvatar(
                radius: 25.r,
                backgroundImage: const AssetImage(AppImages.model),
              ),
              title: CustomTextOne(
                text: chat["name"] as String,
                color: AppColors.textColor,
                fontSize: 15.sp,
                maxLine: 1,
                textAlign: TextAlign.start,
                textOverflow: TextOverflow.ellipsis,
              ),
              subtitle: CustomTextOne(
                text: "hello how are you",
                fontSize: 14,
                color: AppColors.textColor.withOpacity(0.5),
                maxLine: 1,
                textAlign: TextAlign.start,
                textOverflow: TextOverflow.ellipsis,
              ),

              /// ================================> Time ==================================>
              trailing: Column(
                children: [
                  CustomTextOne(
                    text: chat["time"] as String,
                    color: AppColors.textColor.withOpacity(0.8),
                    fontSize: 12.sp,
                    maxLine: 1,
                    textAlign: TextAlign.start,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 10.w),
                  if (chat["isUnread"] as bool)
                    GestureDetector(
                      onTap: () => messageController.markAsRead(index),
                      child: CircleAvatar(
                        radius: 5.r,
                        backgroundColor: AppColors.primaryColor,
                      ),
                    ),
                ],
              ),
              onTap: () {
                Get.to( ()=>MessageRequestChatScreen());
              },
            ),
          );
        },
      );
    });
  }
}