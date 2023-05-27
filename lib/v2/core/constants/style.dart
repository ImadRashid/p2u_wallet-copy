import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A generic [PoppinsTextStyle] made to fulfill our needs.
/// * [size] - a [double] value represent [fontSize]
/// * [weight] - a [FontWeight] value represent how much [Bold] a [Text] should be.
/// * [color] - a [Color] value

TextStyle poppinsTextStyle(double size, FontWeight weight, color) {
  return GoogleFonts.poppins(fontSize: size, fontWeight: weight, color: color);
}

/// A generic [InterTextStyle] made to fulfill our needs.
/// * [size] - a [double] value represent [fontSize]
/// * [weight] - a [FontWeight] value represent how much [Bold] a [Text] should be.
/// * [color] - a [Color] value
TextStyle interTextStyle(double size, FontWeight weight, color) {
  return GoogleFonts.inter(fontSize: size, fontWeight: weight, color: color);
}
