// lib/screens/signup_screen.dart
import 'package:flutter/material.dart';
import 'package:firefit_app/app_theme_extension.dart'; // AppColorsExtension을 사용하기 위해 import

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // AppColorsExtension 인스턴스를 가져옴
    final AppColorsExtension appColors = Theme.of(context).extension<AppColorsExtension>()!;

    return Scaffold(
      backgroundColor: appColors.primaryBlue, // 테마 색상 적용
      appBar: AppBar(
        title: const Text('회원가입'),
        backgroundColor: appColors.primaryBlue, // 테마 색상 적용
        foregroundColor: Colors.white, // AppBar 텍스트 색상
      ),
      body: Center(
        child: Text(
          '여기는 회원가입 화면입니다!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: appColors.lightGray, // 테마 색상 적용
          ),
        ),
      ),
    );
  }
}