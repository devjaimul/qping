import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qping/utils/app_colors.dart';
import 'package:qping/utils/app_images.dart';

import '../../../global_widgets/custom_text.dart';

class ParticipantsListScreen extends StatelessWidget {
  const ParticipantsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: AppBar(
        title: CustomTextOne(text: "Participants",fontSize: 18.sp,),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(16.r),
          child: Column(
            children: [

              Column(
                children: List.generate(
                  10,
                      (index) {
                    return Card(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 25.r,
                            backgroundImage: const AssetImage(AppImages.model),
                          ),
                          title: CustomTextOne(
                            text: "Mr. Victor",
                            fontSize: 16.sp,
                            textAlign: TextAlign.start,
                            color: AppColors.textColor,
                          ),
                          trailing: FittedBox(
                            child: Row(
                              children: [
                                CustomTextTwo(text: "Member",fontSize: 12.sp,),
                                IconButton(onPressed: (){}, icon: Icon(Icons.more_vert_outlined)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
