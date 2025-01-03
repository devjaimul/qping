import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qping/utils/app_colors.dart';


class CustomTextButton extends StatelessWidget {
  final String text;
  final double? fontSize;
  final double? padding;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final Function onTap;
  final double? radius;
  const CustomTextButton({
    super.key,
    required this.text,
    this.color,
    required this.onTap,
    this.fontSize,
    this.radius,
    this.textColor,
    this.padding, this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;
    return TextButton(
        onPressed: () {
          onTap();
        },
        style: TextButton.styleFrom(
            padding: EdgeInsets.all(padding ?? sizeH * .015),
            backgroundColor: color ?? AppColors.buttonColor,
            side:  BorderSide(color:borderColor?? Colors.white),
            fixedSize: const Size.fromWidth(double.maxFinite),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius??16.r))),
        child: Text(
          text,
          style: TextStyle(
              color:textColor?? Colors.white,
              fontSize:fontSize?? sizeH * .021,
              fontWeight: FontWeight.w600,
          fontFamily: 'Outfit'
          ),
        ));
  }
}

class StyleTextButton extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final Color? textColor;
  final Function onTap;
  final double? radius;
  final TextAlign? textAlign;
  const StyleTextButton({
    super.key,
    required this.text,
    this.color,
    required this.onTap,
    this.fontSize,
    this.radius,
    this.textColor, this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;
    return TextButton(
        onPressed: () {
          onTap();
        },
        child: Text(
          text,
          textAlign:textAlign ,
          style: TextStyle(
            color: textColor??AppColors.primaryColor,
              fontSize: sizeH * .018,
              fontWeight: FontWeight.w600,
              fontFamily: 'Outfit'),
        ));
  }
}