import 'package:echo_llm/screens/mainScreen.dart';
import 'package:echo_llm/state_management/messageStreamState.dart';
import 'package:echo_llm/state_management/screenState.dart';
import 'package:echo_llm/state_management/sidebarState.dart';
import 'package:echo_llm/state_management/textfieldState.dart';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await GetStorage.init('ApiKeys');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Textfieldstate()),
        ChangeNotifierProvider(create: (_) => Messagestreamstate()),
        ChangeNotifierProvider(create: (_) => Sidebarstate()),
        ChangeNotifierProvider(create: (_) => Screenstate()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      home: MainScreen(),
    );
  }
}
