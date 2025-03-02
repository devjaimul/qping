import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:qping/Controller/profile/setting_controller.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/utils/app_colors.dart';


class AppData extends StatelessWidget {
  final String type;
  const AppData({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;
    final SettingController settingController = Get.put(SettingController());
    settingController.fetchAppData(type);

    return Scaffold(
      appBar: AppBar(
        title: CustomTextOne(
          text: type.capitalize.toString(),
          fontSize: 18.sp,
          color: AppColors.textColor,
        ),
      ),
      body: Obx(() {
        if (settingController.isLoadingAppData.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          padding: EdgeInsets.all(sizeH * .02),
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
             CustomTextTwo(
              text: 'Our ${type.capitalize}',
              textAlign: TextAlign.start,
            ),
            SizedBox(height: sizeH * .02),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.all(sizeH * .016),
              child: SizedBox(
                height: sizeH * 0.7,
                child: HtmlWidget(
                  settingController.appContent.value,
                  textStyle: TextStyle(fontSize: 14.sp),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
