import 'package:flutter/material.dart';
import 'package:fitness_english_app/app/presentation/screens/body_part_selection_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final darkTheme = ThemeData.dark().copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.lightGreen,
        brightness: Brightness.dark,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      useMaterial3: true,
    );

    return MaterialApp(
      title: 'Fitness English App',
      themeMode: ThemeMode.dark,
      darkTheme: darkTheme,
      home: const BodyPartSelectionScreen(),
    );
  }
}