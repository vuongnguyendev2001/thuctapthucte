import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import 'color.dart';

class Style {
  static TextStyle homeStyle = GoogleFonts.openSans(
    textStyle: const TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 22,
      color: blackColor,
    ),
  );
  static TextStyle hometitleStyle = GoogleFonts.openSans(
    textStyle: const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 18,
      color: blackColor,
    ),
  );
  static TextStyle titleStyle = GoogleFonts.openSans(
    textStyle: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: blackColor,
    ),
  );
  static TextStyle titlegreyStyle = GoogleFonts.openSans(
    textStyle: const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      color: wordGreyColor,
    ),
  );
  static TextStyle subtitleStyle = GoogleFonts.openSans(
    textStyle: const TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: blackColor,
    ),
  );
  static TextStyle homesubtitleStyle = GoogleFonts.openSans(
    textStyle: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 13,
      color: whiteColor,
    ),
  );
  static TextStyle priceStyle = GoogleFonts.openSans(
    textStyle: const TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: wordGreyColor,
    ),
  );

  static TextStyle statusProductStyle = GoogleFonts.openSans(
    textStyle: const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      color: blackColor,
    ),
  );
  static TextStyle homeTitleStyle = GoogleFonts.openSans(
    textStyle: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 18,
      color: whiteColor,
    ),
  );
}
