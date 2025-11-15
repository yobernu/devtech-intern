import 'package:flutter/material.dart';
import 'package:quizapp/core/constants/appcolors.dart';
class MeshGradientBackground extends StatelessWidget {
  final Widget child;

  const MeshGradientBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base color
        Positioned.fill(
          child: Container(color: Color(0xFFE7DFFF)),
        ),

        // Mesh blobs
        ...[
          _blob(Alignment(-0.5, -0.4), AppColors.primaryPurple),
          _blob(Alignment(0.8, -0.5), Color(0xFFA8D0FF)),
          _blob(Alignment(-0.3, 0.2), AppColors.primaryPurple),
          _blob(Alignment(0.2, 0.7), AppColors.secondaryPurple),
        ],

        Positioned.fill(child: child),
      ],
    );
  }

  Widget _blob(Alignment center, Color color) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: center,
            radius: 0.6,
            colors: [
              color.withOpacity(0.55),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}
