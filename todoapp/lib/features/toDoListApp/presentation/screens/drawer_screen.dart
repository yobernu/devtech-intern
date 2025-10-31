import 'package:flutter/material.dart';
import 'package:todoapp/features/toDoListApp/presentation/navigation.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      // ✅ provides Material ancestor for ListTiles
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF466A5E), Color(0xFF37584E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.all(20),
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 50, color: Color(0xFF466A5E)),
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Guest',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'preahvihear',
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    drawerItem(Icons.home, 'Home', onTap: () {}),
                    drawerItem(
                      Icons.done_all_rounded,
                      'Completed tasks',
                      onTap: () {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.completedtasks,
                        );
                      },
                    ),

                    drawerItem(
                      Icons.help_outline,
                      'Help & Support',
                      onTap: () {},
                    ),
                    const Divider(color: Colors.white70),
                    drawerItem(Icons.logout, 'Logout', onTap: () {}),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget drawerItem(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: onTap,
    );
  }
}
