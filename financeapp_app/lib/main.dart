import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:financeapp_app/shell.dart';

ColorScheme kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 24, 182, 193),
);

ColorScheme kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 24, 182, 193),
);

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    MaterialApp(
      theme: ThemeData().copyWith(colorScheme: kColorScheme),
      darkTheme: ThemeData.dark().copyWith(colorScheme: kDarkColorScheme),
      home: const Shell(),
    ),
  );
}