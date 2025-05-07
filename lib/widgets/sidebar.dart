import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSideBar extends StatelessWidget {
  CustomSideBar({super.key});
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: const Color(0xFF1E2733),
      child: Container(
        child: Padding(
          child: Column(
            children: [
              DrawerTile(
                tileTitle: 'New Chat',
                tileIcon: Icons.add,
              )
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        ),
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  final String tileTitle;
  final IconData tileIcon;
  DrawerTile({super.key, required this.tileTitle, required this.tileIcon});
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              tileTitle,
              style: GoogleFonts.ubuntu(color: Colors.white, fontSize: 18),
            ),
            Icon(
              tileIcon,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
