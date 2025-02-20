import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qping/Controller/message/group%20message/participants_list_screen_controller.dart';
import 'package:qping/helpers/prefs_helper.dart';
import 'package:qping/services/api_constants.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:qping/utils/app_constant.dart';
import '../../../global_widgets/custom_text.dart';

class ParticipantsListScreen extends StatefulWidget {
  final String groupId;
  const ParticipantsListScreen({super.key, required this.groupId});

  @override
  State<ParticipantsListScreen> createState() => _ParticipantsListScreenState();
}

class _ParticipantsListScreenState extends State<ParticipantsListScreen> {
  final controller = Get.put(ParticipantsListScreenController());

  @override
  void initState() {
    super.initState();
    // Get the current user's role in the group
    controller.getMyRole(widget.groupId);
  }

  @override
  Widget build(BuildContext context) {
    // Fetch participants list when screen is loaded
    controller.getParticipantsList(widget.groupId);

    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(text: "Participants", fontSize: 18.sp),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.participantsList.isEmpty) {
          return _buildShimmerList(context);
        }

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: List.generate(
                controller.participantsList.length,
                    (index) {
                  final participant = controller.participantsList[index];
                  final user = participant['userId'];
                  final role = participant['role'];
                  final isCurrentUser = user['_id'] == PrefsHelper.getString(AppConstants.userId);

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: user["profilePicture"] != null
                              ? NetworkImage("${ApiConstants.imageBaseUrl}/${user["profilePicture"]}")
                              : null,
                          child: user["profilePicture"] == null
                              ? CustomTextTwo(text: user['name'][0].toString().toUpperCase())
                              : null,
                        ),
                        title: CustomTextOne(
                          text: "${user['name']} ${isCurrentUser ? '(Me)' : ''}",
                          fontSize: 16.sp,
                          textAlign: TextAlign.start,
                          color: AppColors.textColor,
                        ),
                        trailing: FittedBox(
                          child: Row(
                            children: [
                              CustomTextTwo(text: role, fontSize: 12.sp),
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert_outlined, color: AppColors.primaryColor),
                                onSelected: (String selectedAction) {
                                  if (selectedAction == 'kickOut') {
                                    controller.kickOutUser(user['_id'], widget.groupId);
                                  } else if (selectedAction == 'PromoteToModerate') {
                                    controller.promoteToModerator(user['_id'], widget.groupId);
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  // Role-based options
                                  if (controller.userRole.value == 'admin') {
                                    return <PopupMenuEntry<String>>[
                                      const PopupMenuItem<String>(value: 'kickOut', child: Text('Kick Out')),
                                      // Show "Promote to Moderator" only if user is not already a moderator
                                      if (role != 'moderator')
                                        const PopupMenuItem<String>(value: 'PromoteToModerate', child: Text('Promote To Moderator'))
                                      else
                                        const PopupMenuItem<String>(value: 'PromoteTo Moderate', child: Text('Already a Moderator')),
                                    ];
                                  } else if (controller.userRole.value == 'moderator') {
                                    return <PopupMenuEntry<String>>[
                                      const PopupMenuItem<String>(value: 'kickOut', child: Text('Kick Out')),
                                    ];
                                  } else {
                                    return [];
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      }),
    );
  }

  // Shimmer effect for loading state
  Widget _buildShimmerList(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        child: Row(
          children: [
            const CircleAvatar(backgroundColor: Colors.grey),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 150.w, height: 15.h, color: Colors.grey),
                SizedBox(height: 5.h),
                Container(width: 100.w, height: 10.h, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
