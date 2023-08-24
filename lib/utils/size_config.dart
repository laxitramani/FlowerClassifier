import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static double? defaultSize;
  static Orientation? orientation;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  // 896 is the standard layout height for mobile
  return (inputHeight / 896) * SizeConfig.screenHeight;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  // 414 is the standard layout width for mobile
  return (inputWidth / 414) * SizeConfig.screenWidth;
}

sizeBoxHeight(double value) {
  return SizedBox(
    height: getProportionateScreenHeight(value),
  );
}

sizeBoxWidth(double value) {
  return SizedBox(
    width: getProportionateScreenWidth(value),
  );
}
