import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/global_widgets/custom_text_field.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:qping/views/Message/message_chat_screen.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> friends = [
    "Alice",
    "Bob",
    "Charlie",
    "David",
    "Eve",
    "Frank",
    "Grace",
    "Hannah"
  ]; // Sample friend list
  List<String> filteredFriends = [];
  List<String> selectedFriends = [];

  @override
  void initState() {
    super.initState();
    filteredFriends = friends; // Initially, show all friends
  }

  void _filterFriends(String query) {
    setState(() {
      filteredFriends = friends
          .where((friend) => friend.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _toggleSelection(String friend) {
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
          text: "Create Group",
          fontSize: 18.sp,
          color: AppColors.textColor,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // Search Bar
            CustomTextField(
              controller: _searchController,
              onChanged: _filterFriends,
              hintText: "Search friends",
              filColor: Colors.transparent,
            ),
            SizedBox(height: 15.h),

            // Friends List
            Expanded(
              child: ListView.builder(
                itemCount: filteredFriends.length,
                itemBuilder: (context, index) {
                  final friend = filteredFriends[index];
                  final isSelected = selectedFriends.contains(friend);
                  return ListTile(
                    leading: CircleAvatar(
                      child: CustomTextTwo(text: friend[0]),
                    ),
                    title: CustomTextTwo(
                      text: (friend),
                      textAlign: TextAlign.start,
                      fontWeight: FontWeight.w600,
                    ),
                    trailing: Checkbox(
                      value: isSelected,
                      onChanged: (value) {
                        _toggleSelection(friend);
                      },
                    ),
                    onTap: () => _toggleSelection(friend),
                  );
                },
              ),
            ),

            // Selected Friends Section
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
                          label: CustomTextTwo(text: (friend)),
                          onDeleted: () {
                            _toggleSelection(friend);
                          },
                        ))
                    .toList(),
              ),
              SizedBox(height: 15.h),
            ],

            // Create Group Button
            CustomTextButton(
                text: "Create Group",
                onTap: selectedFriends.isNotEmpty
                    ? () {
                        print("Group created with: $selectedFriends");
                        _showGroupDialog(context);
                      }
                    : () {},
            color: selectedFriends.isNotEmpty?AppColors.primaryColor:Colors.grey,
            )
          ],
        ),
      ),
    );
  }
  void _showGroupDialog(BuildContext context) {
    final TextEditingController groupNameController = TextEditingController();
    String? groupImage;

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
                  // Group Name Text Field
                  CustomTextField(
                    controller: groupNameController,
                    hintText: "Enter Group Name",
                    filColor: Colors.transparent,
                  ),
                  SizedBox(height: 15.h),

                  // Group Image Selector
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
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                          child: Image.file(File(groupImage!), fit: BoxFit.cover)),
                    ),
                  ),
                  SizedBox(height: 15.h),
                ],
              ),
              actions: [
                // Cancel Button
                SizedBox(
                  width: 100.w,
                  child: CustomTextButton(
                    padding: 0,
                    text: "Cancel",
                    onTap: () {
                    Get.back();
                    },
                    color: Colors.grey,
                  ),
                ),

                // Create Button
                SizedBox(
                  width: 100.w,
                  child: CustomTextButton(
                    padding: 0,
                    text: "Create",
                    onTap: () {
                      if (groupNameController.text.isNotEmpty && groupImage != null) {
                        Get.to(() => MessageChatScreen(isGroup: true));

                        print("Group Name: ${groupNameController.text}");
                        print("Group Image: $groupImage");
                        print("Group Members: $selectedFriends");



                      } else {
                       Get.snackbar("!!!!", "Please provide a group name and image");
                        print("Please provide a group name and image");
                      }
                    },
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }


}
