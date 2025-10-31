import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onMenuPressed;
  const CustomAppBar({Key? key, required this.title, this.onMenuPressed})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.fromLTRB(32.0, 0, 0, 0),
        child: IconButton(
          icon: Icon(Icons.menu_open),
          onPressed: onMenuPressed,
        ),
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      title: Padding(
        padding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 0),
        child: Text(
          title,
          style: TextStyle(fontFamily: 'preahvihear', color: Colors.black),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
