// lib/screens/run_home_screen.dart

import 'package:flutter/material.dart'; // Flutter의 기본 UI 위젯들을 사용하기 위해 import
import 'package:firefit_app/app_theme_extension.dart'; // 우리가 정의한 커스텀 앱 테마 확장 (색상 정의)을 가져오기 위해 import
import 'package:intl/intl.dart'; // 날짜와 시간을 지역화된 형식으로 포맷팅하기 위한 국제화 패키지를 가져오기 위해 import

// RunHomeScreen 위젯을 StatefulWidget으로 정의.
// StatefulWidget은 내부 상태를 가질 수 있으며, 이 상태는 위젯의 생명주기 동안 변경될 수 있음.
class RunHomeScreen extends StatefulWidget {
  const RunHomeScreen({super.key}); // RunHomeScreen의 생성자. key를 부모 클래스에 전달.

  @override // 부모 클래스(StatefulWidget)의 createState 메서드를 오버라이드.
  State<RunHomeScreen> createState() => _RunHomeScreenState(); // 이 위젯의 상태를 관리할 _RunHomeScreenState 인스턴스를 생성하여 반환.
}

// RunHomeScreen의 상태를 관리하는 State 클래스.
// 이 클래스는 위젯의 변경 가능한 상태(예: 스크롤 위치, 데이터)와 UI를 정의하는 build 메서드를 포함.
class _RunHomeScreenState extends State<RunHomeScreen> {
  // _scrollController는 ListView의 스크롤 위치를 제어하는 객체.
  // 이 객체는 State가 생성될 때 한 번만 할당되고 변하지 않으므로 final로 선언.
  final ScrollController _scrollController = ScrollController();

  @override // 부모 클래스(State)의 initState 메서드를 오버라이드.
  void initState() { // State 객체가 생성되어 위젯 트리에 삽입될 때 단 한 번 호출되는 초기화 메서드.
    super.initState(); // 부모 클래스의 initState 메서드를 반드시 호출해야 함.

    // WidgetsBinding.instance.addPostFrameCallback은 위젯이 빌드되고 첫 프레임이 그려진 후 콜백 함수를 실행.
    // 이는 UI 렌더링이 완료된 후 스크롤 위치를 조정하는 것과 같이 UI에 영향을 주는 작업에 적합.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // itemTotalWidth는 컴파일 시점에 계산되는 상수이므로 const로 선언.
      const double itemTotalWidthForInit = 60.0 + (8.0 * 2); // 각 날짜 카드 하나의 총 너비 (컨테이너 60px + 좌우 내부 패딩 8px씩).
      // targetScrollOffset은 런타임에 계산되어 한 번 할당되므로 final로 선언.
      const double targetScrollOffset = (10 * itemTotalWidthForInit) - ((itemTotalWidthForInit * 7) / 2) + (itemTotalWidthForInit / 2); // 오늘 날짜(인덱스 10)가 화면 중앙에 오도록 초기 스크롤 위치를 계산.
      // _scrollController가 ListView에 정상적으로 연결되었는지 확인 후 jumpTo 메서드 호출 (안전성 강화).
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(targetScrollOffset); // 계산된 위치로 ListView를 즉시 스크롤.
      }
    });
  }

  @override // 부모 클래스(State)의 dispose 메서드를 오버라이드.
  void dispose() { // State 객체가 위젯 트리에서 영구적으로 제거될 때 호출되는 정리(cleanup) 메서드.
    _scrollController.dispose(); // _scrollController와 같이 직접 생성한 리소스는 메모리 누수 방지를 위해 반드시 해제해야 함.
    super.dispose(); // 부모 클래스의 dispose 메서드를 반드시 호출해야 함.
  }

  @override // 위젯의 UI를 구성하는 메서드. 이 메서드는 State가 변경될 때마다 다시 호출될 수 있음.
  Widget build(BuildContext context) { // BuildContext를 통해 위젯 트리의 위치 정보를 얻음.
    // appColors는 Theme.of(context)에 의존하여 런타임에 결정되므로 final로 선언.
    final AppColorsExtension appColors = Theme.of(context).extension<AppColorsExtension>()!;

    // now는 DateTime.now()로 런타임에 현재 시간이 결정되므로 final로 선언.
    final DateTime now = DateTime.now();
    // dates 리스트는 now 값에 의존하여 런타임에 생성되므로 final로 선언.
    final List<DateTime> dates = List.generate(21, (index) { // 총 21개의 DateTime 객체 리스트를 생성.
      return now.add(Duration(days: index - 10)); // 현재 날짜를 기준으로 앞/뒤 10일 (총 21일)의 날짜를 계산하여 리스트에 추가. (index 10이 오늘 날짜가 됨)
    });

    // mainHorizontalPadding은 컴파일 시점에 결정되는 상수값이므로 const로 선언.
    const double mainHorizontalPadding = 20.0;

    // itemTotalWidth는 컴파일 시점에 결정되는 상수 계산이므로 const로 선언.
    const double itemTotalWidth = 60.0 + (8.0 * 2); // 76.0

    return Scaffold( // 앱의 기본적인 시각적 구조를 제공하는 위젯 (앱바, 바디 등).
      backgroundColor: Colors.white, // Scaffold의 배경색을 흰색으로 설정. Colors.white는 const Color 생성자.
      body: SingleChildScrollView( // Scaffold의 바디 영역을 SingleChildScrollView로 감싸서, 내용이 화면을 넘어가면 세로 스크롤 가능하게 함.
        child: Padding( // SingleChildScrollView의 자식을 Padding으로 감싸서 전체 화면 내용에 좌우 패딩을 적용.
          padding: const EdgeInsets.symmetric(horizontal: mainHorizontalPadding), // EdgeInsets.symmetric는 인수가 const면 const 가능.
          child: Column( // 자식 위젯들을 세로 방향으로 배치하는 위젯.
            crossAxisAlignment: CrossAxisAlignment.start, // Column의 자식들을 시작점(왼쪽)으로 정렬.
            children: [ // Column의 자식 위젯 리스트.
              // SizedBox의 height는 MediaQuery.of(context).padding.top에 의존하여 런타임에 결정되므로 const 불가능.
              SizedBox(height: MediaQuery.of(context).padding.top + 20), // 상단 상태 바 높이만큼 공간을 확보하고 추가로 20px 더함 (세이프 에어리어).

              // Text 위젯의 모든 속성이 컴파일 시점에 결정되는 상수이므로 const로 선언.
              const Text( // "Hello," 텍스트 위젯.
                'Hello,', // 텍스트 내용.
                style: TextStyle( // 텍스트 스타일 지정. (이전 'const'가 불필요하게 붙었었음, 제거됨)
                  color: Colors.black, // 텍스트 색상 검정. Colors.black은 const Color 생성자.
                  fontSize: 24, // 폰트 크기 24.
                  fontWeight: FontWeight.normal, // 폰트 굵기 보통. FontWeight.normal은 const 값.
                ),
              ),
              // Text 위젯의 color가 appColors에 의존하여 런타임에 결정되므로 const 불가능.
              Text( // "Amara" 텍스트 위젯 (사용자 이름).
                'Amara', // 텍스트 내용.
                style: TextStyle( // 텍스트 스타일 지정. color가 런타임에 결정되므로 const 불가능.
                  color: appColors.primaryBlue, // 앱 테마의 primaryBlue 색상 적용.
                  fontSize: 36, // 폰트 크기 36.
                  fontWeight: FontWeight.bold, // 폰트 굵기 진하게. FontWeight.bold는 const 값.
                ),
              ),

              const SizedBox(height: 60), // SizedBox의 모든 인수가 const이므로 const 가능.

              // --- 요일/날짜 가로 스크롤 섹션 시작 ---
              Center( // 다음 SizedBox를 부모 공간 내에서 중앙에 정렬. Center는 const 생성자를 가짐.
                child: SizedBox( // 날짜 스크롤 섹션의 크기를 제한하는 위젯. SizedBox는 모든 인수가 const이면 const 가능.
                  height: 90, // 높이를 90px로 고정 (const).
                  width: itemTotalWidth * 7, // 너비를 7개 날짜 카드의 총 너비로 고정 (itemTotalWidth가 const이므로 이 계산 결과도 const).
                  child: ListView.builder( // 스크롤 가능한 리스트 뷰를 생성. controller가 런타임 객체이므로 ListView.builder는 const 불가능.
                    controller: _scrollController, // 위에서 생성한 _scrollController를 ListView에 연결.
                    scrollDirection: Axis.horizontal, // 스크롤 방향을 가로(수평)로 설정. Axis.horizontal은 const 값.
                    physics: const AlwaysScrollableScrollPhysics(), // 내용이 스크롤 공간을 채우지 못해도 항상 스크롤 가능하도록 강제. const 생성자.
                    padding: EdgeInsets.zero, // ListView 자체의 내부 패딩을 0으로 설정. EdgeInsets.zero는 const 값.
                    itemCount: dates.length, // ListView에 표시할 아이템의 총 개수. dates.length는 런타임에 결정되므로 const 불가능.
                    itemBuilder: (context, index) { // 각 아이템을 어떻게 그릴지 정의하는 콜백 함수.
                      // date, isToday는 런타임에 결정되는 값이므로 final로 선언.
                      final DateTime date = dates[index]; // 현재 인덱스에 해당하는 날짜 객체를 가져옴.
                      final bool isToday = date.day == now.day && // 현재 날짜가 오늘인지 확인 (날, 월, 년 모두 일치).
                                           date.month == now.month &&
                                           date.year == now.year;

                      return Padding( // 각 날짜 카드 주변에 패딩을 추가. Padding은 모든 인수가 const면 const 가능.
                        padding: const EdgeInsets.symmetric(horizontal: 8.0), // 좌우 8px씩 패딩 적용.
                        child: Column( // 패딩 안의 내용을 세로로 배치. children 내의 Container가 isToday에 따라 변하므로 Column 자체에 const 불가능.
                          mainAxisAlignment: MainAxisAlignment.center, // Column의 자식들을 세로 중앙으로 정렬. MainAxisAlignment.center는 const 값.
                          children: [ // Column의 자식 위젯 리스트.
                            Container( // 날짜 표시를 위한 컨테이너. decoration.color가 isToday에 따라 변하므로 Container 자체에 const 불가능.
                              width: 60, // 컨테이너 너비 60px (const).
                              height: 60, // 컨테이너 높이 60px (const).
                              decoration: BoxDecoration( // 컨테이너의 장식 (배경색, 테두리 등). color가 isToday에 따라 변하므로 const 불가능.
                                color: isToday ? appColors.primaryBlue : Colors.transparent, // 오늘 날짜면 primaryBlue, 아니면 투명.
                                borderRadius: BorderRadius.circular(15), // 모서리를 둥글게 (반지름 15px). BorderRadius.circular는 const 생성자이므로 const 가능.
                              ),
                              child: Column( // 컨테이너 안의 내용을 세로로 배치 (요일, 날짜 텍스트). children 내 Text의 color가 isToday에 따라 변하므로 const 불가능.
                                mainAxisAlignment: MainAxisAlignment.center, // 자식들을 세로 중앙으로 정렬. MainAxisAlignment.center는 const 값.
                                children: [ // Column의 자식 위젯 리스트.
                                  Text( // 요일 텍스트. style.color가 isToday에 따라 변하므로 const 불가능.
                                    DateFormat('EEE').format(date).toUpperCase(), // 날짜를 요일 형식(예: MON)으로 포맷하고 대문자로 변환. date는 런타임 값.
                                    style: TextStyle( // 텍스트 스타일 지정. color가 런타임에 결정되므로 const 불가능.
                                      color: isToday ? Colors.white : Colors.black, // 오늘 날짜면 흰색, 아니면 검정.
                                      fontWeight: FontWeight.bold, // 폰트 굵기 진하게. FontWeight.bold는 const 값.
                                      fontSize: 16, // 폰트 크기 16 (const).
                                    ),
                                  ),
                                  Text( // 날짜(일) 텍스트. style.color가 isToday에 따라 변하므로 const 불가능.
                                    DateFormat('dd').format(date), // 날짜를 일 형식(예: 01, 15)으로 포맷. date는 런타임 값.
                                    style: TextStyle( // 텍스트 스타일 지정. color가 런타임에 결정되므로 const 불가능.
                                      color: isToday ? Colors.white : Colors.black, // 오늘 날짜면 흰색, 아니면 검정.
                                      fontSize: 18, // 폰트 크기 18 (const).
                                      fontWeight: FontWeight.bold, // 폰트 굵기 진하게. FontWeight.bold는 const 값.
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              // --- 요일/날짜 가로 스크롤 섹션 끝 ---

              const SizedBox(height: 30), // SizedBox의 모든 인수가 const이므로 const 가능.
              // 여기에 이제 오늘의 달리기 요약 카드가 추가될 것입니다.
            ],
          ),
        ),
      ),
    );
  }
}