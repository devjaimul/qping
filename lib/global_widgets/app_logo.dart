
import 'package:flutter/material.dart';
import 'package:qping/utils/app_images.dart';



class AppLogo extends StatelessWidget {
  final String? img;
  const AppLogo({
    super.key, this.img,

  });


  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;
    final sizeW = MediaQuery.sizeOf(context).width;
    return Image.asset(
     img??AppImages.appLogoBlack,
      height: sizeH * .15,
      width: sizeW * .4,
    );
  }
}