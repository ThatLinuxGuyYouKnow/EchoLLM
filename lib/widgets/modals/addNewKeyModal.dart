import 'package:echo_llm/mappings/modelClassMapping.dart';
import 'package:echo_llm/mappings/modelSlugMappings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddNewKeyModal extends StatelessWidget {
  const AddNewKeyModal({super.key, required bool isNewUser});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1E2733),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 10,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add a new key',
                    style: GoogleFonts.ubuntu(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey[500]),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Centered content container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Model',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    PlainModelSelector(),
                    const SizedBox(height: 20),
                    const Text(
                      'API Key',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _ModaltextField(),
                  ],
                ),
              ),

              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _consentButton(
                    buttonText: 'Cancel',
                    onPressed: () => Navigator.of(context).pop(),
                    buttonColor: Colors.transparent,
                    textColor: Colors.grey[400]!,
                  ),
                  const SizedBox(width: 20),
                  _consentButton(
                    buttonText: 'Save Key',
                    onPressed: () {},
                    buttonColor: const Color(0xFF4C83D1),
                    textColor: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlainModelSelector extends StatefulWidget {
  const PlainModelSelector({super.key});

  @override
  State<PlainModelSelector> createState() => _PlainModelSelectorState();
}

class _PlainModelSelectorState extends State<PlainModelSelector> {
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = onlineModels.keys.first;
  }

  @override
  Widget build(BuildContext context) {
    final availableOptions = onlineModels.keys.toList();

    return SizedBox(
      // Constrained width
      width: 450,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFF2A3441),
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: const Color(0xFF3A4A5F),
            width: 1.5,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10.0),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedValue,
              isExpanded: true,
              icon: Icon(
                Icons.arrow_drop_down,
                color: Color(0xFF4A90E2),
                size: 28,
              ),
              dropdownColor: const Color(0xFF1E2733),
              borderRadius: BorderRadius.circular(10.0),
              elevation: 8,
              style: GoogleFonts.ubuntu(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              items: availableOptions.map((String option) {
                final isSelected = option == _selectedValue;
                return DropdownMenuItem<String>(
                  value: option,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Image.asset(getModelIcon(modelName: option)),
                      title: Text(
                        option,
                        style: GoogleFonts.ubuntu(
                          color: isSelected
                              ? Colors.cyanAccent[100]
                              : Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null || value == _selectedValue) return;
                setState(() => _selectedValue = value);
              },
              selectedItemBuilder: (BuildContext context) {
                return availableOptions.map<Widget>((String item) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(
                        item,
                        style: GoogleFonts.ubuntu(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _ModaltextField extends StatelessWidget {
  const _ModaltextField();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 450,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFF2A3441),
          border: Border.all(
            color: const Color(0xFF3A4A5F),
            width: 1.5,
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: TextField(
            style: TextStyle(color: Colors.white, fontSize: 15),
            obscureText: true,
            obscuringCharacter: '•',
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter your API key...',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _consentButton({
  required String buttonText,
  required Function() onPressed,
  required Color buttonColor,
  Color textColor = Colors.white,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: buttonColor,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: buttonColor == Colors.transparent
            ? BorderSide(color: Colors.blue.withOpacity(0.4))
            : BorderSide.none,
      ),
    ),
    child: Text(
      buttonText,
      style: GoogleFonts.ubuntu(
        color: textColor,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
    ),
  );
}

String getModelIcon({required String modelName}) {
  String model_family = modelClassMapping[onlineModels[modelName]]!;
  if (model_family == 'gemini') {
    return 'assets/model_icons/gemini-icon.png';
  } else if (model_family == 'openai') {
    return 'assets/model_icons/openai-icon.png';
  } else {
    return 'assets/model_icons/xai-icon.png';
  }
}
