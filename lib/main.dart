// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login/login_page.dart';
import 'package:equition/theme/app_theme.dart';
import 'state/app_state.dart';
import 'dart:ui' as ui;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Define o idioma do Firebase Auth para o idioma do sistema (ex: 'pt')
  final lang = ui.PlatformDispatcher.instance.locale.languageCode;

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
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
      title: 'Equition',
      theme: AppTheme.lightTheme(),
      home: const LoginPage(),
    );
  }
}