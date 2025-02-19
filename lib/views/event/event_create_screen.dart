import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/global_widgets/custom_text_field.dart';
import 'package:qping/utils/app_colors.dart';

class EventCreateScreen extends StatelessWidget {
  const EventCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController titleTEController = TextEditingController();
    TextEditingController dateTEController = TextEditingController();
    TextEditingController timeTEController = TextEditingController();
    TextEditingController locationTEController = TextEditingController();
    TextEditingController descriptionTEController = TextEditingController();

    // Date Picker Function
    Future<void> _selectDate(BuildContext context) async {
      DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (selectedDate != null) {
        dateTEController.text = '${selectedDate.toLocal()}'.split(' ')[0]; // Format date
      }
    }

    // Time Picker Function
    Future<void> _selectTime(BuildContext context) async {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (selectedTime != null) {
        timeTEController.text = selectedTime.format(context);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(
          text: "Create Event",
          fontSize: 18.sp,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10.h,
            children: [
              CustomTextTwo(
                text: "Event name",
                fontSize: 16.sp,
              ),
              CustomTextField(
                controller: titleTEController,
                hintText: "Enter Event name here..",
              ),
              CustomTextTwo(
                text: "Event Date",
                fontSize: 16.sp,
              ),
              CustomTextField(
                onTap: () {
                  _selectDate(context);
                },
                readOnly: true,
                controller: dateTEController,
                hintText: "Enter Event Date here..",
                suffixIcon: Icon(Icons.calendar_month, color: AppColors.primaryColor),
              ),
              CustomTextTwo(
                text: "Event Time",
                fontSize: 16.sp,
              ),
              CustomTextField(
                onTap: () {
                  _selectTime(context);
                },
                readOnly: true,
                controller: timeTEController,
                hintText: "Enter Event Time here..",
                suffixIcon: Icon(Icons.access_time_filled, color: AppColors.primaryColor),
              ),
              CustomTextTwo(
                text: "Event Location",
                fontSize: 16.sp,
              ),
              CustomTextField(
                controller: locationTEController,
                hintText: "Enter Event Location here..",
              ),
              CustomTextTwo(
                text: "Event Description",
                fontSize: 16.sp,
              ),
              CustomTextField(
                controller: descriptionTEController,
                hintText: "Enter Event Description here..",
                maxLine: 6,
              ),
              SizedBox(height: 15.h,),
              CustomTextButton(text: "Save", onTap: (){
                Get.back();
              })
            ],
          ),
        ),
      ),
    );
  }
}
