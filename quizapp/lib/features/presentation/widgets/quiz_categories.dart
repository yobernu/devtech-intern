import 'package:flutter/material.dart';
import 'package:quizapp/core/constants/appcolors.dart';
import 'package:quizapp/features/presentation/widgets/cards/custom_pill_button.dart';
class AnimatedQuizCategories extends StatefulWidget {
  const AnimatedQuizCategories({super.key});

  @override
  State<AnimatedQuizCategories> createState() => _AnimatedQuizCategoriesState();
}

class _AnimatedQuizCategoriesState extends State<AnimatedQuizCategories> with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>> _scaleAnimations;

  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.sports_soccer, 'label': 'Football', 'color': Color(0xFFE45B41)},
    {'icon': Icons.lightbulb_outline, 'label': 'Science', 'color': Color(0xFF41A8E4)},
    {'icon': Icons.shopping_bag_outlined, 'label': 'Fashion', 'color': Color(0xFFE441A8)},
    {'icon': Icons.movie_outlined, 'label': 'Movie', 'color': Color(0xFF41E45B)},
    {'icon': Icons.music_note_outlined, 'label': 'Music', 'color': Color(0xFFE4B641)},
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideAnimations = List.generate(categories.length, (index) {
      final start = index * 0.1;
      final end = start + 0.4;
      return Tween<Offset>(
        begin: const Offset(-1.2, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(start, end, curve: Curves.easeOut),
      ));
    });

    _scaleAnimations = List.generate(categories.length, (index) {
      final start = index * 0.1;
      final end = start + 0.4;
      return Tween<double>(
        begin: 0.8,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(start, end, curve: Curves.easeOutBack),
      ));
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildAnimatedButton(int index) {
    final item = categories[index];
    return SlideTransition(
      position: _slideAnimations[index],
      child: ScaleTransition(
        scale: _scaleAnimations[index],
        child: CustomPillButton(
          icon: item['icon'],
          label: item['label'],
          color: item['color'],
          onPress: () {
            Navigator.pushNamed(context, '/showQuestion');
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quiz',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.surfaceWhite,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'View All',
                    style: TextStyle(color: AppColors.surfaceWhite),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (_, index) => buildAnimatedButton(index),
            ),
          ),
        ],
      ),
    );
  }
}