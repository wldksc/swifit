import 'package:flutter/material.dart';
import 'post_preference_report.dart';

class FirstLoadingScreen extends StatefulWidget {
  const FirstLoadingScreen({super.key});

  @override
  State<FirstLoadingScreen> createState() => _FirstLoadingScreenState();
}

class _FirstLoadingScreenState extends State<FirstLoadingScreen> {
  final List<String> _subTexts = [
    '선택 패턴을 분석하는 중입니다',
    '선호 스타일을 분류하는 중입니다',
    '취향 리포트를 생성하는 중입니다',
  ];

  int _subTextIndex = 0; // 현재 몇 번째 문구인지
  String _displayedText = ''; // 현재 화면에 보이는 텍스트
  double _progress = 0.0; // 로딩바 진행도 (0.0 ~ 1.0)

  @override
  void initState() {
    super.initState();
    _startSequence();
  }

  Future<void> _startSequence() async {
     // 3개 문구를 순서대로 타이핑
    for (int i = 0; i < _subTexts.length; i++) {
      setState(() {
        _subTextIndex = i;
        _displayedText = '';
      });

      // 타이핑 효과
      for (int j = 0; j < _subTexts[i].length; j++) {
        await Future.delayed(const Duration(milliseconds: 50));
        if (!mounted) return;
        setState(() {
          _displayedText = _subTexts[i].substring(0, j + 1);
          _progress = (i * _subTexts[i].length + j + 1) /
              (_subTexts.length * _subTexts[i].length);
        });
      }

      // 문구 다 타이핑되면 잠깐 대기
      await Future.delayed(const Duration(milliseconds: 500));
    }

    // 로딩바 100% 확실히 채우기 
    setState(() => _progress = 1.0);
    await Future.delayed(const Duration(milliseconds: 300));

    // 다음 화면으로 이동
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const PostPreferenceReport(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 메인 문구 (고정)
              const Text(
                '당신의 취향을 분석하는 중입니다',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // 서브 문구 (타이핑 효과)
              SizedBox(
                height: 20,
                child: Text(
                  _displayedText,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 24),

              // 로딩바
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _progress,
                  minHeight: 6,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
