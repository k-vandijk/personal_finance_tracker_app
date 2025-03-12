import 'package:financeapp_app/services/auth_service.dart';
import 'package:financeapp_app/shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

final ColorScheme kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 0, 255, 98),
);

final ColorScheme kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 0, 255, 98),
);

Future<void> main() async {
  
  // Ensure that the app is in portrait mode.
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthService(),
      child: MaterialApp(
        theme: ThemeData().copyWith(colorScheme: kColorScheme),

        darkTheme: ThemeData.dark().copyWith(
          colorScheme: kDarkColorScheme,
          cardTheme: CardTheme(
            color: kDarkColorScheme.inverseSurface,
            elevation: 4,
          ),
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
    ),
  );
}
