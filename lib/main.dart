import 'package:echo_llm/models/chats.dart';
import 'package:echo_llm/screens/mainScreen.dart';
import 'package:echo_llm/services/messenger_service.dart';
import 'package:echo_llm/state_management/apikeyModalState.dart';
import 'package:echo_llm/state_management/messageStreamState.dart';
import 'package:echo_llm/state_management/screenState.dart';
import 'package:echo_llm/state_management/sidebarState.dart';
import 'package:echo_llm/state_management/textfieldState.dart';
import 'package:echo_llm/userConfig.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await GetStorage.init('api-keys');
  await GetStorage.init('preferences');

  await Hive.initFlutter();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  await Hive.openBox('chatBox');
  Hive.registerAdapter(ChatAdapter());
  Hive.registerAdapter(MessageAdapter());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Textfieldstate()),
        ChangeNotifierProvider(create: (_) => Messagestreamstate()),
        ChangeNotifierProvider(create: (_) => Sidebarstate()),
        ChangeNotifierProvider(create: (_) => Screenstate()),
        ChangeNotifierProvider(create: (_) => ApikeyModalState()),
        ChangeNotifierProvider(create: (_) => CONFIG()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<CONFIG>(context, listen: false);
    config.loadPreferences();

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        platform: TargetPlatform.macOS,
        useMaterial3: true,
      ),
      home: MainScreen(),
    );
  }
}
