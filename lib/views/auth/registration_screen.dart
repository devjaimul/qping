import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qping/Controller/auth/registration_controller.dart';
import 'package:qping/global_widgets/app_logo.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/global_widgets/custom_text_field.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:qping/utils/app_icons.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RegistrationController registrationController = Get.put(RegistrationController());

    TextEditingController nameTEController = TextEditingController();
    TextEditingController genderTEController = TextEditingController();
    TextEditingController organizationTEController = TextEditingController();
    TextEditingController birthdayTEController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    Future<void> selectDate(BuildContext context) async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
      );

      if (pickedDate != null) {
        birthdayTEController.text =
        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(
          text: "Registration",
          color: AppColors.textColor,
          fontSize: 18.sp,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Form(
              key: formKey,
              child: Column(
            spacing: 15.h,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppLogo(),
              SizedBox(height: 15.h),

              // Full Name
              CustomTextField(
                controller: nameTEController,
                hintText: "Full Name",
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Image.asset(
                    AppIcons.person,
                    height: 18.h,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Full Name cannot be empty";
                  }
                  return null;
                },
                borderRadio: 12.r,
              ),

              // Gender
              CustomTextField(
                readOnly: true,
                controller: genderTEController,
                hintText: "Gender",
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Image.asset(
                    AppIcons.gender,
                    height: 18.h,
                  ),
                ),
                suffixIcon: PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.arrow_drop_down_circle_outlined,
                    color: AppColors.primaryColor,
                  ),
                  onSelected: (String selectedGender) {
                    genderTEController.text = selectedGender;
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: "Male",
                      child: Text("Male"),
                    ),
                    const PopupMenuItem<String>(
                      value: "Female",
                      child: Text("Female"),
                    ),
                    const PopupMenuItem<String>(
                      value: "Others",
                      child: Text("Others"),
                    ),
                  ],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Gender cannot be empty";
                  }
                  return null;
                },
                borderRadio: 12.r,
              ),


              // Organization (as a popup menu)
              CustomTextField(
                readOnly: true,
                onTap: () {}, // can be left empty since the PopupMenuButton handles selection
                controller: organizationTEController,
                hintText: "Organization",
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Image.asset(
                    AppIcons.address,
                    height: 18.h,
                  ),
                ),
                suffixIcon: PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.arrow_drop_down_circle_outlined,
                    color: AppColors.primaryColor,
                  ),
                  onSelected: (String selectedOrganization) {
                    organizationTEController.text = selectedOrganization;
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: "Emory University",
                      child: Text("Emory University"),
                    ),
                    const PopupMenuItem<String>(
                      value: "Georgia Institute of Technology",
                      child: Text("Georgia Institute of Technology"),
                    ),
                    const PopupMenuItem<String>(
                      value: "Georgia State University",
                      child: Text("Georgia State University"),
                    ),
                  ],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Organization cannot be empty";
                  }
                  return null;
                },
                borderRadio: 12.r,
              ),


              // Birthday
              CustomTextField(
                onTap: (){
                  selectDate(context);
                },
                readOnly: true,
                controller: birthdayTEController,
                hintText: "Birthday",
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Image.asset(
                    AppIcons.birthday,
                    height: 18.h,
                  ),
                ),
                suffixIcon: const Icon(Icons.calendar_month, color: AppColors.primaryColor),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Birth Date cannot be empty";
                  }
                  return null;
                },
                borderRadio: 12.r,
              ),

              SizedBox(height: 10.h),

              // Next Button
              Obx(
                    () => CustomTextButton(
                  text: registrationController.isLoading.value ? "Submitting..." : "Next",
                  onTap: () {

                    if (formKey.currentState?.validate() ?? false) {
                    final fullName = nameTEController.text.trim();
                    final gender = genderTEController.text.trim();
                    final address = organizationTEController.text.trim();
                    final dob = birthdayTEController.text.trim();


                    // Call createProfile API
                    registrationController.createProfile(
                      fullName: fullName,
                      address: address,
                      dob: dob,
                      gender: gender,
                    );}
                  },
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
