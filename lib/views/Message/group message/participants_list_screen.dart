import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qping/Controller/message/group%20message/participants_list_screen_controller.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:qping/utils/app_images.dart';

import '../../../global_widgets/custom_text.dart';

class ParticipantsListScreen extends StatelessWidget {
  final String groupId;
  const ParticipantsListScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ParticipantsListScreenController());

    // Fetch participants list when screen is loaded
    controller.getParticipantsList(groupId);

    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(text: "Participants", fontSize: 18.sp),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
                // List of participants based on the fetched data
                Column(
                  children: List.generate(
                    controller.participantsList.length,
                        (index) {
                      final participant = controller.participantsList[index];
                      final user = participant['userId'];
                      final role = participant['role'];

                      return Card(
                        color: Colors.white,
                        margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 25.r,
                              backgroundImage: const AssetImage(AppImages.model),
                            ),
                            title: CustomTextOne(
                              text: user['name'] ?? "Unknown",
                              fontSize: 16.sp,
                              textAlign: TextAlign.start,
                              color: AppColors.textColor,
                            ),
                            trailing: FittedBox(
                              child: Row(
                                children: [
                                  CustomTextTwo(text: role, fontSize: 12.sp),
                                  if (role == 'admin')
                                    IconButton(
                                      onPressed: () {
                                        _showPopupMenu(context, user['_id'], controller);
                                      },
                                      icon: const Icon(Icons.more_vert_outlined),
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
              ],
            ),
          ),
        );
      }),
    );
  }

  // Popup menu for "Kick Out" action
  void _showPopupMenu(BuildContext context, String userId, ParticipantsListScreenController controller) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100.0, 100.0, 10.0, 10.0),
      items: [
        const PopupMenuItem(
          value: 'kickOut',
          child: Text('Kick Out'),
        ),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value == 'kickOut') {
        // Call the controller's kickOutUser method
        controller.kickOutUser(userId);
      }
    });
  }
}
