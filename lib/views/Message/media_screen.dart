import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qping/Controller/message/media_controller.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/utils/app_images.dart';


class MediaScreen extends StatelessWidget {

  final MediaController controller = Get.put(MediaController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:CustomTextOne(text: 'Media',fontSize: 18.sp,),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.h,
          ),
          itemCount: controller.mediaImages.length,
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Image.asset(
               AppImages.model,
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ),
    );
  }
}
