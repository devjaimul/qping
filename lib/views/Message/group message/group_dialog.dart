import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qping/Controller/message/group%20message/create_group_controller.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/global_widgets/custom_text_field.dart';
import 'package:qping/utils/app_colors.dart';

void showGroupDialog(BuildContext context, String groupName, String groupType, List<dynamic> selectedFriends) {
  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController groupDescriptionController = TextEditingController();
  final CreateGroupController controller = Get.put(CreateGroupController());
  String? groupImage;
  bool isPublic = true;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: CustomTextOne(
              text: "Create Group",
              fontSize: 18.sp,
              color: AppColors.textColor,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () async {
                    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      setState(() {
                        groupImage = pickedFile.path;
                      });
                    }
                  },
                  child: Container(
                    height: 80.h,
                    width: 80.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: groupImage == null
                        ? Icon(Icons.add_a_photo, size: 40.sp, color: Colors.grey)
                        : ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: Image.file(File(groupImage!), fit: BoxFit.cover),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                CustomTextField(
                  contentPaddingVertical: 2.h,
                  controller: groupNameController,
                  hintText: "Enter Group Name",
                  filColor: Colors.transparent,
                ),
                SizedBox(height: 5.h),
                CustomTextField(

                  contentPaddingVertical: 2.h,
                  controller: groupDescriptionController,
                  hintText: "Enter Group Description",
                  filColor: Colors.transparent,
                ),
                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextTwo(
                      text: "Group Type: ${isPublic ? "Public" : "Private"}",
                    ),
                    Switch(
                      value: isPublic,
                      onChanged: (bool value) {
                        setState(() {
                          isPublic = value;
                        });
                      },
                      activeColor: AppColors.primaryColor,
                      inactiveThumbColor: Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              Row(
                children: [
                  SizedBox(
                    width: 100.w,
                    child: CustomTextButton(
                      text: "Cancel",
                      padding: 0,
                      onTap: () {
                        Get.back();
                      },
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  SizedBox(
                      width: 100.w,
                      child:

                      CustomTextButton(
                        text: "Create",
                        padding: 0,
                        onTap:() {
                          String groupName = groupNameController.text;
                          String groupDescription = groupDescriptionController.text;
                          String groupType = isPublic ? "public" : "private";

                          controller.createGroup(
                            groupName: groupName,
                            groupDescription:groupDescription,
                            groupType: groupType,
                            selectedUserIds: selectedFriends,
                            groupImage: groupImage != null ? File(groupImage!) : null,
                          );
                        },
                        color:  AppColors.primaryColor,
                      )

                  ),
                ],
              )
            ],
          );
        },
      );
    },
  );
}