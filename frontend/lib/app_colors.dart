import 'package:flutter/material.dart';
import 'app_state.dart';

class AppColors {
  static const Color _boyBackground = Color(0xFFEFF6FF);
  static const Color _girlBackground = Color(0xFFFDF2F8);
  static const Color _neutralBackground = Color(0xFFFFFBEB);

  static const Color _boyTextAccent = Color(0xFF1D4ED8);
  static const Color _girlTextAccent = Color(0xFFBE185D);
  static const Color _neutralTextAccent = Color(0xFFB45309);

  static const Color _boyIconAccent = Color(0xFF3B82F6);
  static const Color _girlIconAccent = Color(0xFFEC4899);
  static const Color _neutralIconAccent = Color(0xFFF59E0B);

  static const Color _boyGradientEnd = Color(0xFF1D4ED8);
  static const Color _girlGradientEnd = Color(0xFFBE185D);
  static const Color _neutralGradientEnd = Color(0xFFD97706);

  static Color get background {
    if (AppState.childGender == 'boy') return _boyBackground;
    if (AppState.childGender == 'girl') return _girlBackground;
    return _neutralBackground;
  }

  static Color get textAccent {
    if (AppState.childGender == 'boy') return _boyTextAccent;
    if (AppState.childGender == 'girl') return _girlTextAccent;
    return _neutralTextAccent;
  }

  static Color get iconAccent {
    if (AppState.childGender == 'boy') return _boyIconAccent;
    if (AppState.childGender == 'girl') return _girlIconAccent;
    return _neutralIconAccent;
  }

  static Color get gradientEnd {
    if (AppState.childGender == 'boy') return _boyGradientEnd;
    if (AppState.childGender == 'girl') return _girlGradientEnd;
    return _neutralGradientEnd;
  }
}