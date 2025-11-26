import 'package:flutter/material.dart';
import 'package:quizapp/core/constants/appcolors.dart';
import 'package:quizapp/features/domain/entities/question_entity.dart';
import 'package:quizapp/features/domain/entities/quiz_category_entity.dart';
import 'package:quizapp/features/presentation/widgets/cards/custom_pill_button.dart';

class AnimatedQuizCategories extends StatefulWidget {
  final List<QuizCategory> categories;

  const AnimatedQuizCategories({super.key, required this.categories});

  @override
  State<AnimatedQuizCategories> createState() => _AnimatedQuizCategoriesState();
}

class _AnimatedQuizCategoriesState extends State<AnimatedQuizCategories>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late List<Animation<Offset>> _slideAnimations = [];
  late List<Animation<double>> _scaleAnimations = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    if (widget.categories.isNotEmpty) {
      _setupAnimations(widget.categories.length);
    }
  }

  void _setupAnimations(int count) {
    _slideAnimations.clear();
    _scaleAnimations.clear();

    for (var i = 0; i < count; i++) {
      final start = i * 0.1;
      final end = start + 0.4;

      _slideAnimations.add(
        Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(start, end, curve: Curves.easeOut),
          ),
        ),
      );

      _scaleAnimations.add(
        Tween<double>(begin: 0.8, end: 1.0).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(start, end, curve: Curves.easeOutBack),
          ),
        ),
      );
    }

    _controller.forward(from: 0.0);
  }

  @override
  void didUpdateWidget(AnimatedQuizCategories oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.categories.length != oldWidget.categories.length &&
        widget.categories.isNotEmpty) {
      _setupAnimations(widget.categories.length);
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Now safe to call dispose
    super.dispose();
  }

  Widget buildAnimatedButton(int index) {
    final item = widget.categories[index];
    // Define temporary icon/color logic since your DB doesn't store them directly.
    // In a real app, you'd fetch these from the QuizCategory entity.
    final List<IconData> icons = [
      Icons.lightbulb_outline,
      Icons.sports_soccer,
      Icons.movie_outlined,
      Icons.music_note_outlined,
      Icons.shopping_bag_outlined,
    ];
    final List<Color> colors = [
      Color(0xFF41A8E4),
      Color(0xFFE45B41),
      Color(0xFF41E45B),
      Color(0xFFE4B641),
      Color(0xFFE441A8),
    ];

    // Check if animations are ready before using them
    if (_slideAnimations.isEmpty || index >= _slideAnimations.length) {
      return const SizedBox.shrink();
    }

    return SlideTransition(
      position: _slideAnimations[index],
      child: ScaleTransition(
        scale: _scaleAnimations[index],
        child: CustomPillButton(
          icon: icons[index % icons.length],
          label: item.name,
          color: colors[index % colors.length],
          onPress: () {
            Navigator.pushNamed(
              context,
              '/showQuestion',
              arguments: {'categoryId': item.id, 'difficulty': "easy"},
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.categories.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'No quiz categories available.',
            style: TextStyle(color: AppColors.surfaceWhite),
          ),
        ),
      );
    }

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
              itemCount: widget.categories.length, // Use the fetched list count
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (_, index) => buildAnimatedButton(index),
            ),
          ),
        ],
      ),
    );
  }
}
