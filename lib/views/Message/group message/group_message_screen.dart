import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qping/Controller/message/group%20message/group_message_screen_controller.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_field.dart';
import 'package:qping/services/api_constants.dart';
import 'package:qping/themes/light_theme.dart';
import 'package:qping/utils/app_colors.dart';
import 'create_group_screen.dart';
import 'group_message_chat_screen.dart';

class GroupMessageScreen extends StatefulWidget {
  GroupMessageScreen({super.key});

  @override
  State<GroupMessageScreen> createState() => _GroupMessageScreenState();
}

class _GroupMessageScreenState extends State<GroupMessageScreen> {
  final GroupMessageController groupMessageController =
      Get.put(GroupMessageController());

  final ScrollController scrollController = ScrollController();

  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    groupMessageController.fetchGroupList();
  }

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent &&
          !groupMessageController.isLoading.value) {
        groupMessageController.fetchGroupList();
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            children: [
              /// ========================== Search Bar ==========================
              CustomTextField(
                validator: (value) {
                  return null;
                },
                controller: searchController,
                hintText: "Search Groups",
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
                onChanged: (value) {
                  groupMessageController.searchGroups(value);
                },
              ),
              SizedBox(height: 20.h),

              Expanded(child: _buildChatList(context)),

              Obx(() {
                final shimmerTheme =
                    Theme.of(context).extension<ShimmerThemeExtension>()!;
                return groupMessageController.isLoading.value
                    ? Padding(
                        padding: EdgeInsets.all(10.r),
                        child: shimmerTheme.shimmerLoader(
                            200.w, 20.h), // Shimmer Effect
                      )
                    : const SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const CreateGroupScreen()),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// ========================== Build Chat List ==========================
  Widget _buildChatList(BuildContext context) {
    return Obx(() {
      if (groupMessageController.isLoading.value) {
        final shimmerTheme =
            Theme.of(context).extension<ShimmerThemeExtension>()!;
        return ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
            child: Row(
              children: [
                shimmerTheme.shimmerLoader(50.w, 50.w),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerTheme.shimmerLoader(150.w, 15.h),
                    SizedBox(height: 5.h),
                    shimmerTheme.shimmerLoader(100.w, 10.h),
                  ],
                ),
              ],
            ),
          ),
        );
      }

      if (groupMessageController.chatData.isEmpty &&
          !groupMessageController.isLoading.value) {
        return Center(
          child: searchController.text.isNotEmpty
              ? CustomTextOne(
                  text: "No matching groups found!!!", fontSize: 16.sp)
              : CustomTextOne(text: "No groups found", fontSize: 16.sp),
        );
      }

      return ListView.separated(
        controller: scrollController,
        itemCount: groupMessageController.chatData.length,
        separatorBuilder: (_, __) =>
            Divider(color: Colors.grey.shade300, thickness: 1),
        itemBuilder: (context, index) {
          final chat = groupMessageController.chatData[index];
          return Card(
            elevation: 0,
            color: Colors.transparent,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: chat["avatar"] != null
                    ? NetworkImage(
                        "${ApiConstants.imageBaseUrl}/${chat["avatar"]}")
                    : null,
                child: chat["avatar"] == null
                    ? CustomTextTwo(
                        text: chat['name'][0].toString().toUpperCase())
                    : null,
              ),
              title: CustomTextOne(
                text: chat["name"] ?? "Unknown",
                color: AppColors.textColor,
                fontSize: 15.sp,
                maxLine: 1,
                textAlign: TextAlign.start,
                textOverflow: TextOverflow.ellipsis,
              ),
              subtitle: CustomTextOne(
                text: chat["lastMessage"] ?? "Iftekar vai Message day nai!!!!",
                fontSize: 12.sp,
                color: AppColors.textColor.withOpacity(0.5),
                maxLine: 1,
                textAlign: TextAlign.start,
                textOverflow: TextOverflow.ellipsis,
              ),
              trailing: Column(
                children: [
                  CustomTextOne(
                    text: DateFormat.jm().format(
                        DateTime.parse(chat["lastActiveAt"].toString())
                            .toLocal()),
                    color: AppColors.textColor.withOpacity(0.8),
                    fontSize: 12.sp,
                    maxLine: 1,
                    textAlign: TextAlign.start,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 10.w),
                  if (chat["isUserInvolved"] as bool)
                    CircleAvatar(
                      radius: 5.r,
                      backgroundColor: AppColors.primaryColor,
                    ),
                ],
              ),
              onTap: () => Get.to(() => GroupMessageChatScreen(
                    groupId: chat["_id"],
                    name: chat['name'],
                    img:"${ApiConstants.imageBaseUrl}/${chat["avatar"]}",
                  )),
            ),
          );
        },
      );
    });
  }
}
