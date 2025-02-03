import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/global_widgets/custom_text_button.dart';
import 'package:qping/utils/app_colors.dart';


class PollWidget extends StatelessWidget {
  final Map<String, dynamic> pollData;
  final Function(int, bool) onUpdate;

  const PollWidget({required this.pollData, required this.onUpdate, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryColor),
        borderRadius: BorderRadius.circular(10.r),
        color: Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextTwo(text: pollData['question']),

          ...List.generate(
            pollData['options'].length,
                (index) => Padding(
              padding: EdgeInsets.symmetric(vertical: 5.h),
              child: Row(
                children: [
                  Checkbox(
                    value: pollData['options'][index]['selected'],
                    onChanged: (value) => onUpdate(index, value!),
                  ),
                  Expanded(
                    child: CustomTextTwo(
                      text: pollData['options'][index]['text'],
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: 120.w,
              child: CustomTextButton(
                text: "Submit",
                onTap: () {},
                padding: 1.r,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
