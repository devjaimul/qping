import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qping/Controller/message/profile_about_controller.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/dialog.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:qping/views/Message/media_screen.dart';
import 'package:qping/views/Message/report_screen.dart';

class ProfileAboutScreen extends StatefulWidget {
  final String image;
  final String name;
  final String conversationId;
  const ProfileAboutScreen({super.key, required this.image, required this.name, required this.conversationId});

  @override
  State<ProfileAboutScreen> createState() => _ProfileAboutScreenState();
}

class _ProfileAboutScreenState extends State<ProfileAboutScreen> {
  final ProfileAboutController controller = Get.put(ProfileAboutController());




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50.r,
                backgroundImage: NetworkImage(widget.image),
              ),
              SizedBox(height: 20.h),

              CustomTextOne(
                text: widget.name,
                color: Colors.black,
                fontSize: 20.sp,
                maxLine: 1,
                textOverflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 80.h),

              _buildProfileOption(
                  title: 'Media',
                  onTap: () {
                    Get.to(MediaScreen(conversationId: widget.conversationId,type: "individual",));
                  }),
              Divider(
                color: AppColors.primaryColor.withOpacity(0.3),
              ),

              _buildProfileOption(
                  title: 'Report',
                  onTap: () {
                    Get.to( ReportScreen(receiverId: widget.conversationId,));
                  }),
              Divider(
                color: AppColors.primaryColor.withOpacity(0.3),
              ),

              _buildProfileOption(
                  title: 'Block',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => CustomDialog(
                        title: 'Are you sure you want to block this Account?',
                        confirmButtonText: "Yes, Block",
                        confirmButtonColor: AppColors.primaryColor,
                        onCancel: () {
                          Get.back();
                        },
                        onConfirm: () {
                          Get.back();
                          Get.back();
                        },
                      ),
                    );
                  },
                  color: Colors.red.withOpacity(
                    0.2,
                  ),
                  textColor: Colors.red,
                  noIcon: true),
              Divider(
                color: AppColors.primaryColor.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


Widget _buildProfileOption({
  required String title,
  required VoidCallback onTap,
  Color? color,
  Color? textColor,
  bool? noIcon,
  bool? toogle,
  bool switchValue = false, // Default value for the Switch
  ValueChanged<bool>? onSwitchChanged, // Callback for the Switch
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 7.h),
    child: InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CustomTextOne(
              text: title,
              textAlign: TextAlign.start,
              color: textColor ?? AppColors.textColor,
              fontSize: 14.sp,
            ),
          ),
          if (toogle == true)
            Switch(
              value: switchValue, // Control the Switch value
              onChanged: onSwitchChanged, // Trigger the callback when toggled
              activeColor: AppColors.primaryColor, // Customize active color
              inactiveThumbColor: Colors.grey, // Customize inactive thumb color
            ),
          if (noIcon != true)
            Icon(
              Icons.arrow_forward_ios,
              size: 16.h,
              color: Colors.grey,
            ),
        ],
      ),
    ),
  );
}
