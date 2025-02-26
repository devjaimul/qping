import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qping/Controller/profile/profile_controller.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/global_widgets/custom_text_field.dart';
import 'package:qping/services/api_constants.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:qping/utils/app_images.dart';
import 'package:qping/views/profile/profile_update.dart';

class ProfileInformation extends StatelessWidget {
  const ProfileInformation({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
    controller.fetchProfile();

    return Scaffold(
      appBar: AppBar(

        title:  CustomTextOne(text: 'Profile Information',fontSize: 18.sp,color: AppColors.textColor,),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10.h,
            children: [
              // Profile Picture
              Obx(() {
                String profileImage ="${ApiConstants.imageBaseUrl}/${controller.profile['profilePicture'] }";
                return Center(
                  child: Container(
                    width: 120.r,
                    height: 120.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 10.r,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      border: Border.all(
                        color: AppColors.primaryColor.withOpacity(0.5), // Outer blue border
                        width: 2.w,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 50.r,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: NetworkImage(profileImage),  // Load image from network
                    ),
                  ),
                );
              }),

              const CustomTextTwo(text: "Your Name"),
              CustomTextField(
                controller: TextEditingController(),
                hintText: controller.profile['fullName'],
                filColor: Colors.transparent,
                borderColor: Colors.black,
                readOnly: true,
              ),
              const CustomTextTwo(text: "E-mail"),
              CustomTextField(
                controller: TextEditingController(),
                hintText: controller.profile['email'],
                filColor: Colors.transparent,
                borderColor: Colors.black,
                readOnly: true,
              ),
              const CustomTextTwo(text: "Gender"),
              CustomTextField(
                controller: TextEditingController(),
                hintText: controller.profile['gender'],
                filColor: Colors.transparent,
                borderColor: Colors.black,
                readOnly: true,
              ),
              const CustomTextTwo(text: "Age"),
              CustomTextField(
                controller: TextEditingController(),
                hintText: controller.profile['age'].toString(),
                filColor: Colors.transparent,
                borderColor: Colors.black,
                readOnly: true,
              ),

              SizedBox(
                height: 20.h,
              ),
              // Edit Profile Button
              CustomTextButton(
                text: 'Edit Profile',
                color: Colors.transparent,
                borderColor: AppColors.primaryColor,
                textColor: AppColors.primaryColor,
                onTap: () async {
                  Get.to(const ProfileUpdate());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
