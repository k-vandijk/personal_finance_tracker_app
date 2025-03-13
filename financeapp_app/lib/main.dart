import 'package:financeapp_app/firebase_options.dart';
import 'package:financeapp_app/shell.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final ColorScheme kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 0, 255, 98),
);

final ColorScheme kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 0, 255, 98),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Ensure app is portrait only
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    MaterialApp(
      theme: ThemeData().copyWith(colorScheme: kColorScheme),

      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkColorScheme.tertiary.withAlpha(200),
            foregroundColor: kDarkColorScheme.onTertiary,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: kDarkColorScheme.tertiary,
          ),
        ),
      ),
      home: const Shell(),
    ),
  );
}
