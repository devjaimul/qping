import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/utils/app_colors.dart';


class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(
          text: 'Notification',
          fontSize: 18.sp,
          color: AppColors.textColor,
        ),
      ),
      body: Padding(
        padding:  EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextOne(text: "Today",fontSize: 18.sp,color: AppColors.textColor,textAlign: TextAlign.start,),
            Expanded(
              child: ListView.builder(
                itemCount: 8,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        color: index == 0 ? AppColors.primaryColor : Colors.transparent,
                        child: Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 2.w),
                          child: ListTile(
                            leading:Container(
                                height: 40.h,
                                width: 40.w,
                                decoration: BoxDecoration(
                                  color:index==0? AppColors.bgColor:AppColors.primaryColor.withOpacity(0.4),
                                  shape: BoxShape.circle
                                ),
                                child: Icon(Icons.notifications_none,color:index==0? AppColors.primaryColor:Colors.white,)),
                            title: CustomTextOne(text: 'William accepted your Request.',color:index==0? Colors.white:Colors.black,fontSize: 14.sp,maxLine: 1,textOverflow: TextOverflow.ellipsis,textAlign: TextAlign.start,),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextOne(text: 'Sorry, your information’s picture are not clear. ',color:index==0? Colors.white:AppColors.textColor,fontSize: 12.sp,maxLine: 2,textOverflow: TextOverflow.ellipsis,textAlign: TextAlign.start,),
                                CustomTextOne(text: '12:35 PM',color:index==0? Colors.white:Colors.black,fontSize: 12.sp,maxLine: 1,textOverflow: TextOverflow.ellipsis,),
                              ],
                            ),
                          ),
                        )
                      ),
                      Divider(color: AppColors.primaryColor,thickness: 1,indent: 20.w,endIndent: 20.w,),
                    ],
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
