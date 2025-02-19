import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qping/Controller/message/group%20message/create_group_controller.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/global_widgets/custom_text_field.dart';
import 'package:qping/services/api_constants.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:qping/views/Message/single%20message/message_chat_screen.dart';

class CreateGroupScreen extends StatefulWidget {
  final bool? addParticipants;

  const CreateGroupScreen({super.key, this.addParticipants});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _searchController = TextEditingController();
  final CreateGroupController _controller = Get.put(CreateGroupController());

  List<dynamic> selectedFriends = [];

  @override
  void initState() {
    super.initState();
    _controller.getUsersList();
  }

  void _toggleSelection(dynamic friend) {
    setState(() {
      if (selectedFriends.contains(friend)) {
        selectedFriends.remove(friend);
      } else {
        selectedFriends.add(friend);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(
          text: widget.addParticipants == true ? "Add Participants" : "Create Group",
          fontSize: 18.sp,
          color: AppColors.textColor,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            CustomTextField(
              controller: _searchController,
              onChanged: (query) => _controller.filterUsers(query),
              hintText: "Search friends",
              filColor: Colors.transparent,
            ),
            SizedBox(height: 15.h),
            Expanded(
              child: Obx(() {
                if (_controller.isLoading.value && _controller.usersList.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: _controller.usersList.length,
                  itemBuilder: (context, index) {
                    final friend = _controller.usersList[index];
                    final isSelected = selectedFriends.contains(friend);

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: friend['profilePicture'] != null
                            ? NetworkImage("${ApiConstants.imageBaseUrl}/${friend['profilePicture']}")
                            : null,
                        child: friend['profilePicture'] == null
                            ? CustomTextTwo(text: friend['name'][0].toString().toUpperCase())
                            : null,
                      ),
                      title: CustomTextTwo(
                        text: friend['name'],
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.w600,
                      ),
                      trailing: Checkbox(
                        value: isSelected,
                        onChanged: (value) => _toggleSelection(friend),
                      ),
                      onTap: () => _toggleSelection(friend),
                    );
                  },
                );
              }),
            ),
            if (selectedFriends.isNotEmpty) ...[
              const Divider(),
              const Align(
                alignment: Alignment.centerLeft,
                child: CustomTextTwo(text: "Selected Friends:"),
              ),
              Wrap(
                spacing: 8.w,
                children: selectedFriends
                    .map((friend) => Chip(
                  label: CustomTextTwo(text: friend['name']),
                  onDeleted: () => _toggleSelection(friend),
                ))
                    .toList(),
              ),
              SizedBox(height: 15.h),
            ],
            widget.addParticipants == true
                ? CustomTextButton(
              text: "Add",
              onTap: selectedFriends.isNotEmpty ? () {
                print("Add Friends: $selectedFriends");
              } : () {},
              color: selectedFriends.isNotEmpty ? AppColors.primaryColor : Colors.grey,
            )
                : CustomTextButton(
              text: "Create Group",
              onTap: selectedFriends.isNotEmpty ? () {
                String groupName = "Group Name"; // Get from TextController
                String groupType = "public"; // Replace with actual logic for type
                List<String> userIds = selectedFriends.map((friend) => friend['_id'].toString()).toList();
                _showGroupDialog(context, groupName, groupType, userIds);
              } : () {},
              color: selectedFriends.isNotEmpty ? AppColors.primaryColor : Colors.grey,
            )
          ],
        ),
      ),
    );
  }
  void _showGroupDialog(BuildContext context, String groupName, String groupType, List<dynamic> selectedFriends) {
    final TextEditingController groupNameController = TextEditingController();
    String? groupImage;
    bool _isPublic = true;

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
                  CustomTextField(
                    controller: groupNameController,
                    hintText: "Enter Group Name",
                    filColor: Colors.transparent,
                  ),
                  SizedBox(height: 15.h),
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
                      height: 100.h,
                      width: 100.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: groupImage == null
                          ? Icon(Icons.add_a_photo, size: 40.sp, color: Colors.grey)
                          : ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        child: Image.file(File(groupImage!), fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextTwo(
                        text: "Group Type: ${_isPublic ? "Public" : "Private"}",
                      ),
                      Switch(
                        value: _isPublic,
                        onChanged: (bool value) {
                          setState(() {
                            _isPublic = value;
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
                    SizedBox(width: 15.w),
                    SizedBox(
                      width: 100.w,
                      child:

                      CustomTextButton(
                        text: "Create",
                        onTap:() {
                          String groupName = groupNameController.text;
                          String groupType = _isPublic ? "public" : "private";

                          _controller.createGroup(
                            groupName: groupName,
                            groupType: groupType,
                            selectedUserIds: selectedFriends,
                            groupImage: groupImage != null ? File(groupImage!) : null,
                          );
                        },
                        color: selectedFriends.isNotEmpty ? AppColors.primaryColor : Colors.grey,
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


}
