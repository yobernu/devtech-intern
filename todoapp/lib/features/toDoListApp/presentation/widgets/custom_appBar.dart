import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.fromLTRB(32.0, 0, 0, 0),
        child: Icon(Icons.menu_open),
      ),
      backgroundColor: Color(0xFF466A5E),
      title: Padding(
        padding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
        child: Text(title),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
