import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/routes/app_routes.dart';
import 'package:qping/utils/app_colors.dart';

class UploadPhotosScreen extends StatefulWidget {
  const UploadPhotosScreen({super.key});

  @override
  State<UploadPhotosScreen> createState() => _UploadPhotosScreenState();
}

class _UploadPhotosScreenState extends State<UploadPhotosScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
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
          padding:  EdgeInsets.all(16.h),
          child: Column(
            children: [
              SizedBox(height: 100.h,),
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
                          : null,
                    ),
                    child: _image == null
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
              SizedBox(height: 100.h,),
              CustomTextButton(text: "Submit", onTap: (){
                Get.offAllNamed(AppRoutes.customNavBar);
              })
            ],
          ),
        ),
      ),
    );
  }
}
