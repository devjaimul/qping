import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:get/get.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:qping/utils/app_images.dart';
import 'package:qping/views/event/event_map_screen.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(
          text: "Event Details",
          color: AppColors.textColor,
          fontSize: 18.sp,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10.h,
            children: [
              Center(
                child: Card(
                  color: AppColors.primaryColor,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    child: Column(
                      children: [
                        // Event title
                        CustomTextOne(
                          text: "Event Starts in",
                          color: Colors.white,
                          fontSize: 25.sp,
                        ),

                        // Countdown Timer
                        TimerCountdown(
                          format: CountDownTimerFormat.daysHoursMinutesSeconds,
                          endTime: DateTime.now().add(const Duration(
                            days: 7,
                            hours: 5,
                            minutes: 30,
                            seconds: 10,
                          )),
                          timeTextStyle: TextStyle(
                              fontSize: 30.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Outfit'),
                          colonsTextStyle: TextStyle(
                              fontSize: 30.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Outfit'),
                          descriptionTextStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Outfit',
                            fontSize: 14.sp,
                          ),
                          spacerWidth: 10,
                          onEnd: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("The event has started!"),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 100.w,
                  child: CustomTextButton(
                    text: "Join Event",
                    onTap: () {},
                    color: Colors.transparent,
                    borderColor: AppColors.primaryColor,
                    textColor: AppColors.primaryColor,
                    padding: 2.h,
                    radius: 5.r,
                  ),
                ),
              ),
              const CustomTextTwo(text: "Already joined to the event "),
              Column(
                children: List.generate(
                  10,
                      (index) {
                    return Card(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 25.r,
                            backgroundImage: const AssetImage(AppImages.model),
                          ),
                          title: CustomTextOne(
                            text: "Mr. Victor",
                            fontSize: 18.sp,
                            textAlign: TextAlign.start,
                            color: AppColors.textColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height:50.h)
            ],
          ),
        ),
      ),

      // Floating Action Button
      floatingActionButton: Padding(
        padding:  EdgeInsets.all(16.r),
        child: CustomTextButton(
          text: "Start Hunting",
          onTap: () {

Get.to(()=>EventMapScreen());
          },

        ),
      ),

      // Position Floating Action Button in the Center Bottom
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
