import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/global_widgets/custom_text_field.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:qping/Controller/event/event_controller.dart';

class EventCreateScreen extends StatelessWidget {
  final String? eventId;
  final Map<String, dynamic>? eventData;  // Optional parameter for editing an event
  const EventCreateScreen({super.key, this.eventData, this.eventId});

  @override
  Widget build(BuildContext context) {
    final EventController controller = Get.put(EventController());

    // Controllers for form fields
    TextEditingController titleTEController = TextEditingController();
    TextEditingController dateTEController = TextEditingController();
    TextEditingController timeTEController = TextEditingController();
    TextEditingController locationTEController = TextEditingController();
    TextEditingController descriptionTEController = TextEditingController();

    // If eventData is provided, pre-fill the form
    if (eventData != null) {
      titleTEController.text = eventData!['eventName'] ?? '';

      // Parse eventDate string and format
      DateTime eventDate = DateFormat('yyyy-MM-dd').parse(eventData!['eventDate']);
      dateTEController.text = DateFormat('dd MMM yyyy').format(eventDate);  // Format as dd MMM yyyy

      timeTEController.text = eventData!['eventTime'] ?? '';
      locationTEController.text = eventData!['eventLocation'] ?? '';
      descriptionTEController.text = eventData!['eventDescription'] ?? '';
    }

    // Global key for form validation
    final _formKey = GlobalKey<FormState>();

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
          text: eventData != null ? "Edit Event" : "Create Event", // Change title if it's edit mode
          fontSize: 18.sp,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Form(
            key: _formKey, // Form key for validation
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Event name is required';
                    }
                    return null;
                  },
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Event date is required';
                    }
                    return null;
                  },
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Event time is required';
                    }
                    return null;
                  },
                ),
                CustomTextTwo(
                  text: "Event Location",
                  fontSize: 16.sp,
                ),
                CustomTextField(
                  controller: locationTEController,
                  hintText: "Enter Event Location here..",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Event location is required';
                    }
                    return null;
                  },
                ),
                CustomTextTwo(
                  text: "Event Description",
                  fontSize: 16.sp,
                ),
                CustomTextField(
                  controller: descriptionTEController,
                  hintText: "Enter Event Description here..",
                  maxLine: 6,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Event description is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15.h),
                CustomTextButton(
                  text: eventData != null ? "Update Event" : "Save", // Change button text
                  onTap: eventData != null
                      ? () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // If the form is valid, call updateEvent method
                      controller.updateEvent(
                        eventId: eventId ?? '',
                        eventName: titleTEController.text,
                        eventDescription: descriptionTEController.text,
                        eventTime: timeTEController.text,
                        eventDate: dateTEController.text,
                        eventLocation: locationTEController.text,
                      );
                      Get.back();  // Close the screen after event is updated
                    }
                  }
                      : () {
                    if (_formKey.currentState?.validate() ?? false) {
                      controller.createEvent(
                        eventName: titleTEController.text,
                        eventDescription: descriptionTEController.text,
                        eventTime: timeTEController.text,
                        eventDate: dateTEController.text,
                        eventLocation: locationTEController.text,
                      );
                      Get.back();  // Close the screen after event is created
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
