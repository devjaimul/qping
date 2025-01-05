import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/utils/app_colors.dart';

class MySubscription extends StatelessWidget {
  const MySubscription({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(
          text: 'My Subscription',
          fontSize: 18.sp,
          color: AppColors.textColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(sizeH * 0.016),
          child: Column(
            children: [
              SizedBox(height: sizeH * 0.02),

              SizedBox(height: sizeH * 0.02),
              CustomTextTwo(text: 'You’re not subscribed to any plan'),
              SizedBox(height: sizeH * 0.016),
              CustomTextTwo(
                  text: 'Please subscribe to a plan to use all the features'),
              SizedBox(height: sizeH * 0.3),
              CustomTextButton(
                text: 'See Packages',
                onTap: () {
                 // Get.to(const PackageScreen())
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
