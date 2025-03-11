import 'package:financeapp_app/services/auth_service.dart';
import 'package:financeapp_app/shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

final ColorScheme kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 24, 182, 193),
);

final ColorScheme kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 24, 182, 193),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

/// Root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthService(),
      child: MaterialApp(
        title: 'Finance App',
        theme: ThemeData().copyWith(colorScheme: kColorScheme),
        darkTheme: ThemeData.dark().copyWith(colorScheme: kDarkColorScheme),
        home: const Shell(),
      ),
    );
  }
}
