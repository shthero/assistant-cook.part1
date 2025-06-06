// lib/app_theme_extension.dart
import 'package:flutter/material.dart';

@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  // 앱의 고유한 주요 색상 멤버 정의
  final Color? primaryBlue; // 어두운 파란색
  final Color? accentOrange;  // 강조 붉은색
  final Color? lightGray;  // 보조 텍스트 색상 (약간 투명한 밝은 회색)

  // 생성자
  const AppColorsExtension({
    required this.primaryBlue,
    required this.accentOrange,
    required this.lightGray,
  });

  // --- 여기에 앱의 실제 색상 값들을 가진 static const 인스턴스를 정의합니다! ---
  static const AppColorsExtension firefitAppColors = AppColorsExtension(
    primaryBlue: Color.fromARGB(255, 20, 60, 200), // 어두운 파란색의 실제 hex 값
    accentOrange: Color.fromARGB(255, 235, 70, 10), // 강조 붉은색의 실제 hex 값
    lightGray: Color(0xBFEEEEEE), // 밝은 회색의 실제 hex 값
  );
  // ----------------------------------------------------------------------


  // copyWith 메서드
  @override
  AppColorsExtension copyWith({
    Color? primaryBlue,
    Color? accentOrange,
    Color? lightGray,
  }) {
    return AppColorsExtension(
      primaryBlue: primaryBlue ?? this.primaryBlue,
      accentOrange: accentOrange ?? this.accentOrange,
      lightGray: lightGray ?? this.lightGray,
    );
  }

  // lerp (linear interpolation) 메서드
  @override
  AppColorsExtension lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) {
      return this;
    }
    return AppColorsExtension(
      primaryBlue: Color.lerp(primaryBlue, other.primaryBlue, t),
      accentOrange: Color.lerp(accentOrange, other.accentOrange, t),
      lightGray: Color.lerp(lightGray, other.lightGray, t),
    );
  }
}