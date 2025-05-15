import 'package:echo_llm/mappings/modelSlugMappings.dart';
import 'package:echo_llm/userConfig.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Modelselector extends StatefulWidget {
  const Modelselector({super.key});

  @override
  State<Modelselector> createState() => _ModelselectorState();
}

class _ModelselectorState extends State<Modelselector> {
  late String selectedValue;
  late CONFIG config;

  @override
  void initState() {
    super.initState();

    config = context.read<CONFIG>();

    selectedValue = config.model.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF4C83D1), width: 2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
          dropdownColor: const Color(0xFF2A3441),
          style: const TextStyle(color: Colors.white, fontSize: 16),
          items: onlineModels.keys.map((option) {
            return DropdownMenuItem(value: option, child: Text(option));
          }).toList(),
          onChanged: (value) {
            if (value == null) return;
            setState(() => selectedValue = value);

            config.setPreferredModel(modelName: value);
          },
        ),
      ),
    );
  }
}
