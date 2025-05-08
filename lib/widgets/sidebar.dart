import 'package:echo_llm/state_management/sidebarState.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CustomSideBar extends StatelessWidget {
  CustomSideBar({super.key});
  Widget build(BuildContext context) {
    final sidebar = Provider.of<Sidebarstate>(context);
    return AnimatedContainer(
      color: Color(0xFF1E2733),
      duration: Duration(milliseconds: 800),
      child: Padding(
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 8,
                ),
                IconButton.filled(
                    tooltip: 'Collpse SideBar',
                    style: IconButton.styleFrom(
                        backgroundColor: Colors.black.withOpacity(0.3)),
                    onPressed: () {
                      sidebar.collapse();
                    },
                    icon: Icon(
                      Icons.hide_source,
                      color: Colors.white,
                    ))
              ],
            ),
            DrawerTile(
              tileTitle: 'New Chat',
              tileIcon: Icons.add,
            ),
            DrawerTile(tileTitle: 'Settings', tileIcon: Icons.settings)
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  final String tileTitle;
  final IconData tileIcon;
  DrawerTile({super.key, required this.tileTitle, required this.tileIcon});
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Container(
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
                style: GoogleFonts.ubuntu(color: Colors.white, fontSize: 16),
              ),
              Icon(
                tileIcon,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
