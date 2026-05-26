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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    List<String> availableOptions = keysState.availableModelNames;
    
    if (availableOptions.isEmpty) {
    }

    if (availableOptions.isNotEmpty) {
      if (!availableOptions.contains(_selectedValue)) {
         _selectedValue = availableOptions.first;
         WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _config.setPreferredModel(modelName: _selectedValue);
         });
      }
    } else {
    }

    return Container(
      width: 300,
      height: 50,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: isDark ? const Color(0xFF1E2733) : Colors.grey[300]!,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.grey[300]!).withOpacity(0.4),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: (isDark ? Colors.white : Colors.black).withOpacity(0.05),
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
                  color: isDark
                      ? const Color(0xFF1E2733)
                      : Colors.grey[600]!,
                  size: 30,
                ),
                dropdownColor: isDark
                    ? const Color.fromARGB(255, 18, 29, 43)
                    : Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                elevation: 8,
                style: GoogleFonts.ubuntu(
                  color: (isDark ? Colors.white : Colors.black87)
                      .withOpacity(0.9),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                hint: availableOptions.isEmpty
                    ? Text("No models available",
                        style: GoogleFonts.ubuntu(
                            color: isDark ? Colors.white54 : Colors.black54))
                    : null,
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
                                : (isDark ? Colors.white : Colors.black87)
                                    .withOpacity(0.85),
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
                          color: isDark ? Colors.white : Colors.black87,
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
