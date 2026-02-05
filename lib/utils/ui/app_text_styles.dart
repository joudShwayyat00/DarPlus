import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle appTextStyle(
    BuildContext context, {
      double? fontSize,
      FontWeight? fontWeight,
      Color? color,
      double? height,
    }) {
  final isArabic =
      Directionality.of(context) == TextDirection.rtl;

  if (isArabic) {
    return TextStyle(
      fontFamily: 'GESSSTwo',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  } else {
    return GoogleFonts.montserrat(
      fontSize: fontSize,
      fontWeight: fontWeight??FontWeight.w500,
      color: color,
      height: height,
    );
  }
}
