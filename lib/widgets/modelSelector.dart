import 'package:echo_llm/mappings/modelAvailabilityMapping.dart';
import 'package:echo_llm/mappings/modelSlugMappings.dart'; // Assuming this contains 'onlineModels'
import 'package:echo_llm/userConfig.dart'; // Your CONFIG class
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:google_fonts/google_fonts.dart'; // For consistent font
import 'package:provider/provider.dart';

class Modelselector extends StatefulWidget {
  const Modelselector({super.key});

  @override
  State<Modelselector> createState() => _ModelselectorState();
}

class _ModelselectorState extends State<Modelselector> {
  late String _selectedValue; // Use a more descriptive private name
  late CONFIG _config; // Store the config instance
  List<String> availableOptions = getAvailableModelsForUser();
  @override
  @override
  void initState() {
    super.initState();

    _config = context.read<CONFIG>();

    String initialModelFromConfig = _config.model.trim();

    if (availableOptions.isNotEmpty) {
      if (availableOptions.contains(initialModelFromConfig)) {
        _selectedValue = initialModelFromConfig;
      } else {
        _selectedValue = availableOptions.first;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _config.setPreferredModel(modelName: _selectedValue);
          }
        });
      }
    } else {
      _selectedValue = '';
    }
  }

  @override
  Widget build(BuildContext context) {
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
                value: _selectedValue,
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
                              ? Colors.cyanAccent[100]
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
                // Customizing the displayed selected item in the button itself
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
