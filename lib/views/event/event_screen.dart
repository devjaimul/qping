import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/utils/app_images.dart';
import 'package:qping/views/event/event_details_screen.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.event,
              width: 200.w,
            ),
            SizedBox(height: 20.h), // Add spacing
            CustomTextTwo(
              text: "Join scavenger hunts near you!",
              fontSize: 18.sp,
            ),
            SizedBox(height: 20.h), // Add spacing
            // A scrollable list inside the scrollable column
            Column(
              children: List.generate(
                5,
                    (index) {
                  return Card(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 10.h),
                    child: ListTile(
                      onTap: (){
                        Get.to(()=>const EventDetailsScreen());
                      },
                      leading: CircleAvatar(
                        radius: 25.r,
                        backgroundImage: const AssetImage(AppImages.selecton),
                      ),
                      title: CustomTextOne(
                        text: "Mission: Find Dooley",
                        fontSize: 18.sp,
                        textAlign: TextAlign.start,
                      ),
                      subtitle: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextTwo(
                            text: "First to find Dooley wins \$2000!",
                            textAlign: TextAlign.start,
                          ),
                          CustomTextTwo(
                            text: "Starting date: 12th January, 2025",
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
