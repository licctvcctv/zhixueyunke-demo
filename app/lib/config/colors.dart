import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF4A90D9);
  static const Color primaryDark = Color(0xFF357ABD);

  static const List<Color> palette = [
    Color(0xFF4A90D9),
    Color(0xFF50C878),
    Color(0xFFFF6B6B),
    Color(0xFFFFB347),
    Color(0xFF87CEEB),
    Color(0xFFDDA0DD),
    Color(0xFF98D8C8),
    Color(0xFFF7DC6F),
  ];

  static Color fromId(dynamic id) {
    final index = id is int ? id : (int.tryParse(id.toString()) ?? 0);
    return palette[index % palette.length];
  }
}
