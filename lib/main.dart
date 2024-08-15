import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'main_page_model.dart';
import 'formpage.dart';
import 'dart:math';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SelectedDays()),
        ChangeNotifierProvider(create: (context) => MainPageModel(50)),
        ChangeNotifierProvider(create: (context) => SelectedModeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'MemoApp',
      home: MyAppPage(),
    );
  }
}

class MyAppPage extends StatefulWidget {
  const MyAppPage({super.key});

  @override
  MyAppPageState createState() => MyAppPageState();
}

class MyAppPageState extends State<MyAppPage> {
  int _selectedIndex = 1;

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedModeProvider = Provider.of<SelectedModeProvider>(context);

    List<Widget> _navIndex = [
      FoodPage(mode: selectedModeProvider.selectedMode),
      MainPage(
        namename: 'hi',
        ageage: 23,
        height: 170,
        weight: 50,
        willw: 40,
        mode: selectedModeProvider.selectedMode,
      ),
      const DayPage(),
    ];

    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: IndexedStack(
        index: _selectedIndex,
        children: _navIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xffF2F2F2),
        selectedItemColor: Color.fromARGB(255, 57, 97, 55),
        unselectedItemColor: const Color.fromARGB(255, 23, 42, 31),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            label: '오늘의 식단',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'HQ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: '월경',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
      ),
    );
  }
}

// 식단 페이지 시작하는 곳
class FoodPage extends StatelessWidget {
  final String mode;

  FoodPage({required this.mode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DietScreen(mode: mode),
    );
  }
}

class DietScreen extends StatefulWidget {
  final String mode;

  DietScreen({required this.mode});

  @override
  _DietScreenState createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen>
    with AutomaticKeepAliveClientMixin {
  String? breakfastSelection;
  String? lunchSelection;
  String? dinnerSelection;
  int? totalCalories;

  final Map<String, int> breakfastCalories = {
    '그릭요거트 1컵, 블루베리 반컵, 아몬드 10알': 210,
    '통밀 토스트 2장, 아보카도 반개, 계란 1개, 스무디': 500,
    '스무디 한 잔, 토스트 1개': 311,
    '밥, 미역국, 김치, 계란 후라이, 나물무침': 490,
    '토스트, 스크램블 에그, 베이컨, 오렌지 주스': 530,
    '시리얼, 우유, 바나나': 365,
    '오트밀 반컵, 아몬드 우유 1컵, 바나나 반개': 300,
    '오트밀, 베리류, 그릭 요거트': 301,
    '시리얼, 우유 바나나': 366,
    '스무디(케일, 아보카도, 아몬드밀크, 스피니치)': 321,
    '삶은 계란 2개, 아보카도토스트': 302,
    '베이컨 3줄, 계란 3개, 오믈렛 팬케이크': 800,
    '땅콩버터 바나나 토스트 (통밀빵2장) 그릭 요거트': 806,
    '시금치 오믈렛(계란 2개,시금치,토마토)': 322,
    '베리와 아몬드 밀크 스무디': 303,
    '통밀 토스트(아보카도,훈제 연어) 그릭요거트': 501,
    '베이컨과 계란 통밀 팬케이크(메이플시럽)': 796,
    '그릭 요거트 볼(견과류,꿀,베리류)': 756,
    '오트밀 치즈 아보카도': 325,
    '치아 씨드 푸딩과 혼합 베리': 258,
    '식빵 2장, 저지방우유, 달걀 1개, 양배추 샐러드, 자몽 1개': 555,
    '삶은 계란 2개, 당근 1개': 164,
    '흑미밥, 오이무침, 근대국, 어묵볶음': 360,
    '블루베리샌드위치, 딸기우유': 450,
    '오트, 바나나, 블루베리, 견과류, 프로틴파우더': 825,
    '에그 화이트 오믈렛, 토스트': 577,
    '스무디 볼(그릭 요거트, 과일, 그래놀라, 아몬드 버터 등)': 605,
    '모닝빵, 포도주스': 248,
    '빵, 해쉬브라운, 스크램블에그': 432,
    '샐러드 (드레싱 제외, 약 100g), 계란(1개), 견과류 (한 줌, 약 28g)': 285,
    '샐러드(드레싱 제외, 약 100g), 당근키위레몬주스(1잔, 약 250ml)': 180,
    '고구마 (100g), 토마토 (100g), 파프리카 (100g), 오이 (100g)': 154,
    '현미밥(1공기, 약 200g), 닭가슴살(100g), 시금치(100g,조리후), 방울토마토(100g), 사과(중간 크기 1개, 약 182g)':
        521,
    '고구마 (100g), 견과류(한 줌, 약 28g), 두유': 385,
    '호밀빵 (1조각, 약 40g), 닭가슴살(100g), 야채샐러드(드레싱 제외, 약 100g)': 306,
    '통곡물시리얼(1인분, 약 30g), 닭가슴살 (100g), 야채샐러드(드레싱 제외, 약 100g)': 325
  };

  final Map<String, int> lunchCalories = {
    '닭가슴살 샐러드': 310,
    '치킨 샌드위치, 샐러드, 퀴노아': 700,
    '참치 샐러드': 270,
    '렌틸콩 수프와 통밀빵': 320,
    '터키와 아보카도 랩': 330,
    '닭가슴살과 채소 볶음': 370,
    '비빔밥': 530,
    '짜장면': 675,
    '토마토 베이컨 샌드위치': 405,
    '현미밥, 구운 야채, 닭가슴살': 445,
    '맥도날드 빅맥': 730,
    '버거킹 와퍼': 630,
    '수제치즈버거': 620,
    '로스트 치킨 두 조각, 음료': 590,
    '치킨 텐더 다섯 조각, 음료': 790,
    '초코케이크 한 조각, 우유': 570,
    '타코 샐러드': 489,
    '칠면조와 아보카도 샌드위치': 511,
    '병아리콩 샐러드': 403,
    '연어 샐러드': 701,
    '현미밥, 닭가슴살 샐러드, 백김치, 단호박찜': 689,
    '잡곡밥, 된장국, 삼치구이, 콩나물, 배추김치': 495,
    '백미밥 1공기, 버터생선구이': 490,
    '김치, 돼지고기, 쌀밥': 433,
    '소불고기덮밥, 된장국, 밥, 김치': 721,
    '부대찌개, 김치, 쌀밥': 833,
    '버터김치볶음밥': 624,
    '밥, 청경채볶음, 무말랭이무침': 576,
    '김치돈까스덮밥': 790,
    '병아리콩밥, 미역국, 불고기, 김치전': 502,
    '쌀밥, 시골우거지국, 표고두부조림': 665,
    '육개장칼국수': 654,
    '쌀밥, 콩비지찌개': 660,
    '해물찜볶음밥': 600,
    '불고기또띠아': 430,
    '치킨마요덮밥': 924,
    '밥, 오징어당면볶음, 김치': 795,
    '소고기 스테이크, 현미밥, 아스파라거스': 947,
    '연어 스테이크, 퀴노아, 시금치 샐러드': 803,
    '칠리 콘 카르네, 통곡물 빵, 혼합 채소': 631,
    '현미밥, 구운 채소': 409,
    '훈제오리구이, 밥, 김치': 690,
    '잔치국수, 씨앗호떡': 645,
    '밥, 오징어무국, 동그랑땡전, 무생체': 751,
    '단호박카레라이스, 얼큰 김칫국, 나쵸샐러드': 1265,
    '버터볶음밥, 떡갈비, 해쉬브라운': 870,
    '밥, 갈비탕, 계란찜, 석박지': 1000,
    '계란스크램블, 사과, 우유, 견과류': 555,
    '식빵, 우유, 시리얼, 군 고구마': 440,
    '고구마, 바나나2개, 닭가슴살, 야채샐러드': 629,
    '밥 (한 공기, 약 200g), 얼큰김칫국(1인분)': 407
  };

  final Map<String, int> dinnerCalories = {
    '돼지고기 스터프드 애호박': 426,
    '치킨과 브로콜리 볶음': 376,
    '고구마(1컵)와 아보카도(1/2) 샐러드': 456,
    '야채, 계란 2개, 닭가슴살 1팩, 프로틴우유': 661,
    '새우와 콜리플라워 라이스': 304,
    '터키 미트볼과 스파게티': 447,
    '연어와 브로콜리, 퀴노아': 598,
    '구운 닭가슴살(150g)과 구운 채소': 511,
    '닭고기(150g), 아스파라거스(134g) 구이': 398,
    '잡곡밥(150g),닭가슴살 야채 볶음 (100g),미소된장국 (200ml),김치 (50g),과일 샐러드 (100g)': 635,
    '구운 생선, 현미밥, 채소볶음': 572,
    '돼지 등심구이, 고구마, 혼합 채소': 649,
    '닭가슴살 스테이크 , 감자, 브로콜리': 579,
    '소고기 스테이크, 감자, 아스파라거스': 787,
    '치즈 오믈렛(계란 3개,체다 치즈 30g), 샐러드(혼합 샐러드 (상추, 방울토마토 등) 100g,발사믹 드레싱 1큰술)': 405,
    '비빔밥(현미밥 100g,나물 (시금치, 콩나물 등) 100g,계란 1개,고추장 1큰술,참기름 1작은술)': 302,
    '해산물 파스타(통밀 파스타 75g,새우와 오징어 150g,토마토 소스 100g ,파마산 치즈 20g)': 603,
    '불고기와 쌈 채소(소고기 불고기 150g, 쌈 채소,현미밥 100g,고추장 소스 1큰술)': 483,
    '채소 볶음밥(현미밥,계란 1개,혼합 채소 100g,간장 1큰술,참기름 1작은술)': 290,
    '토마토 바질 파스타 (150g),그릭 샐러드 (100g),구운 가지와 호박 (100g),딸기 (100g),저지방 그릭 요거트 (100g)':
        666,
    '새우 볶음밥 (150g),시저 샐러드 (100g),찐 아스파라거스 (100g),파인애플 (100g),저지방 우유 (200ml)':
        658,
    '참치 스테이크 (150g),퀴노아와 아보카도 샐러드 (150g),찐 당근과 완두콩 (100g),포도 (100g),저지방 요거트 (100g)':
        651,
    '치킨 파마산 (150g),시금치 샐러드 (100g),로스트 감자 (150g),키위 (2개)': 653,
    '쇠고기 파스타 볼로네제 (150g),시저 샐러드 (100g),구운 가지 (100g),블루베리 (100g)': 659,
    '쇠고기 스튜 (200g),매쉬드 포테이토 (150g),찐 브로콜리 (100g),혼합 과일 샐러드 (100g),다크 초콜릿 (20g)':
        668,
    '닭고기 파히타 (2개),참나물 샐러드 (100g),구운 감자 웨지 (100g),파인애플 (100g)': 653,
    '토마토 소스 스파게티 (150g),케일 샐러드 (100g),구운 버섯 (100g),베리 믹스 (100g),저지방 치즈 (50g)':
        660,
    '비프 타코 (2개),멕시칸 콜슬로 (100g),구운 옥수수 (100g),망고 슬라이스 (100g)': 657,
    '치킨 커리 (200g),현미밥 (150g),오이무침 (50g),요구르트 (100g)': 660,
    '파스타 카르보나라 통밀면 (150g),그린 샐러드 (100g),구운 마늘빵 (50g),사과 (1개)': 652,
    '잡곡밥 (150g),갈비찜 (150g),도라지 무침 (50g),미역오이냉국,무말랭이,': 655,
    '현미밥 (150g),브로콜리 찜 (100g),황태국,구운 감자 (100g)': 652,
    '현미밥, 구운 치킨, 브로콜리, 구운 생선': 800,
    '구운 닭다리(200g),현미밥(1컵),스팀드 채소': 805,
    '두부 스테이크, 구운 채소': 401
  };

  @override
  void initState() {
    super.initState();
    recommendDiet(widget.mode);
  }

  String randomSelectFood(Map<String, int> caloriesMap, Random random) {
    List<String> keys = caloriesMap.keys.toList();
    return keys[random.nextInt(keys.length)];
  }

  void recommendDiet(String mode) {
    Random random = Random();

    breakfastSelection = randomSelectFood(breakfastCalories, random);
    int breakfastTotal = breakfastCalories[breakfastSelection]!;

    lunchSelection = randomSelectFood(lunchCalories, random);
    int lunchTotal = lunchCalories[lunchSelection]!;

    dinnerSelection = randomSelectFood(dinnerCalories, random);
    int dinnerTotal = dinnerCalories[dinnerSelection]!;

    totalCalories = breakfastTotal + lunchTotal + dinnerTotal;

    // 모드별로 칼로리 범위 체크
    if (mode == '다이어트' && totalCalories! >= 1500) {
      recommendDiet(mode);
      return;
    } else if (mode == '유지' &&
        (totalCalories! < 1800 || totalCalories! > 2000)) {
      recommendDiet(mode);
      return;
    } else if (mode == '근력 증진' && totalCalories! <= 2300) {
      recommendDiet(mode);
      return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final selectedModeProvider = Provider.of<SelectedModeProvider>(context);

    super.build(context);
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      appBar: AppBar(
        backgroundColor: Color(0xffF2F2F2),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              recommendDiet(selectedModeProvider.selectedMode);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(87, 166, 98, 1),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: Offset(0, 0),
                  ),
                ],
                borderRadius: BorderRadius.circular(15),
                color: Color.fromARGB(255, 104, 171, 107),
              ),
              padding: EdgeInsets.all(30.0),
              child: Center(
                child: Text(
                  "Today's Menu",
                  style: TextStyle(
                      fontSize: 35.0,
                      fontFamily: "AppleL",
                      color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 30),
            if (breakfastSelection != null &&
                lunchSelection != null &&
                dinnerSelection != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Color.fromRGBO(109, 221, 124, 1)),
                      alignment: Alignment(0.0, 0.0),
                      child: Text("B",
                          style: TextStyle(
                              fontSize: 40,
                              fontFamily: "AppleL",
                              color: Colors.white)),
                      height: 100,
                      width: 100,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.9),
                            spreadRadius: 7,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(7),
                      child: Text(' $breakfastSelection',
                          style: TextStyle(fontSize: 20.0), softWrap: true),
                      height: 100,
                      width: 260,
                      margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
                    ),
                  ]),
                  Row(children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Color.fromRGBO(109, 221, 124, 1)),
                      alignment: Alignment(0.0, 0.0),
                      child: Text("L",
                          style: TextStyle(
                              fontSize: 40,
                              fontFamily: "AppleL",
                              color: Colors.white)),
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      height: 100,
                      width: 100,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.9),
                            spreadRadius: 7,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(7),
                      child: Text(' $lunchSelection',
                          style: TextStyle(fontSize: 20.0), softWrap: true),
                      margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
                      height: 100,
                      width: 260,
                    ),
                  ]),
                  Row(children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Color.fromRGBO(109, 221, 124, 1)),
                      alignment: Alignment(0.0, 0.0),
                      child: Text("D",
                          style: TextStyle(
                              fontSize: 40,
                              fontFamily: "AppleL",
                              color: Colors.white)),
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      height: 100,
                      width: 100,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.9),
                            spreadRadius: 7,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(7),
                      child: Text(' $dinnerSelection',
                          style: TextStyle(fontSize: 20.0), softWrap: true),
                      margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
                      height: 100,
                      width: 260,
                    ),
                  ]),
                  const SizedBox(height: 40),
                  Container(
                    child: Center(
                      child: Text(
                        '총 칼로리: $totalCalories kcal',
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

// 메인 페이지 시작하는 곳
class MainPage extends StatefulWidget {
  const MainPage(
      {super.key,
      required this.namename,
      required this.ageage,
      required this.height,
      required this.weight,
      required this.willw,
      required this.mode});

  final String namename;
  final int ageage;
  final int height;
  final int weight;
  final int willw;
  final String mode;
  @override
  State<MainPage> createState() => MainState();
}

class MainState extends State<MainPage> {
  late String namename;
  late int ageage;
  late int height;
  late int weight;
  late int willw;
  late String mode;

  @override
  void initState() {
    super.initState();
    namename = widget.namename;
    ageage = widget.ageage;
    height = widget.height;
    weight = widget.weight;
    willw = widget.willw;
    mode = widget.mode;
  }

  Future<void> _updateUserInfo(BuildContext context) async {
    final updatedInfo = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserFormPage(onModeChanged: (String newMode) {
          setState(() {
            mode = newMode;
          });
        }),
      ),
    );

    if (updatedInfo != null) {
      setState(() {
        namename = updatedInfo['name'];
        ageage = updatedInfo['age'];
        height = updatedInfo['height'];
        weight = updatedInfo['weight'];
        willw = updatedInfo['goalWeight'];
        mode = updatedInfo['mode'];
      });
    }
  }

  String _selectedDuration = '30분';
  final List<String> _durations = ['30분', '60분', '90분'];
  String? selectedOption = 'outdoor';
  MainState();

  get updateMode => null;

  @override
  Widget build(BuildContext context) {
    final userWeight = Provider.of<MainPageModel>(context).weight;
    final _selectedDays = Provider.of<SelectedDays>(context).selectedDays;
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      appBar: AppBar(
        backgroundColor: Color(0xffF2F2F2),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: const CircleAvatar(),
              accountName: Text('${namename},(${ageage})'),
              accountEmail: Text('${height},${weight}'),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 106, 140, 105),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
            ),
            ListTile(
              title: const Text('수정하기'),
              onTap: () async {
                await _updateUserInfo(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        UserFormPage(onModeChanged: (String newMode) {
                      setState(() {
                        updateMode(newMode);
                      });
                    }),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 7,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                width: 450,
                height: 500,
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 75, 50, 0),
                      alignment: Alignment(-1.0, 0.0),
                      child: Text(
                        "더 건강한 나로!",
                        style:
                            const TextStyle(fontSize: 50, fontFamily: "AppleL"),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 0, 50, 3),
                      alignment: Alignment(-1.0, 0.0),
                      child: Text(
                        "목표까지 ${weight - willw}kg 남았어요",
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 90, 0, 0),
                      width: 200,
                      height: 200,
                      child: Image.asset(
                        'font/namu.gif',
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 7,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  width: 450,
                  height: 500,
                  margin: const EdgeInsets.all(10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          alignment: Alignment(-1.0, 1.0),
                          margin: EdgeInsets.fromLTRB(10, 30, 0, 0),
                          padding: EdgeInsets.all(0),
                          child: Text(
                            "운동 시간 선택",
                            style:
                                TextStyle(fontSize: 50, fontFamily: "AppleL"),
                          ),
                        ),
                        const SizedBox(height: 20),
                        DropdownButton<String>(
                          value: _selectedDuration,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedDuration = newValue!;
                            });
                          },
                          items: _durations
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        Container(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                RadioListTile(
                                    activeColor:
                                        Color.fromRGBO(28, 125, 55, 0.992),
                                    title: const Text('야외 운동'),
                                    value: 'outdoorexercise',
                                    groupValue: selectedOption,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedOption = 'outdoorexercise';
                                      });
                                    }),
                                RadioListTile(
                                    activeColor:
                                        Color.fromRGBO(28, 125, 55, 0.992),
                                    title: const Text('실내 운동'),
                                    value: 'indoorexercise',
                                    groupValue: selectedOption,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedOption = 'indoorexercise';
                                      });
                                    }),
                              ],
                            )),
                        Container(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 3, 199, 90),
                              surfaceTintColor: Color.fromARGB(255, 3, 199, 90),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              int selectedDuration = int.parse(
                                  _selectedDuration.replaceAll('분', ''));

                              Map<String, double> outdoor = {
                                '축구': 7.0,
                                '야구': 6.9,
                                '필라테스': 3.0,
                                '복싱': 10.0,
                                '수영': 7.0,
                                '요가': 2.5,
                                '테니스': 6.5,
                                '배구': 6.0,
                                '탁구': 4.0,
                                '등산': 6.0,
                                '농구': 6.0,
                                '배드민턴': 5.3
                              };
                              int countOutd = outdoor.length;
                              double outdoorKcal(
                                  double metOVal, int userWeight, int time) {
                                double burned =
                                    3.5 * metOVal * userWeight * time * 0.005;
                                return burned;
                              }

                              Map cardio = {
                                '느리게 걷기': 3.0,
                                '달리기': 10.0,
                                '중간 속도로 걷기': 4.0,
                                '런닝머신': 8.3,
                                '줄넘기': 11.0,
                                '빠르게 걷기': 5.0,
                                '사이클': 8.0,
                                '계단오르기': 8.0
                              };
                              int countInd = cardio.length;
                              double indoorKcal(
                                  double metIVal, int userWeight, int time) {
                                double hour = time * 0.01667;
                                double burned =
                                    metIVal * userWeight * hour * 0.0175;
                                return burned;
                              }

                              List weighttraining = [
                                '레그익스텐션',
                                '레그컬',
                                '레그프레스',
                                '힙어브덕션',
                                '바벨컬',
                                '벤치딥',
                                '체스트프레스',
                                '렛풀다운',
                                '플라이',
                                '암컬',
                                '덤벨킥백',
                                '케이블푸시다운',
                                '버티컬 레그레이즈',
                                '숄더 프레스',
                                '케이블 컬',
                                '백 익스텐션',
                                '사이드 밴드',
                                '데드리프트',
                                '벤치 프레스',
                                '시티드 케이블 로우',
                                '스쿼트',
                                '윗몸일으키기'
                              ];
                              int countWei = weighttraining.length;
                              double weightKcal(int userWeight, int exertime) {
                                double burned = userWeight * exertime * 0.0637;
                                return burned;
                              }

                              double burnedCalories = 0;
                              List recommendedExercise = [];
                              DateTime today = DateTime.now();
                              // ignore: unused_local_variable
                              bool isTodaySelected =
                                  _selectedDays.contains(today);
                              // simulate user input
                              if (selectedOption == 'outdoorexercise') {
                                var randomO = Random().nextInt(countOutd);
                                double metOVal =
                                    outdoor.values.elementAt(randomO);
                                if (isTodaySelected = true) {
                                  while (metOVal >= 6.0) {
                                    randomO += 1;
                                    metOVal = outdoor.values
                                        .elementAt(randomO % countOutd);
                                    if (metOVal < 6.0) {
                                      break;
                                    }
                                  }
                                }
                                burnedCalories = outdoorKcal(
                                    metOVal, userWeight, selectedDuration);
                                recommendedExercise.insert(
                                    0, outdoor.keys.elementAt(randomO));
                              } else {
                                var randomI = Random().nextInt(countInd);
                                double metIVal =
                                    cardio.values.elementAt(randomI);
                                var randomH = Random().nextInt(countWei);
                                if (isTodaySelected = true) {
                                  while (metIVal >= 6.0) {
                                    randomI += 1;
                                    metIVal = cardio.values
                                        .elementAt(randomI % countInd);
                                    if (metIVal < 6.0) {
                                      break;
                                    }
                                  }
                                }
                                double expKcal = indoorKcal(metIVal, userWeight,
                                            selectedDuration) /
                                        2 +
                                    weightKcal(userWeight, selectedDuration) /
                                        2;
                                burnedCalories = expKcal;
                                recommendedExercise.insert(
                                    0, cardio.keys.elementAt(randomI));
                                recommendedExercise.insert(
                                    1, weighttraining[randomH]);
                              }

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('오늘의 운동 추천'),
                                    content: Text(
                                        '오늘의 운동: $recommendedExercise\n예상 소모 칼로리: ${burnedCalories.toStringAsFixed(2)} kcal'),
                                  );
                                },
                              );
                            },
                            child: const Text('오늘의 추천 운동'),
                          ),
                        )
                      ]))
            ],
          ),
        ),
      ),
    );
  }
}

// 월경 페이지 시작하는 곳
class DayPage extends StatefulWidget {
  const DayPage({super.key});

  @override
  _DayPageState createState() => _DayPageState();
}

class _DayPageState extends State<DayPage> {
  DateTime _focusedDay = DateTime.now();
  // ignore: unused_field
  DateTime? _selectedDay;
  final Set<DateTime> _selectedDays = {};

  void onDaySelected(selectedDay, focusedDay) {
    setState(() {
      if (_selectedDays.contains(selectedDay)) {
        _selectedDays.remove(selectedDay);
      } else {
        _selectedDays.add(selectedDay);
      }
      _focusedDay = focusedDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      appBar: AppBar(
        backgroundColor: Color(0xffF2F2F2),
        title: const Text('월경 달력'),
      ),
      body: Center(
        child: TableCalendar(
          headerStyle: HeaderStyle(formatButtonVisible: false),
          focusedDay: _focusedDay,
          firstDay: DateTime(2020),
          lastDay: DateTime(2030),
          selectedDayPredicate: (day) => _selectedDays.contains(day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              if (_selectedDays.contains(selectedDay)) {
                _selectedDays.remove(selectedDay);
              } else {
                _selectedDays.add(selectedDay);
              }
              _focusedDay = focusedDay;
            });
          },
          calendarStyle: const CalendarStyle(
            todayDecoration:
                const BoxDecoration(color: Color.fromARGB(255, 57, 97, 55)),
            selectedDecoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            selectedTextStyle: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class SelectedDays extends ChangeNotifier {
  final Set<DateTime> _selectedDays = {};
  Set<DateTime> get selectedDays => _selectedDays.toSet();

  void addDay(DateTime day) {
    _selectedDays.add(day);
    notifyListeners();
  }

  void removeDay(DateTime day) {
    _selectedDays.remove(day);
    notifyListeners();
  }
}
