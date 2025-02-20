import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_colors.dart';
import '../utils/app_dimentions.dart';

// Custom shimmer extension for global theme access
class ShimmerThemeExtension extends ThemeExtension<ShimmerThemeExtension> {
  final Widget Function(double width, double height) shimmerLoader;

  const ShimmerThemeExtension({required this.shimmerLoader});

  @override
  ThemeExtension<ShimmerThemeExtension> copyWith({
    Widget Function(double width, double height)? shimmerLoader,
  }) {
    return ShimmerThemeExtension(
      shimmerLoader: shimmerLoader ?? this.shimmerLoader,
    );
  }

  @override
  ThemeExtension<ShimmerThemeExtension> lerp(
      ThemeExtension<ShimmerThemeExtension>? other, double t) {
    if (other is! ShimmerThemeExtension) return this;
    return ShimmerThemeExtension(
      shimmerLoader: shimmerLoader,
    );
  }
}

// Light theme with shimmer loader
ThemeData light() => ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.bgColor,
  primaryColor: const Color(0xff800000),
  secondaryHeaderColor: const Color(0xff04B200),
  brightness: Brightness.light,
  cardColor: Colors.white,
  hintColor: const Color(0xFF9F9F9F),
  disabledColor: const Color(0xFFBABFC4),
  shadowColor: Colors.grey[300],
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
  dividerColor: AppColors.primaryColor,
  textTheme: const TextTheme(
    displayLarge: TextStyle(
        fontWeight: FontWeight.w300, fontSize: Dimensions.fontSizeDefault),
    displayMedium: TextStyle(
        fontWeight: FontWeight.w400, fontSize: Dimensions.fontSizeDefault),
    displaySmall: TextStyle(
        fontWeight: FontWeight.w500, fontSize: Dimensions.fontSizeDefault),
    headlineMedium: TextStyle(
        fontWeight: FontWeight.w600, fontSize: Dimensions.fontSizeDefault),
    headlineSmall: TextStyle(
        fontWeight: FontWeight.w700, fontSize: Dimensions.fontSizeDefault),
    titleLarge: TextStyle(
        fontWeight: FontWeight.w800, fontSize: Dimensions.fontSizeDefault),
    bodySmall: TextStyle(
        fontWeight: FontWeight.w900, fontSize: Dimensions.fontSizeDefault),
    titleMedium: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
    bodyMedium: TextStyle(fontSize: 12.0),
    bodyLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600),
  ),
  appBarTheme: AppBarTheme(
    scrolledUnderElevation: 0,
    centerTitle: true,
    backgroundColor: Colors.transparent,
    foregroundColor: AppColors.textColor,
    shadowColor: Colors.black.withOpacity(0.12),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.buttonSecondColor),
  datePickerTheme: DatePickerThemeData(
    dayStyle: TextStyle(color: AppColors.primaryColor, fontSize: 14.h),
    weekdayStyle: TextStyle(fontSize: 14.h, color: Colors.black),
  ),
  fontFamily: "Outfit",
  extensions: <ThemeExtension<dynamic>>[
    ShimmerThemeExtension(
      shimmerLoader: (double width, double height) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    ),
  ],
);
