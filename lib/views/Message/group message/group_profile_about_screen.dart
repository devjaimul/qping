import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qping/Controller/message/group%20message/group_profile_about_screen_controller.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/dialog.dart';
import 'package:qping/services/api_constants.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:qping/views/Message/group%20message/participants_list_screen.dart';
import 'package:qping/views/Message/media_screen.dart';
import 'package:qping/views/Message/report_screen.dart';
import 'package:share_plus/share_plus.dart';

import 'create_group_screen.dart';

class GroupProfileAboutScreen extends StatefulWidget {
  final String groupId;
  final String name;
  final String img;
  const GroupProfileAboutScreen({super.key,required this.groupId, required this.name, required this.img});

  @override
  State<GroupProfileAboutScreen> createState() => _GroupProfileAboutScreenState();
}

class _GroupProfileAboutScreenState extends State<GroupProfileAboutScreen> {
  final GroupProfileAboutController controller = Get.put(GroupProfileAboutController());

  // Link to share
  late final String _shareLink;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _shareLink = "${ApiConstants.imageBaseUrl}/${widget.groupId}";
  }
  // Function to handle sharing
  void _shareLinkToApps() {
    Share.share(_shareLink);
  }

  // Function to copy link to clipboard
  void _copyLinkToClipboard() {
    Clipboard.setData(ClipboardData(text: _shareLink)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Link copied to clipboard!")),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50.r,
                backgroundImage: NetworkImage(widget.img),
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
                    Get.to(()=> MediaScreen(conversationId: widget.groupId,type: "group",));
                  }),
              Divider(
                color: AppColors.primaryColor.withOpacity(0.3),
              ),

              _buildProfileOption(
                  title: 'Members',
                  onTap: () {
                    Get.to(()=> ParticipantsListScreen(groupId: widget.groupId,));
                  }),
              Divider(
                color: AppColors.primaryColor.withOpacity(0.3),
              ),
              _buildProfileOption(
                  title: 'Add Members',
                  onTap: () {
                    Get.to(()=>  CreateGroupScreen(addParticipants: true,groupId:widget.groupId,));
                  }),
              Divider(
                color: AppColors.primaryColor.withOpacity(0.3),
              ),
              _buildProfileOption(
                  title: 'Report',
                  onTap: () {
                    Get.to( ReportScreen(receiverId:widget.groupId,));
                  }),
              Divider(
                color: AppColors.primaryColor.withOpacity(0.3),
              ),
              _buildProfileOption(
                  title: 'Share Group Link',
                  noIcon: true,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(Icons.share),
                              title: Text("Share Link"),
                              onTap: () {
                                _shareLinkToApps();
                                Navigator.pop(context); // Close the bottom sheet
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.copy),
                              title: Text("Copy Link"),
                              onTap: () {
                                _copyLinkToClipboard();
                                Navigator.pop(context); // Close the bottom sheet
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }),
              Divider(
                color: AppColors.primaryColor.withOpacity(0.3),
              ),
              _buildProfileOption(
                  title: 'Leave',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => CustomDialog(
                        title: 'Are you sure you want to leave this group?',
                        confirmButtonText: "Yes, Leave",
                        confirmButtonColor: AppColors.primaryColor,
                        onCancel: () {
                          Get.back();
                        },
                        onConfirm: () {
                          controller.leaveGroup(widget.groupId);
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
              value: switchValue,
              onChanged: onSwitchChanged,
              activeColor: AppColors.primaryColor,
              inactiveThumbColor: Colors.grey,
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
