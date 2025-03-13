
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qping/Controller/message/group%20message/create_group_controller.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/global_widgets/custom_text_field.dart';
import 'package:qping/services/api_constants.dart';
import 'package:qping/utils/app_colors.dart';

import 'group_dialog.dart';

class CreateGroupScreen extends StatefulWidget {
  final bool? addParticipants;
  final String? groupId;

  const CreateGroupScreen({super.key, this.addParticipants, this.groupId});

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
    _controller.getMyFriendsList();
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
          text: widget.addParticipants == true ? "Add Members" : "Create Group",
          fontSize: 18.sp,
          color: AppColors.textColor,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            CustomTextField(
              validator: (value){
                return null;
              },
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


                List<String> userIds = selectedFriends.map((friend) => friend['_id'].toString()).toList();
                _controller.addUserToGroup(selectedUserIds: userIds, groupId: widget.groupId.toString());

              } : () {},
              color: selectedFriends.isNotEmpty ? AppColors.primaryColor : Colors.grey,
            )
                : CustomTextButton(
              text: "Create Group",
              onTap:  () {
                String groupName = "Group Name"; // Get from TextController
                String groupType = "public"; // Replace with actual logic for type
                List<String> userIds = selectedFriends.map((friend) => friend['_id'].toString()).toList();
                showGroupDialog(context, groupName, groupType, userIds);
              } ,
              color:  AppColors.primaryColor,
            )
          ],
        ),
      ),
    );
  }




}
