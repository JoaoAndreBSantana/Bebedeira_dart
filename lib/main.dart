import 'package:flutter/material.dart';
import 'telas/home_tela.dart';

void main() {
  runApp(const BebedeiraApp());
}

/// App principal com tema escuro e cores vibrantes (roxo, rosa, laranja)
class BebedeiraApp extends StatelessWidget {
  const BebedeiraApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData.dark();
    return MaterialApp(
      title: 'Bebedeira com Amigos',
      theme: base.copyWith(
        colorScheme: base.colorScheme.copyWith(
          primary: Colors.deepPurpleAccent, // roxo vibrante
          secondary: Colors.pinkAccent, // rosa vibrante
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.orangeAccent, // laranja vibrante
        ),
        scaffoldBackgroundColor: Colors.black,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeTela(),
    );
  }
}
