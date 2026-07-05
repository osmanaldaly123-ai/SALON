import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SalonShadTheme {
  SalonShadTheme._();

  static const Color primary = Color(0xFF6B4EFF);
  static const double radius = 12;

  static ShadThemeData get light => ShadThemeData(
        brightness: Brightness.light,
        colorScheme: const ShadVioletColorScheme.light(
          primary: primary,
          ring: primary,
        ),
        radius: BorderRadius.all(Radius.circular(radius)),
      );
}
