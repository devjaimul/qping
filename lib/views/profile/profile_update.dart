
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/global_widgets/custom_text_field.dart';
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
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Initialize controllers with default values
    nameController.text = "Lucy";
    addressController.text = "lucyhuntstreasure@hmail.com";
    genderController.text = "Female";
    ageController.text = "24 yrs";
    heightController.text = "5'6\""; // Example default value
    weightController.text = "65 kg"; // Example default value
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
                final XFile? image =
                await _picker.pickImage(source: ImageSource.gallery);
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
                final XFile? image =
                await _picker.pickImage(source: ImageSource.camera);
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
                    Container(
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
                          color: AppColors.primaryColor.withOpacity(0.5),
                          width: 2.w,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 50.r,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!) as ImageProvider
                            : const AssetImage(AppImages.model),
                      ),
                    ),
                    Container(
                      height: 40.h,
                      width: 40.w,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: IconButton(
                          onPressed: _pickImage,
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
                controller: addressController,
                hintText: "Enter your email address",
                filColor: Colors.transparent,
                borderColor: Colors.black,
              ),
              const CustomTextTwo(text: "Gender"),
              CustomTextField(
                controller: genderController,
                hintText: "Enter your gender",
                filColor: Colors.transparent,
                borderColor: Colors.black,
              ),
              const CustomTextTwo(text: "Age"),
              CustomTextField(
                controller: ageController,
                hintText: "Enter your age",
                filColor: Colors.transparent,
                borderColor: Colors.black,
              ),
              SizedBox(
                height: 20.h,
              ),
              // Edit Profile Button
              CustomTextButton(
                text: 'Update Profile',
                onTap: () async {
                  // Implement profile update logic
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

