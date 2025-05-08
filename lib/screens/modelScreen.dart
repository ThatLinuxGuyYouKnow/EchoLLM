import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModelScreen extends StatelessWidget {
  ModelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: 1, // only one tile
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // or 1 if you want it to stretch full width
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            return ModelTile(
              tileTitle: 'TinyLLM',
              isAvailable: true,
            );
          },
        ),
      ),
    );
  }
}

class ModelTile extends StatelessWidget {
  final String tileTitle;
  final bool isAvailable;

  ModelTile({super.key, required this.tileTitle, required this.isAvailable});
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 80, minHeight: 80),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Color(0xFF1E2733)),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(tileTitle, style: GoogleFonts.ubuntu()),
                Icon(isAvailable ? Icons.done : Icons.add)
              ],
            )
          ],
        ),
      ),
    );
  }
}
