import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:qping/views/event/event_create_screen.dart';
import 'package:readmore/readmore.dart';


class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:  EdgeInsets.all(16.r),
        child: ListView.builder(
          itemCount: 5,

          itemBuilder: (context, index) {
          return Card(
            color: Colors.white,
            child: Padding(
              padding:  EdgeInsets.all(10.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5.h,
                children: [
                  CustomTextOne(text: "Elven   Tavern",fontSize: 16.sp,),
                  CustomTextTwo(text: "Date: 10th Mar, 2025",fontSize: 14.sp,fontWeight: FontWeight.bold,),
                  CustomTextTwo(text: "Time: 10.15 AM",fontSize: 14.sp,fontWeight: FontWeight.bold,),
                  CustomTextTwo(text: "Location: Bonosree, Dhaka.",fontSize: 15.sp,fontWeight: FontWeight.w500,),
                  ReadMoreText(
                    "Get a free wrap and Drink with any order of a bowl. Press redeem and show this Coupy Deal to a staff member to redeem.Get a free wrap and Drink with any order of a bowl. Press redeem and show this Coupy Deal to a staff member to redeem.",
                    trimLines: 3,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: "show more",
                    moreStyle: const TextStyle(color: AppColors.primaryColor),
                    style: TextStyle(
                        color: AppColors.textColor, fontSize:14.sp),
                    trimExpandedText: "show less",
                    colorClickableText: AppColors.primaryColor,
                  ),
                  CustomTextButton(text: "Join", onTap: (){},fontSize: 14.sp,padding: 4.r,),
                ],
              ),
            ),
          );
        },),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
Get.to(()=> EventCreateScreen());

      },backgroundColor: AppColors.primaryColor,foregroundColor: Colors.white,child: const Icon(Icons.add),),
    );
  }
}
