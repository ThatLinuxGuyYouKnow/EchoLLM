import 'package:echo_llm/userConfig.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:echo_llm/state_management/keysState.dart';

class Modelselector extends StatefulWidget {
  const Modelselector({super.key});

  @override
  State<Modelselector> createState() => _ModelselectorState();
}

class _ModelselectorState extends State<Modelselector> {
  String _selectedValue = '';
  late CONFIG _config;

  @override
  void initState() {
    super.initState();
    _config = context.read<CONFIG>();
    _selectedValue = _config.model.trim();
  }

  @override
  Widget build(BuildContext context) {
    final keysState = context.watch<KeysState>();
    List<String> availableOptions = keysState.availableModelNames;
    
    if (availableOptions.isEmpty) {
       // If no keys are set, the dropdown handles this via the hint text.
       // We do not fallback to all models because we want to enforce key availability.
    }

    // Ensure _selectedValue is valid
    if (availableOptions.isNotEmpty) {
      if (!availableOptions.contains(_selectedValue)) {
         _selectedValue = availableOptions.first;
         // Update config to match reality
         WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _config.setPreferredModel(modelName: _selectedValue);
         });
      }
    } else {
        // If empty, maybe reset selectedValue or keep it?
        // _selectedValue = '';
    }

    return Container(
      width: 300,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1C1E),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Color(0xFF1E2733),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.05),
            blurRadius: 1,
            offset: const Offset(0, -0.5),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: availableOptions.contains(_selectedValue) ? _selectedValue : (availableOptions.isNotEmpty ? availableOptions.first : null),
                isExpanded: true,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Color(0xFF1E2733),
                  size: 30,
                ),
                dropdownColor: const Color.fromARGB(255, 18, 29, 43),
                borderRadius: BorderRadius.circular(10.0),
                elevation: 8,
                style: GoogleFonts.ubuntu(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                hint: availableOptions.isEmpty ? Text("No models available", style: GoogleFonts.ubuntu(color: Colors.white54)) : null,
                items: availableOptions.map((option) {
                  bool isSelected = option == _selectedValue;
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 8.0),
                      child: Text(
                        option,
                        style: GoogleFonts.ubuntu(
                          color: isSelected
                              ? const Color.fromARGB(255, 168, 174, 180)
                              : Colors.white.withOpacity(0.85),
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null || value == _selectedValue) return;
                  setState(() => _selectedValue = value);
                  _config.setPreferredModel(modelName: value);
                },
                selectedItemBuilder: (BuildContext context) {
                  return availableOptions.map<Widget>((String item) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item,
                        style: GoogleFonts.ubuntu(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
