import 'package:echo_llm/dataHandlers/firstTimeUser.dart';
import 'package:echo_llm/state_management/screenState.dart';
import 'package:echo_llm/state_management/sidebarState.dart';
import 'package:echo_llm/widgets/appBar.dart';
import 'package:echo_llm/widgets/collapsedSidebar.dart';
import 'package:echo_llm/widgets/modals/addNewKeyModal.dart';
import 'package:echo_llm/widgets/modals/apiKeyReminder.dart';
import 'package:echo_llm/widgets/modals/firstTimeUserModal.dart';

import 'package:echo_llm/widgets/sidebar.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController rawChat = TextEditingController();
  bool isNewUser = false;
  @override
  void initState() {
    super.initState();
    isNewUser = isFirstTimeUser();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showFirstTimeDialog());
  }

  void _showFirstTimeDialog() {
    if (mounted && isNewUser) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => buildFirstTimeUserPrompt(
            onPositiveButtonPressed: () {
              Navigator.pop(context);
              showDialog(
                  barrierDismissible: isNewUser ? false : true,
                  context: context,
                  builder: (BuildContext context) => AddNewKeyModal(
                        isNewUser: true,
                      ));
            },
            context: context),
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
