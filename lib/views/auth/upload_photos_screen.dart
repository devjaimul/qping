import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/routes/app_routes.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:qping/utils/app_images.dart';

class UploadPhotosScreen extends StatefulWidget {
  const UploadPhotosScreen({super.key});

  @override
  State<UploadPhotosScreen> createState() => _UploadPhotosScreenState();
}

class _UploadPhotosScreenState extends State<UploadPhotosScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  String? _selectedAvatar;

  // Predefined avatar options (add these images to your assets folder)
  final List<String> _avatars = [
    AppImages.dogAvater,
    AppImages.hippoAvater,
    AppImages.crowAvater,


  ];

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
        _selectedAvatar = null; // Clear avatar selection if a photo is uploaded
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(
          text: "Upload Profile",
          fontSize: 18.sp,
          color: AppColors.textColor,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textColor),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Stack(
                alignment: Alignment.bottomCenter,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 280.h,
                    width: 300.w,
                    decoration: BoxDecoration(
                      color: AppColors.textFieldFillColor,
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      image: _image != null
                          ? DecorationImage(
                        image: FileImage(
                          File(_image!.path),
                        ),
                        fit: BoxFit.cover,
                      )
                          : _selectedAvatar != null
                          ? DecorationImage(
                        image: AssetImage(_selectedAvatar!),
                        fit: BoxFit.cover,

                      )
                          : null,
                    ),
                    child: _image == null && _selectedAvatar == null
                        ? Center(
                      child: CustomTextOne(
                        text: "No Image Selected",
                        fontSize: 14.sp,
                        color: AppColors.textColor,
                      ),
                    )
                        : null,
                  ),
                  Positioned(
                    bottom: -30,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 50.h,
                        width: 50.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              spreadRadius: 1,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: AppColors.primaryColor,
                          size: 30.h,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50.h),
              CustomTextOne(
                text: "Or Select an Avatar",
                fontSize: 16.sp,
                color: AppColors.textColor,
              ),
              SizedBox(height: 20.h),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _avatars.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedAvatar = _avatars[index];
                        _image = null; // Clear uploaded photo if avatar is selected
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _selectedAvatar == _avatars[index]
                              ? AppColors.primaryColor
                              : Colors.transparent,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: AssetImage(_avatars[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 40.h),
              CustomTextButton(
                text: "Submit",
                onTap: () {
                  String profileImage = _image?.path ?? _selectedAvatar ?? '';
                  if (profileImage.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please select or upload a profile image")),
                    );
                  } else {
                    debugPrint("Selected Profile Image: $profileImage");
                    Get.offAllNamed(AppRoutes.customNavBar);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

