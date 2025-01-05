
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:qping/global_widgets/custom_text.dart';
import 'package:qping/utils/app_colors.dart';


class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: AppBar(title: CustomTextOne(text: "About Us",fontSize: 18.sp,color: AppColors.textColor,),),
      body:  ListView(
        padding: EdgeInsets.all(sizeH * .02),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const CustomTextTwo(text: 'Our Introduction',textAlign: TextAlign.start,),
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
                "Lorem ipsum dolor sit amet consectetur. Lacus at venenatis gravida vivamus mauris. Quisque mi est vel dis. Donec rhoncus laoreet odio orci sed risus elit accumsan. Mattis ut est tristique amet vitae at aliquet. Ac vel porttitor egestas scelerisque enim quisque senectus. Euismod ultricies vulputate id cras bibendum sollicitudin proin odio bibendum. Velit velit in scelerisque erat etiam rutrum phasellus nunc. Sed lectus sed a at et eget. Nunc purus sed quis at risus. Consectetur nibh justo proin placerat condimentum id at adipiscing.",
                textStyle: TextStyle(fontSize: 14.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
