import 'dart:async';
import 'dart:io';

import 'package:echo_llm/dataHandlers/hive/chatStrorage.dart';
import 'package:echo_llm/inference/superHandler.dart';
import 'package:echo_llm/logic/convertMessageState.dart';
import 'package:echo_llm/services/voice_service.dart';
import 'package:echo_llm/state_management/messageStreamState.dart';
import 'package:echo_llm/state_management/screenState.dart';
import 'package:echo_llm/state_management/textfieldState.dart';
import 'package:echo_llm/userConfig.dart';
import 'package:echo_llm/widgets/buttons.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class ChatTextField extends StatefulWidget {
  final TextEditingController chatController;
  const ChatTextField({super.key, required this.chatController});

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField>
    with SingleTickerProviderStateMixin {
  final VoiceService _voiceService = VoiceService();
  bool _isRecording = false;
  bool _isVoskInitializing = false;

  StreamSubscription<String>? _partialSub;
  StreamSubscription<String>? _finalSub;

  // For the pulsing mic animation
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Track whether the platform supports voice (Android/iOS only)
  bool get _isVoiceSupported =>
      !kIsWeb &&
      (Platform.isAndroid || Platform.isIOS);

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _partialSub?.cancel();
    _finalSub?.cancel();
    _voiceService.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    if (!_voiceService.isReady) {
      setState(() => _isVoskInitializing = true);
      await _voiceService.initializeModel();
      setState(() => _isVoskInitializing = false);
      if (!_voiceService.isReady) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Microphone permission denied or model failed to load.'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
        return;
      }
    }

    // Subscribe to partial results (live preview)
    _partialSub = _voiceService.partialResultStream.listen((partial) {
      // We don't overwrite; partial shows what is being spoken in real-time
      // The final result will be the committed text
    });

    // Subscribe to final results (committed text)
    _finalSub = _voiceService.finalResultStream.listen((finalText) {
      final controller = widget.chatController;
      final current = controller.text;
      final separator = current.isNotEmpty && !current.endsWith(' ') ? ' ' : '';
      controller.text = '$current$separator$finalText';
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length),
      );
    });

    await _voiceService.startRecording();
    setState(() => _isRecording = true);
    _pulseController.repeat(reverse: true);
  }

  Future<void> _stopRecording() async {
    await _voiceService.stopRecording();
    _partialSub?.cancel();
    _finalSub?.cancel();
    _partialSub = null;
    _finalSub = null;
    setState(() => _isRecording = false);
    _pulseController.stop();
    _pulseController.reset();
  }

  @override
  Widget build(BuildContext context) {
    final messageState = Provider.of<Messagestreamstate>(context, listen: true);
    final textfieldState = Provider.of<Textfieldstate>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isPhoneScreen = screenWidth <= 900;
    bool isExpanded = textfieldState.isExpanded;
    final config = Provider.of<CONFIG>(context);
    final fontScale = config.fontScale;
    final modelInference = InferenceSuperClass(
        conversationHistory: messageState.messages,
        messageState: messageState,
        config: config);
    final existingID = messageState.chatID;
    final shouldSendOnEnter = Provider.of<CONFIG>(context).shouldSendOnEnter;
    final FocusNode textFieldFocusNode = FocusNode();

    Future<void> sendMessage() async {
      // Stop recording if active before sending
      if (_isRecording) {
        await _stopRecording();
      }

      final userMessage = widget.chatController.text.trim();
      if (userMessage.isEmpty) return;

      final messageState =
          Provider.of<Messagestreamstate>(context, listen: false);
      final screenState = Provider.of<Screenstate>(context, listen: false);

      final bool isFirstMessage = screenState.isOnWelcomeScreen;

      messageState.addMessage(message: userMessage);
      messageState.setProcessing(true);
      widget.chatController.clear();
      if (isFirstMessage) {
        screenState.chatScreen();
      }
      final response = await modelInference.runInference(userMessage);

      if (response != null && response.isNotEmpty) {
        messageState.addMessage(message: response);

        final hiveReadyMessages =
            convertIndexedMessagesToHive(messageState.messages);
        final title = titleFromFirstMessage(messageState.messages);

        final chatId = await saveChatLocally(
            existingChatID: existingID,
            messages: hiveReadyMessages,
            chatTitle: title);
        if (existingID.isEmpty) {
          messageState.setCurrentChatID(chatId);
        }
      } else {
        widget.chatController.text = userMessage;
        screenState.welcomeScreen();
      }

      messageState.setProcessing(false);
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 100),
        child: Container(
          height: textfieldState.isExpanded ? 400 : 150,
          constraints:
              BoxConstraints(minHeight: 150, maxHeight: isExpanded ? 400 : 200),
          width: isPhoneScreen ? 800 : screenWidth / 2.5,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: isExpanded
                                  ? const Color(0xFF4C83D1)
                                  : Colors.transparent),
                          color: const Color(0xFF1E2733),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Focus(
                                focusNode: textFieldFocusNode,
                                onFocusChange: (isFocused) {
                                  if (textfieldState.isExpanded && !isFocused) {
                                    textfieldState.minimize();
                                  }
                                },
                                autofocus: true,
                                child: TextField(
                                  textInputAction: shouldSendOnEnter
                                      ? TextInputAction.send
                                      : TextInputAction.newline,
                                  onSubmitted: (string) {
                                    if (shouldSendOnEnter) {
                                      sendMessage();
                                    }
                                  },
                                  maxLines: null,
                                  minLines: null,
                                  expands: isExpanded,
                                  scrollPadding:
                                      EdgeInsets.only(top: isExpanded ? 20 : 0),
                                  controller: widget.chatController,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontSize: 15 * fontScale),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: _isRecording
                                        ? 'Listening...'
                                        : 'Type a message',
                                    contentPadding: const EdgeInsets.only(
                                        left: 12.0,
                                        right: 90,
                                        bottom: 10,
                                        top: 10),
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: _isRecording
                                          ? Colors.redAccent.withValues(alpha: 0.8)
                                          : null,
                                    ),
                                  ),
                                  onChanged: (text) {
                                    if (text.length > 200 && !isExpanded) {
                                      textfieldState.expand();
                                    } else if (text.length < 50 &&
                                        textfieldState.isExpanded) {
                                      textfieldState.minimize();
                                    }
                                  },
                                ),
                              ),
                            ),
                            // Mic + Send button row
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E2733),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Microphone button (only on supported platforms)
                                    if (_isVoiceSupported)
                                      _isVoskInitializing
                                          ? const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Color(0xFF4C83D1),
                                                ),
                                              ),
                                            )
                                          : ScaleTransition(
                                              scale: _isRecording
                                                  ? _pulseAnimation
                                                  : const AlwaysStoppedAnimation(1.0),
                                              child: IconButton(
                                                onPressed: _toggleRecording,
                                                icon: Icon(
                                                  _isRecording
                                                      ? Icons.stop_rounded
                                                      : Icons.mic_rounded,
                                                  color: _isRecording
                                                      ? Colors.redAccent
                                                      : const Color(0xFF4C83D1),
                                                  size: 22,
                                                ),
                                                tooltip: _isRecording
                                                    ? 'Stop recording'
                                                    : 'Start voice input',
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(
                                                  minWidth: 36,
                                                  minHeight: 36,
                                                ),
                                              ),
                                            ),
                                    ChatButton(
                                      whenPressed: sendMessage,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String titleFromFirstMessage(List<Map<int, String>> messages) {
  if (messages.isEmpty) return "Untitled Chat";
  final first = messages.first.values.first;
  return first.length > 30 ? '${first.substring(0, 30)}...' : first;
}
