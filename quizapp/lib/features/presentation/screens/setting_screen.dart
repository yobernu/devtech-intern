import 'package:flutter/material.dart';
import 'package:quizapp/core/constants/appcolors.dart';
import 'package:quizapp/features/presentation/helpers/meshBackground.dart';
// Assuming buildTopBar takes a BuildContext and returns a Widget (like your previous example)
import 'package:quizapp/features/presentation/widgets/bars/top_bar.dart'; 
import 'package:quizapp/features/presentation/widgets/settings_items.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color surfaceColor = Theme.of(context).colorScheme.surface;
    final Color onSurfaceColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
        body: MeshGradientBackground(
          child: Padding(
            padding: const EdgeInsets.only(top: 32),
            child: CustomScrollView(
              
              slivers: [
                // 2. SliverAppBar for the Custom Header and Title
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  pinned: true,
                  expandedHeight: 140.0, 
                  automaticallyImplyLeading: false,
                  
                  flexibleSpace: FlexibleSpaceBar(
                    background: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTopBar(context), 
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(left: 24.0, bottom: 16.0),
                          child: Text(
                            "Settings",
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                              color: AppColors.surfaceWhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      // vertical: 16.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: surfaceColor.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // --- Setting Items (Content remains the same) ---
                            Text("Account", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: onSurfaceColor)),
                            const Divider(thickness: 1, height: 24),
                            SettingsItem(icon: Icons.person_outline, title: "Update profile", onTap: () {}),
                            SettingsItem(icon: Icons.lock_outline, title: "Change Password", onTap: () {}),
                            const SizedBox(height: 32),
                            
                            Text("Quiz Data", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: onSurfaceColor)),
                            const Divider(thickness: 1, height: 24),
                            SettingsItem(icon: Icons.history, title: "Quiz History", onTap: () {}),
                            SettingsItem(icon: Icons.leaderboard_outlined, title: "View Leaderboard", onTap: () {}),
                            const SizedBox(height: 32),
                            
                            Text("General", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: onSurfaceColor)),
                            const Divider(thickness: 1, height: 24),
                            SettingsItem(icon: Icons.notifications_none, title: "Notifications", onTap: () {}, trailing: Switch(value: true, onChanged: (bool value) {})),
                            SettingsItem(icon: Icons.color_lens_outlined, title: "Theme (Dark/Light)", onTap: () {}, trailing: Switch(value: false, onChanged: (bool value) {})),
                            const SizedBox(height: 32),
                            
                            Text("Support", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: onSurfaceColor)),
                            const Divider(thickness: 1, height: 24),
                            SettingsItem(icon: Icons.info_outline, title: "About App", onTap: () {}),
                            SettingsItem(icon: Icons.logout, title: "Logout", onTap: () {}),

                            
                            const SizedBox(height: 16), 
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      
    );
  }
}