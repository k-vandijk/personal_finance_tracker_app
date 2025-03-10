import 'package:financeapp_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'auth_wrapper.dart';

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
    ChangeNotifierProvider(
      create: (_) => AuthService(),
      child: MaterialApp(
        theme: ThemeData().copyWith(colorScheme: kColorScheme),
        darkTheme: ThemeData.dark().copyWith(colorScheme: kDarkColorScheme),
        home: const AuthWrapper(),
      ),
    ),
  );
}
