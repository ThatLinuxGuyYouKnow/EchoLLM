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
          itemCount: 2,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            return ModelTile(
              tileTitle: 'TinyLLM',
              isAvailable: false,
            );
          },
        ),
      ),
    );
  }
}

class ModelTile extends StatefulWidget {
  final String tileTitle;
  final bool isAvailable;

  ModelTile({super.key, required this.tileTitle, required this.isAvailable});

  @override
  State<ModelTile> createState() => _ModelTileState();
}

class _ModelTileState extends State<ModelTile> {
  bool isHovered = false;
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        isHovered = true;
        setState(() {});
      },
      onExit: (event) {
        isHovered = false;
        setState(() {});
      },
      child: Container(
        height: 100,
        width: 100,
        constraints: BoxConstraints(
            minWidth: 80, minHeight: 80, maxHeight: 200, maxWidth: 200),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isHovered
                ? Color.fromARGB(255, 26, 31, 37)
                : Color(0xFF1E2733)),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.tileTitle,
                      style: GoogleFonts.ubuntu(color: Colors.white)),
                  Icon(
                    widget.isAvailable ? Icons.check_circle : Icons.add_circle,
                    color: Colors.white,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
