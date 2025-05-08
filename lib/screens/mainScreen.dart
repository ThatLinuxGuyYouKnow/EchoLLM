import 'package:echo_llm/state_management/messageStreamState.dart';
import 'package:echo_llm/state_management/sidebarState.dart';
import 'package:echo_llm/state_management/textfieldState.dart';
import 'package:echo_llm/widgets/appBar.dart';
import 'package:echo_llm/widgets/messageBubble.dart';
import 'package:echo_llm/widgets/sidebar.dart';
import 'package:echo_llm/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController rawChat = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final messageStream =
        Provider.of<Messagestreamstate>(context, listen: true).messages;
    final textFieldVisibility = Provider.of<Textfieldstate>(context);
    final sidebarIsCollapsed =
        Provider.of<Sidebarstate>(context, listen: true).isCollapsed;
    final screenWidth = MediaQuery.of(context).size.width;
    final isPhoneScreen = screenWidth <= 900;

    return Row(
      children: [
        sidebarIsCollapsed
            ? SizedBox.shrink()
            : SizedBox(
                width: 250,
                child: CustomSideBar(),
              ),
        Expanded(
          child: Scaffold(
            appBar: DarkAppBar(),
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Stack(
                children: [
                  NotificationListener<ScrollUpdateNotification>(
                    onNotification: (notification) {
                      if (notification.scrollDelta != null &&
                          notification.scrollDelta!.abs() > 6) {
                        textFieldVisibility.makeInvisible();
                        Future.delayed(const Duration(milliseconds: 900), () {
                          if (!_scrollController
                              .position.isScrollingNotifier.value) {
                            textFieldVisibility.makeVisible();
                          }
                        });
                      }
                      return true;
                    },
                    child: Center(
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: isPhoneScreen ? 400 : screenWidth / 2.5,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: messageStream.length,
                          itemBuilder: (context, index) {
                            final messageMap = messageStream[index];
                            final messageIndex = messageMap.keys.first;
                            final messageText = messageMap[messageIndex]!;
                            final isModel = messageIndex % 2 != 0;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 6.0),
                              child: MessageBubble(
                                messageText: messageText,
                                isModelResponse: isModel,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: ChatTextField(chatController: rawChat),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
