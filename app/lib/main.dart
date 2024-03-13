import 'package:flutter/material.dart';
import 'package:app/pages/letters_page.dart'; // Import the lettersPage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Des chiffres et des lettres',
      home: LettersPage(),
    );
  }
}
