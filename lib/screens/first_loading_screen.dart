import 'package:flutter/material.dart';
import 'post_preference_report.dart';

class FirstLoadingScreen extends StatefulWidget {
  final List<Map<String, String>> selectedItems; // 추가

  const FirstLoadingScreen({
    super.key,
    required this.selectedItems, // 추가
  });

  @override
  State<FirstLoadingScreen> createState() => _FirstLoadingScreenState();
}

class _FirstLoadingScreenState extends State<FirstLoadingScreen> {
  final List<String> _subTexts = [
    '선택 패턴을 분석하는 중입니다',
    '선호 스타일을 분류하는 중입니다',
    '취향 리포트를 생성하는 중입니다',
  ];

  int _subTextIndex = 0;
  String _displayedText = '';
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _startSequence();
  }

  Future<void> _startSequence() async {
    for (int i = 0; i < _subTexts.length; i++) {
      setState(() {
        _subTextIndex = i;
        _displayedText = '';
      });

      for (int j = 0; j < _subTexts[i].length; j++) {
        await Future.delayed(const Duration(milliseconds: 50));
        if (!mounted) return;
        setState(() {
          _displayedText = _subTexts[i].substring(0, j + 1);
          _progress = (i * _subTexts[i].length + j + 1) /
              (_subTexts.length * _subTexts[i].length);
        });
      }

      await Future.delayed(const Duration(milliseconds: 500));
    }

    setState(() => _progress = 1.0);
    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PostPreferenceReport(
          selectedItems: widget.selectedItems, // 넘기기
        ),
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
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _progress,
                  minHeight: 6,
                  backgroundColor: Colors.grey[200],
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
