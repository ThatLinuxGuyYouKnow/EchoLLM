import 'package:echo_llm/state_management/screenState.dart';
import 'package:echo_llm/state_management/sidebarState.dart';
import 'package:echo_llm/widgets/appBar.dart';
import 'package:echo_llm/widgets/collapsedSidebar.dart';
import 'package:echo_llm/widgets/modals/firstTimeUserModal.dart';
import 'package:echo_llm/widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController rawChat = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _showFirstTimeDialog());
  }

  void _showFirstTimeDialog() {
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) => buildFirstTimeUserPrompt(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sidebarIsCollapsed =
        Provider.of<Sidebarstate>(context, listen: true).isCollapsed;

    final currentScreen = Provider.of<Screenstate>(context).currentScreen;

    return Row(
      children: [
        sidebarIsCollapsed
            ? SizedBox(
                width: 100,
                child: Collapsedsidebar(),
              )
            : SizedBox(
                width: 250,
                child: CustomSideBar(),
              ),
        Expanded(
          child: Scaffold(
            appBar: DarkAppBar(),
            backgroundColor: Colors.black,
            body: SafeArea(child: currentScreen),
          ),
        ),
      ],
    );
  }
}

Widget buildFirstTimeUserPrompt() {
  return Dialog(
    backgroundColor: const Color(0xFF1E2733),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: Colors.blue.withOpacity(0.3), width: 1),
    ),
    child: Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'First Time?',
            style: GoogleFonts.ubuntu(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "You'll need to enter at least one API key to get started with EchoLLM",
            style: GoogleFonts.ubuntu(
              color: Colors.grey[400],
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => null,
                child: Text(
                  'Got it!',
                  style: GoogleFonts.ubuntu(
                    color: Colors.cyanAccent[100],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
