import 'package:flutter/material.dart';
import 'result_screen.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  int _currentIndex = 0;
  final Set<String> _selectedTags = {};
  int _likeCount = 0;
  double _dragX = 0;

  final List<Map<String, String>> cards = [
    {
      'image': 'assets/images/swipe1.jpg',
      'title': 'Minimal City Look',
      'subtitle': 'Cropped Denim Jacket & Wide Jeans',
      'style': '미니멀',
    },
    {
      'image': 'assets/images/swipe2.jpg',
      'title': 'Street Casual',
      'subtitle': 'Oversized Tee & Jogger Pants',
      'style': '스트리트',
    },
    {
      'image': 'assets/images/swipe3.jpg',
      'title': 'Classic Mood',
      'subtitle': 'Tailored Blazer & Slim Trousers',
      'style': '클래식',
    },
    {
      'image': 'assets/images/swipe4.jpg',
      'title': 'Daily Casual',
      'subtitle': 'Cotton Tee & Wide Denim',
      'style': '캐주얼',
    },
    {
      'image': 'assets/images/swipe5.jpg',
      'title': 'Modern Edge',
      'subtitle': 'Structured Jacket & Straight Pants',
      'style': '모던',
    },
  ];

  final List<String> reasonTags = [
    '색감이 좋음',
    '핏이 좋음',
    '분위기가 좋음',
    '내 옷장과 어울릴 듯',
  ];

  void _nextCard(String action) {
    if (action == 'like') _likeCount++;
    if (action == 'save') _likeCount++; // 저장도 좋아요로 카운트

    if (_currentIndex >= cards.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(likeCount: _likeCount),
        ),
      );
    } else {
      setState(() {
        _currentIndex++;
        _selectedTags.clear();
        _dragX = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final card = cards[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // 상단 헤더
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    '오늘의 취향 탐색',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            Text(
              '마음에 드는 룩을 스와이프 하거나 선택하세요',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 16),

            // 카드 이미지
            GestureDetector(
              onDoubleTap: () {
                // 더블탭 = 저장
                _showSaveSnackbar();
                _nextCard('save');
              },
              onHorizontalDragUpdate: (details) {
                setState(() {
                  _dragX += details.delta.dx;
                });
              },
              onHorizontalDragEnd: (details) {
                if (_dragX > 100) {
                  _nextCard('like');
                } else if (_dragX < -100) {
                  _nextCard('dislike');
                }
                setState(() {
                  _dragX = 0;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Transform.translate(
                  offset: Offset(_dragX, 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        Image.asset(
                          card['image']!,
                          width: double.infinity,
                          height: 340,
                          fit: BoxFit.cover,
                        ),

                        // LIKE 표시
                        if (_dragX > 30)
                          Positioned(
                            top: 20,
                            left: 20,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'LIKE ❤️',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),

                        // NOPE 표시
                        if (_dragX < -30)
                          Positioned(
                            top: 20,
                            right: 20,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'NOPE ✕',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),

                        // 그라데이션
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.7),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),

                        // 텍스트
                        Positioned(
                          bottom: 16,
                          left: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                card['title']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                card['subtitle']!,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 13,
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

            const SizedBox(height: 12),

            // 싫어요/저장/좋아요 힌트 텍스트
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSwipeHint(Icons.chevron_left, '싫어요'),
                  _buildSwipeHint(Icons.touch_app_outlined, '저장 (Double Tap)'),
                  _buildSwipeHint(Icons.chevron_right, '좋아요'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 태그 선택
            const Text(
              '어떤 점이 마음에 드시나요?',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: reasonTags.map((tag) {
                final isSelected = _selectedTags.contains(tag);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedTags.remove(tag);
                      } else {
                        _selectedTags.add(tag);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.grey[300]!,
                      ),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const Spacer(),

            // 하단 버튼 3개
            Padding(
              padding: const EdgeInsets.only(bottom: 32, left: 60, right: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 싫어요
                  _buildActionButton(
                    icon: Icons.close,
                    color: Colors.grey[300]!,
                    iconColor: Colors.grey[600]!,
                    size: 56,
                    onTap: () => _nextCard('dislike'),
                  ),
                  // 좋아요 (크게)
                  _buildActionButton(
                    icon: Icons.favorite,
                    color: Colors.black,
                    iconColor: Colors.white,
                    size: 72,
                    onTap: () => _nextCard('like'),
                  ),
                  // 저장 (북마크로 변경!)
                  _buildActionButton(
                    icon: Icons.bookmark_border,
                    color: Colors.grey[300]!,
                    iconColor: Colors.grey[600]!,
                    size: 56,
                    onTap: () {
                      _showSaveSnackbar();
                      _nextCard('save');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 저장 스낵바
  void _showSaveSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.bookmark, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('저장되었어요! ⭐'),
          ],
        ),
        backgroundColor: Colors.black,
        duration: const Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildSwipeHint(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon == Icons.chevron_left)
          Icon(icon, size: 16, color: Colors.grey[500]),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 12,
          ),
        ),
        if (icon != Icons.chevron_left)
          Icon(icon, size: 16, color: Colors.grey[500]),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required Color iconColor,
    required double size,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: size * 0.4),
      ),
    );
  }
}
