import 'package:flutter/material.dart';

class Enterapikeymodal extends StatelessWidget {
  final String modelName;

  const Enterapikeymodal({super.key, required this.modelName});
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 500,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.black),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Enter your API key for ' + modelName),
              ],
            )
          ],
        ),
      ),
    );
  }
}
