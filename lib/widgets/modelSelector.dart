import 'package:flutter/material.dart';

class Modelselector extends StatefulWidget {
  Modelselector({super.key});

  @override
  State<Modelselector> createState() => _ModelselectorState();
}

class _ModelselectorState extends State<Modelselector> {
  String selectedValue = 'Agege GPT v1';

  List<String> options = ['Agege GPT v1', 'Agege GPT v2', 'Gemini 2.5 pro'];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Color(0xFF4C83D1), width: 2)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white,
          ),
          dropdownColor: Color(0xFF2A3441),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          items: options.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                selectedValue = value;
              });
            }
          },
        ),
      ),
    );
  }
}
