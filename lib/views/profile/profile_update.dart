import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qping/Controller/profile/profile_controller.dart';
import 'dart:io';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/global_widgets/custom_text_field.dart';
import 'package:qping/routes/exports.dart';
import 'package:qping/services/api_constants.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:qping/utils/app_images.dart';


class ProfileUpdate extends StatefulWidget {
  const ProfileUpdate({super.key});

  @override
  _ProfileUpdateState createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  final ImagePicker _picker = ImagePicker();
  File? _profileImage;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final ProfileController controller = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    controller.fetchProfile();
    // Initialize controllers with default values
    nameController.text = controller.profile['fullName'] ?? '';
    addressController.text = controller.profile['email'] ?? '';
    genderController.text = controller.profile['gender'] ?? '';
    ageController.text = controller.profile['age']?.toString() ?? '';
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Pick from Gallery"),
              onTap: () async {
                final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  setState(() {
                    _profileImage = File(image.path);
                  });
                }
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take a Photo"),
              onTap: () async {
                final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  setState(() {
                    _profileImage = File(image.path);
                  });
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(
          text: 'Profile Update',
          fontSize: 18.sp,
          color: AppColors.textColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10.h,
            children: [
              // Profile Picture
              Center(
                child: Stack(
               alignment: Alignment.bottomRight,
                  children: [
                    Obx(() {
                      // Show profile picture or a default image
                      String profileImage = "${ApiConstants.imageBaseUrl}/${controller.profile['profilePicture']}" ?? AppImages.model;

                      return CircleAvatar(
                        radius: 60.r,
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(profileImage),  // Load image from network
                        onBackgroundImageError: (error, stackTrace) {
                          // Handle any errors that occur when loading the image (e.g., if the image URL is broken)
                          print("Error loading image: $error");
                        },
                      );
                    }),
                    Container(
                      height: 40.h,
                      width: 40.w,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: IconButton(
                          onPressed:(){Get.to(()=>UploadPhotosScreen(img:"${ApiConstants.imageBaseUrl}/${controller.profile['profilePicture']}",));},
                          icon: const Icon(Icons.camera_alt, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const CustomTextTwo(text: "Your Name"),
              CustomTextField(
                controller: nameController,
                hintText: "Enter your name",
                filColor: Colors.transparent,
                borderColor: Colors.black,
              ),
              const CustomTextTwo(text: "E-mail"),
              CustomTextField(
                readOnly: true,
                controller: addressController,
                hintText: "Enter your email address",
                filColor: Colors.transparent,
                borderColor: Colors.black,
              ),
              const CustomTextTwo(text: "Gender"),
              CustomTextField(
                readOnly: true,
                controller: genderController,
                hintText: "Enter your gender",
                filColor: Colors.transparent,
                borderColor: Colors.black,
              ),
              const CustomTextTwo(text: "Age"),
              CustomTextField(
                readOnly: true,
                controller: ageController,
                hintText: "Enter your age",
                filColor: Colors.transparent,
                borderColor: Colors.black,
              ),
              SizedBox(
                height: 20.h,
              ),
              // Update Profile Button
              CustomTextButton(
                text: controller.isLoading.value? 'Update Profile':"Updating...",
                onTap: () async {
                  await controller.updateProfile(
                    name: nameController.text,
                    imageFile: _profileImage,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
