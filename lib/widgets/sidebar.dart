import 'package:flutter/material.dart';

class CustomSideBar extends StatelessWidget {
  CustomSideBar({super.key});
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: const Color(0xFF1E2733),
      child: Container(
        child: Padding(
          child: Column(
            children: [Text('Test')],
          ),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        ),
      ),
    );
  }
}
