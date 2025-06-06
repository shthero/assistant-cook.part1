// lib/main.dart

import 'package:flutter/material.dart'; // Flutter UI를 구성하는 데 필요한 기본 위젯 제공
import 'package:flutter/foundation.dart'; // kDebugMode와 같은 디버그 관련 유틸리티 제공
import 'package:firefit_app/app_theme_extension.dart'; // 앱의 사용자 정의 테마 확장 (색상 등)
import 'package:firefit_app/screens/run_home_screen.dart'; // 로그인 성공 후 이동할 메인 화면
import 'package:firefit_app/screens/signup_screen.dart'; // 회원가입 화면
import 'package:http/http.dart' as http; // HTTP 요청을 보내기 위한 패키지
import 'dart:convert'; // JSON 데이터를 인코딩/디코딩하기 위한 유틸리티

void main() {
  // Flutter 앱의 시작점. MyApp 위젯을 실행합니다.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // 앱의 루트 위젯으로, 앱의 전반적인 테마와 시작 화면을 설정합니다.
  const MyApp({super.key});

  // 앱의 사용자 정의 색상 테마를 정의합니다. (AppColorsExtension에 정의되어 있을 것으로 예상)
  static const AppColorsExtension _appColors =
      AppColorsExtension.firefitAppColors;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FireFit App', // 앱의 제목 (Task Manager 등에서 표시될 수 있음)
      theme: ThemeData(
        // 앱의 전반적인 테마를 설정합니다.
        colorScheme: ColorScheme.fromSeed(
          // Material Design 3의 ColorScheme을 생성합니다.
          seedColor: _appColors.primaryBlue!, // 주요 색상으로 사용될 씨드 컬러
          secondary: _appColors.accentOrange!, // 보조 색상
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity, // 플랫폼에 따라 UI 밀도를 조절
        extensions: const <ThemeExtension<dynamic>>[
          _appColors
        ], // 앱의 사용자 정의 테마 확장(AppColorsExtension)을 추가
      ),
      home: const WelcomeScreen(), // 앱이 시작될 때 표시될 첫 번째 화면
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  // 앱의 시작 화면 위젯으로, 사용자가 로그인 또는 회원가입을 할 수 있도록 합니다.
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // 아이디 입력 필드의 텍스트를 제어하는 컨트롤러
  final TextEditingController _usernameController = TextEditingController();
  // 비밀번호 입력 필드의 텍스트를 제어하는 컨트롤러
  final TextEditingController _passwordController = TextEditingController();

  // 로그인 폼의 가시성을 제어하는 상태 변수. true면 폼이 보이고, false면 숨겨집니다.
  bool _showLoginForm = false;

  @override
  void dispose() {
    // 위젯이 제거될 때 컨트롤러를 해제하여 메모리 누수를 방지합니다.
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 로그인 폼의 가시성을 토글(켜고 끄는)하는 함수
  void _toggleLoginForm() {
    setState(() {
      _showLoginForm = !_showLoginForm; // _showLoginForm 상태를 반전시킵니다.
      // 폼이 닫힐 때(숨겨질 때) 입력 필드를 초기화합니다. (선택 사항)
      if (!_showLoginForm) {
        _usernameController.clear(); // 이메일 필드 초기화
        _passwordController.clear(); // 비밀번호 필드 초기화
      }
    });
  }

  // 백엔드로 로그인 요청을 보내는 비동기 함수
  Future<void> _handleLogin() async {
    final String username = _usernameController.text; // 아이디 입력 필드의 텍스트 가져오기
    final String password = _passwordController.text; // 비밀번호 입력 필드의 텍스트 가져오기

    // TODO: 실제 백엔드 API 엔드포인트 URL로 변경해야 합니다.
    // 백엔드 개발자와 소통하여 정확한 로그인 API 엔드포인트를 확인하세요.
    // 이 URL은 실제 서버의 로그인 API 엔드포인트여야 합니다.
    const String apiUrl =
        'https://port-0-fastapi-test2-m3qx1on5ed2e15a8.sel4.cloudtype.app'; // 예: 'https://api.yourdomain.com/login'

    try {
      // HTTP POST 요청을 통해 백엔드 로그인 API를 호출합니다.
      final response = await http.post(
        Uri.parse(apiUrl), // API URL을 Uri 객체로 파싱
        headers: <String, String>{
          // 요청 헤더 설정: JSON 형식으로 데이터를 보낼 것임을 알립니다.
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          // 요청 본문(body)을 JSON 형식으로 인코딩하여 보냅니다.
          "username": username, // 아이디 데이터
          "password": password, // 비밀번호 데이터
        }),
      );

      // 디버그 모드일 때만 콘솔에 로그를 출력합니다.
      if (kDebugMode) {
        print('로그인 시도: 아이디: $username, 비밀번호: $password');
        print('서버 응답 상태 코드: ${response.statusCode}'); // 서버 응답의 HTTP 상태 코드
        print('서버 응답 본문: ${response.body}'); // 서버 응답의 본문 내용
      }
      // 위젯이 여전히 마운트되어 있는지 확인하여 setState 호출 전에 안전성을 확보합니다.
      if (!mounted) return;

      // 서버 응답 상태 코드가 200 (OK)이면 로그인 성공으로 간주합니다.
      if (response.statusCode == 200) {
        // TODO: 백엔드 응답(예: 인증 토큰, 사용자 정보)을 파싱하여 저장하고 다음 화면으로 이동
        // 실제 앱에서는 여기서 JWT 토큰 등을 Secure Storage에 저장하는 로직이 추가됩니다.
        if (kDebugMode) {
          print('로그인 성공!');
        }
        _toggleLoginForm(); // 로그인 폼을 닫습니다.
        // `RunHomeScreen`으로 화면을 전환합니다. (로그인 후의 메인 화면)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RunHomeScreen()),
        );
      } else {
        // 로그인 실패 (예: 401 Unauthorized, 400 Bad Request 등)
        if (kDebugMode) {
          print('로그인 실패: ${response.body}');
        }
        // TODO: 사용자에게 실패 메시지를 보여주는 UI 업데이트
        // 실패 메시지를 다이얼로그로 표시합니다.
        _showErrorDialog('로그인 실패', '이메일 또는 비밀번호를 다시 확인해 주세요.');
      }
    } catch (e) {
      // 네트워크 오류 또는 기타 예외 발생 시 처리
      if (kDebugMode) {
        print('로그인 중 오류 발생: $e'); // 발생한 예외를 콘솔에 출력
      }
      // 네트워크 오류 메시지를 다이얼로그로 표시합니다.
      _showErrorDialog('네트워크 오류', '로그인 중 문제가 발생했습니다. 인터넷 연결을 확인해 주세요.');
    }
  }

  // 에러 메시지를 사용자에게 보여주는 다이얼로그를 띄웁니다. (선택 사항)
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title), // 다이얼로그 제목
          content: Text(message), // 다이얼로그 내용
          actions: <Widget>[
            TextButton(
              child: const Text('확인'), // 확인 버튼
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 현재 화면의 높이와 너비를 가져옵니다. 반응형 UI를 위해 사용됩니다.
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    // 앱의 사용자 정의 색상 테마를 가져옵니다.
    final AppColorsExtension appColors =
        Theme.of(context).extension<AppColorsExtension>()!;

    return Scaffold(
      body: Container(
        // 배경에 그라데이션을 적용합니다.
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [appColors.primaryBlue!, const Color(0xFF0D47A1)], // 그라데이션 색상
            begin: Alignment.topLeft, // 그라데이션 시작 방향
            end: Alignment.bottomRight, // 그라데이션 끝 방향
          ),
        ),
        child: SafeArea(
          // 노치 디자인이나 상태 바 영역을 피하여 안전한 영역에 UI를 배치합니다.
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0), // 좌우 패딩
            child: Center(
              child: Column(
                // 자식 위젯들을 세로로 배열합니다.
                mainAxisAlignment: MainAxisAlignment.end, // 메인 축(세로) 끝에 정렬
                crossAxisAlignment: CrossAxisAlignment.center, // 교차 축(가로) 중앙에 정렬
                children: [
                  SizedBox(height: screenHeight * 0.3), // 화면 높이의 30%만큼 공간
                  const Icon(
                    Icons.local_fire_department, // 불꽃 아이콘
                    color: Colors.deepOrange, // 아이콘 색상
                    size: 120, // 아이콘 크기
                  ),
                  const Text(
                    'FIREFIT', // 앱 이름 텍스트
                    style: TextStyle(
                      color: Colors.white, // 텍스트 색상
                      fontSize: 48, // 폰트 크기
                      fontWeight: FontWeight.bold, // 폰트 굵기
                      letterSpacing: 2, // 자간
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05), // 화면 높이의 5%만큼 공간
                  Text(
                    'Stay in shape, stay healthy', // 슬로건 텍스트
                    style: TextStyle(
                      color: appColors.lightGray, // 텍스트 색상
                      fontSize: 18, // 폰트 크기
                    ),
                    textAlign: TextAlign.center, // 텍스트 중앙 정렬
                  ),

                  const Spacer(), // 이곳에 Spacer 추가: 사용 가능한 공간을 모두 차지하여 아래 위젯들을 하단에 밀어냅니다.

                  Align(
                    alignment: Alignment.bottomCenter, // 하단 중앙에 정렬
                    child: Stack(
                      // 위젯들을 겹쳐서 배치합니다.
                      alignment: Alignment.center, // 스택 내부 위젯들을 중앙에 정렬
                      children: [
                        Column(
                          // 회원가입 및 로그인 버튼을 세로로 배열합니다.
                          mainAxisSize: MainAxisSize.min, // 컬럼의 크기를 자식들의 최소 크기에 맞춥니다.
                          children: [
                            SizedBox(
                              width: screenWidth * 0.3, // 화면 너비의 30%만큼 너비
                              height: 50, // 버튼 높이
                              child: ElevatedButton(
                                onPressed: () {
                                  // 회원가입 버튼 클릭 시
                                  if (kDebugMode) {
                                    print('Sign Up button pressed!'); // 디버그 로그
                                  }
                                  // `SignUpScreen`으로 화면을 전환합니다.
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUpScreen()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      appColors.accentOrange, // 버튼 배경색
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        25), // 둥근 모서리 버튼
                                  ),
                                  elevation: 5, // 그림자 효과
                                ),
                                child: const Text(
                                  'Sign Up', // 버튼 텍스트
                                  style: TextStyle(
                                    color: Colors.white, // 텍스트 색상
                                    fontSize: 18, // 폰트 크기
                                    fontWeight: FontWeight.bold, // 폰트 굵기
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15), // 버튼 사이 간격
                            SizedBox(
                              width: screenWidth * 0.3, // 화면 너비의 30%만큼 너비
                              height: 50, // 버튼 높이
                              child: ElevatedButton(
                                onPressed: () {
                                  // 로그인 버튼 클릭 시
                                  if (kDebugMode) {
                                    print('Login button pressed!'); // 디버그 로그
                                  }
                                  _toggleLoginForm(); // 로그인 폼을 토글하여 표시/숨김
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white, // 버튼 배경색
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        25), // 둥근 모서리 버튼
                                  ),
                                  elevation: 5, // 그림자 효과
                                ),
                                child: Text(
                                  'Login', // 버튼 텍스트
                                  style: TextStyle(
                                    color: appColors.accentOrange, // 텍스트 색상
                                    fontSize: 18, // 폰트 크기
                                    fontWeight: FontWeight.bold, // 폰트 굵기
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.05), // 하단 여백
                          ],
                        ),
                        // 로그인 폼 (AnimatedOpacity와 Visibility로 애니메이션 및 가시성 제어)
                        AnimatedOpacity(
                          opacity: _showLoginForm ? 1.0 : 0.0, // _showLoginForm 상태에 따라 투명도 조절
                          duration: const Duration(milliseconds: 300), // 애니메이션 지속 시간
                          child: Visibility(
                            visible: _showLoginForm, // _showLoginForm 상태에 따라 폼 가시성 제어
                            maintainState: true, // 폼이 숨겨져도 상태 유지
                            maintainAnimation: true, // 폼이 숨겨져도 애니메이션 유지
                            maintainSize: true, // 폼이 숨겨져도 레이아웃 공간 유지
                            child: Center(
                              child: Container(
                                width: screenWidth * 0.7, // 화면 너비의 70%만큼 너비
                                padding: const EdgeInsets.all(24.0), // 내부 패딩
                                decoration: BoxDecoration(
                                  color: Colors.white, // 배경색
                                  borderRadius:
                                      BorderRadius.circular(20), // 둥근 모서리
                                  boxShadow: const [
                                    // 그림자 효과
                                    BoxShadow(
                                      color: Color.fromRGBO(0, 0, 185, 0.3), // 그림자 색상 (투명도 포함)
                                      spreadRadius: 5, // 그림자 확산 반경
                                      blurRadius: 6, // 그림자 흐림 정도
                                      offset: Offset(0, 3), // 그림자 오프셋 (x, y)
                                    ),
                                  ],
                                ),
                                child: Column(
                                  // 로그인 폼 내부 위젯들을 세로로 배열
                                  mainAxisSize: MainAxisSize.min, // 컬럼의 크기를 자식들의 최소 크기에 맞춥니다.
                                  children: <Widget>[
                                    Text(
                                      '로그인', // 폼 제목
                                      style: TextStyle(
                                        color: appColors.primaryBlue, // 텍스트 색상
                                        fontWeight: FontWeight.bold, // 폰트 굵기
                                        fontSize: 22, // 폰트 크기
                                      ),
                                    ),
                                    const SizedBox(height: 20), // 간격
                                    TextField(
                                      controller:
                                          _usernameController, // 이메일 입력 필드 컨트롤러
                                      decoration: InputDecoration(
                                        labelText: '아이디 (이메일)', // 레이블 텍스트
                                        labelStyle: TextStyle(
                                            color: appColors
                                                .primaryBlue), // 레이블 텍스트 색상
                                        enabledBorder: OutlineInputBorder(
                                          // 기본 테두리
                                          borderSide: BorderSide(
                                              color: appColors
                                                  .primaryBlue!), // 테두리 색상
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          // 포커스 시 테두리
                                          borderSide: BorderSide(
                                              color: appColors
                                                  .accentOrange!), // 테두리 색상
                                        ),
                                      ),
                                      keyboardType: TextInputType
                                          .emailAddress, // 이메일 입력에 적합한 키보드 타입
                                    ),
                                    const SizedBox(height: 15), // 간격
                                    TextField(
                                      controller:
                                          _passwordController, // 비밀번호 입력 필드 컨트롤러
                                      decoration: InputDecoration(
                                        labelText: '비밀번호', // 레이블 텍스트
                                        labelStyle: TextStyle(
                                            color: appColors
                                                .primaryBlue), // 레이블 텍스트 색상
                                        enabledBorder: OutlineInputBorder(
                                          // 기본 테두리
                                          borderSide: BorderSide(
                                              color: appColors
                                                  .primaryBlue!), // 테두리 색상
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          // 포커스 시 테두리
                                          borderSide: BorderSide(
                                              color: appColors
                                                  .accentOrange!), // 테두리 색상
                                        ),
                                      ),
                                      obscureText: true, // 비밀번호를 *로 표시
                                    ),
                                    const SizedBox(height: 20), // 간격
                                    TextButton(
                                      onPressed: () {
                                        // 비밀번호 찾기 버튼 클릭 시
                                        if (kDebugMode) {
                                          print(
                                              'Forgot password pressed (in dialog)!'); // 디버그 로그
                                        }
                                        // TODO: 비밀번호 찾기 로직 추가
                                        // 실제로는 비밀번호 재설정 화면으로 이동하거나 API 호출
                                      },
                                      child: Text(
                                        'Forgot your password?', // 텍스트
                                        style: TextStyle(
                                          color: appColors.primaryBlue, // 텍스트 색상
                                          fontSize: 16, // 폰트 크기
                                          decoration: TextDecoration
                                              .underline, // 밑줄 효과
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10), // 간격
                                    Row(
                                      // 취소 및 로그인 버튼을 가로로 배열
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround, // 버튼들을 균등하게 분배
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            _toggleLoginForm(); // 로그인 폼 닫기
                                          },
                                          child: Text(
                                            '취소', // 취소 버튼 텍스트
                                            style: TextStyle(
                                                color: appColors
                                                    .primaryBlue), // 텍스트 색상
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed:
                                              _handleLogin, // 로그인 처리 함수 호출
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                appColors.accentOrange, // 버튼 배경색
                                            foregroundColor:
                                                Colors.white, // 버튼 텍스트 색상
                                          ),
                                          child: const Text('로그인'), // 로그인 버튼 텍스트
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}