import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/utils/app_images.dart';
import 'package:qping/views/discover/discover_map_screen.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:  EdgeInsets.all(20.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 50.h,
            children: [
              Image.asset(AppImages.discover,width: 300.w,),
              CustomTextTwo(text: "Discover people near you!",fontSize: 18.sp,),
              SizedBox(height: 20.h,),
              CustomTextButton(text: "Discover People", onTap: (){
                Get.to(()=> const DisCoverMapScreen());
              }),
            ],
          ),
        ),
      ),
    );
  }
}
