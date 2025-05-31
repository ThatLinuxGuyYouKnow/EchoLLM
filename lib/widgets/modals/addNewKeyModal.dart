import 'package:echo_llm/mappings/modelSlugMappings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddNewKeyModal extends StatelessWidget {
  const AddNewKeyModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1E2733),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add a new key',
              style: GoogleFonts.ubuntu(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: const PlainModelSelector(),
            ),
            _ModaltextField()
          ],
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

    return Container(
      width: 400,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF1E2733),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: const Color(0xFF1E2733),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
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
              color: const Color(0xFF1E2733),
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
            items: availableOptions.map((String option) {
              final isSelected = option == _selectedValue;
              return DropdownMenuItem<String>(
                value: option,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    option,
                    style: GoogleFonts.ubuntu(
                      color: isSelected
                          ? const Color.fromARGB(255, 168, 174, 180)
                          : Colors.white.withOpacity(0.85),
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
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
                    padding: const EdgeInsets.only(left: 8.0),
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
    );
  }
}

Widget _ModaltextField() {
  return Container(
    width: 400,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), color: Colors.black),
    height: 40,
    child: Center(
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
      ),
    ),
  );
}
