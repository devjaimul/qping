import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qping/Controller/auth/upload_profile_photo_controller.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:qping/utils/app_images.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UploadPhotosScreen extends StatefulWidget {
  final String? img;  // Accept img parameter to pass existing image (URL)
  const UploadPhotosScreen({super.key, this.img});

  @override
  State<UploadPhotosScreen> createState() => _UploadPhotosScreenState();
}

class _UploadPhotosScreenState extends State<UploadPhotosScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  String? _selectedAvatar;
  final UploadProfilePhotoController photoController = Get.put(UploadProfilePhotoController());

  // Predefined avatar options (using PNG asset paths)
  final List<String> _avatars = [
    AppImages.avater0,
    AppImages.avater1,
    AppImages.avater2,
    AppImages.avater3,
    AppImages.avater4,
    AppImages.avater5,
  ];

  // Keep track of the network image or avatar selected
  String? _networkImage;

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = pickedFile;
          _selectedAvatar = null; // Clear avatar selection
          _networkImage = null;   // Clear network image if user selects a new image
        });
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick an image: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    // Set the passed image (if any) to be the initial image
    if (widget.img != null && widget.img!.isNotEmpty) {
      setState(() {
        _networkImage = widget.img;
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
                    height: 180.h,
                    width: 250.w,
                    decoration: BoxDecoration(
                      color: AppColors.textFieldFillColor,
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                    ),
                    child: _image != null
                        ? Image.file(
                      File(_image!.path),
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                    )
                        : _networkImage != null && _networkImage!.isNotEmpty
                        ? CachedNetworkImage(
                      imageUrl: _networkImage!,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error),
                    )
                        : _selectedAvatar != null
                        ? Center(
                      child: Image.asset(
                        _selectedAvatar!,
                        fit: BoxFit.contain,
                        width: 150.w,
                        height: 150.h,
                      ),
                    )
                        : Center(
                      child: CustomTextOne(
                        text: "No Image Selected",
                        fontSize: 14.sp,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -30,
                    child: InkWell(
                      onTap: () async {
                        photoController.startLoading();
                        await _pickImage();
                        photoController.stopLoading();
                      },
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
                        _image = null; // Clear file selection when an avatar is picked
                        _networkImage = null; // Clear network image if avatar is selected
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
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          _avatars[index],
                          fit: BoxFit.cover,
                          height: 40.h, // Set fixed height for all avatars
                          width: 40.h,  // Set fixed width for all avatars
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 40.h),
              Obx(
                    () => CustomTextButton(
                  text: photoController.isLoading.value ? "Uploading..." : "Submit",
                  onTap: () {
                    if (_image == null && _selectedAvatar == null) {
                      Get.snackbar("!!!", "Please select or upload a profile image.");
                    } else {
                      final file = _image != null ? File(_image!.path) : null;
                      photoController.uploadProfilePicture(
                        imageFile: file,
                        avatarPath: _selectedAvatar, // Pass avatar path if selected
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
