import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:qping/utils/app_images.dart';
import 'package:chat_bubbles/chat_bubbles.dart';


class MessageRequestChatScreen extends StatelessWidget {
  const MessageRequestChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundImage: const AssetImage(AppImages.model),
            ),
            SizedBox(width: 15.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextOne(
                  text: "Henry Silver",
                  fontSize: 16.sp,
                  color: Colors.black,
                ),
                CustomTextTwo(
                  text: "Active 2 hours ago",
                  fontSize: 13.sp,
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(
                height: 50.h,
              ),
              // Message Request Notification
              CustomTextOne(
                text: "Henry sent you a message request",
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
                    Expanded(
                        child: CustomTextButton(text: "Accept", onTap: () {},radius: 8,)),
                    SizedBox(width: 20.w),
                    Expanded(
                        child: CustomTextButton(
                      text: "Reject",
                      onTap: () {},
                      color: Colors.transparent,
                      borderColor: AppColors.primaryColor,
                      textColor: AppColors.primaryColor,
                            radius: 8
                    ))
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              // Messages Preview
              Expanded(
                child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BubbleNormal(
                          text:
                              "Hey are you there ?? I am henry lets be friends !!",
                          isSender: false,
                          color: AppColors.chatSecondColor,
                          tail: true,
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const Spacer(),
              // Footer
              const CustomTextTwo(text: "Accept message request to continue chat with \"Henry\""),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
