// lib/screens/run_status_section.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firefit_app/app_theme_extension.dart'; // 이 임포트 줄은 그대로 유지

class RunStatusSection extends StatefulWidget {
  const RunStatusSection({super.key});

  @override
  State<RunStatusSection> createState() => _RunStatusSectionState();
}

class _RunStatusSectionState extends State<RunStatusSection> {
  @override
  Widget build(BuildContext context) {
    // 테마 확장을 가져옵니다.
    // 'AppThemeExtension'이 아니라 'AppColorsExtension'으로 변경합니다!
    final AppColorsExtension appColors = Theme.of(context).extension<AppColorsExtension>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // "Set course to run" 버튼
        ElevatedButton(
          onPressed: () {
            if (kDebugMode) {
              if (kDebugMode) {
                print('Set course to run 버튼 클릭!');
              }
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            backgroundColor: appColors.primaryBlue, // ✅ primaryBlue 사용
            foregroundColor: Colors.white, // 흰색 텍스트는 primaryBlue와 잘 어울려
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Set course to run',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 15),

        // "Free Course run" 버튼
        ElevatedButton(
          onPressed: () {
            if (kDebugMode) {
              print('Free Course run 버튼 클릭!');
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            backgroundColor: appColors.lightGray, // ✅ lightGray 사용
            foregroundColor: Colors.black, // lightGray 배경에 검은색 텍스트가 잘 보여
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Free Course run',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}