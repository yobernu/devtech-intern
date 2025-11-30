import 'package:flutter/material.dart';
import 'package:quizapp/core/constants/appcolors.dart';
import 'package:quizapp/features/domain/entities/question_entity.dart';
import 'package:quizapp/features/presentation/helpers/meshBackground.dart';

class DifficultySelectionScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const DifficultySelectionScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<DifficultySelectionScreen> createState() =>
      _DifficultySelectionScreenState();
}

class _DifficultySelectionScreenState extends State<DifficultySelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    // Create staggered slide animations for each difficulty card
    _slideAnimations = List.generate(3, (index) {
      final start = index * 0.15;
      final end = start + 0.5;
      return Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _slideController,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );
    });

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _onDifficultySelected(Difficulty difficulty) {
    Navigator.pushNamed(
      context,
      '/showQuestion',
      arguments: {
        'categoryId': widget.categoryId,
        'difficulty': difficulty.name,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.surfaceWhite),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: MeshGradientBackground(
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Title Section
                  Text(
                    'Choose Difficulty',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: AppColors.surfaceWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.categoryName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.surfaceWhite.withOpacity(0.7),
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Difficulty Cards
                  Expanded(
                    child: ListView(
                      children: [
                        _buildDifficultyCard(
                          context: context,
                          difficulty: Difficulty.easy,
                          title: 'Easy',
                          description: 'Perfect for beginners',
                          icon: Icons.sentiment_satisfied_alt,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF56CCF2), Color(0xFF2F80ED)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          animationIndex: 0,
                        ),
                        const SizedBox(height: 20),
                        _buildDifficultyCard(
                          context: context,
                          difficulty: Difficulty.medium,
                          title: 'Medium',
                          description: 'For experienced players',
                          icon: Icons.local_fire_department,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFF2994A), Color(0xFFF2C94C)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          animationIndex: 1,
                        ),
                        const SizedBox(height: 20),
                        _buildDifficultyCard(
                          context: context,
                          difficulty: Difficulty.hard,
                          title: 'Hard',
                          description: 'Ultimate challenge',
                          icon: Icons.whatshot,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFEB5757), Color(0xFFE91E63)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          animationIndex: 2,
                        ),
                        const SizedBox(height: 20),
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

  Widget _buildDifficultyCard({
    required BuildContext context,
    required Difficulty difficulty,
    required String title,
    required String description,
    required IconData icon,
    required Gradient gradient,
    required int animationIndex,
  }) {
    return SlideTransition(
      position: _slideAnimations[animationIndex],
      child: GestureDetector(
        onTap: () => _onDifficultySelected(difficulty),
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: gradient.colors.first.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => _onDifficultySelected(difficulty),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(icon, size: 40, color: Colors.white),
                    ),
                    const SizedBox(width: 20),
                    // Text Section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            description,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Arrow Icon
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white.withOpacity(0.8),
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
