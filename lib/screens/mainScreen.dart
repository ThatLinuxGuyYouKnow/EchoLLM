import 'package:echo_llm/state_management/screenState.dart';
import 'package:echo_llm/state_management/sidebarState.dart';
import 'package:echo_llm/widgets/appBar.dart';
import 'package:echo_llm/widgets/collapsedSidebar.dart';
import 'package:echo_llm/widgets/modals/addNewKeyModal.dart';
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
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) =>
            buildFirstTimeUserPrompt(onPositiveButtonPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => AddNewKeyModal());
        }, onNegativeButtonPressed: () {
          Navigator.pop(context);
        }),
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
