import 'package:flutter/material.dart';
import 'package:app/game_logic/lettres.dart';

class LettersPage extends StatefulWidget {
  const LettersPage({super.key});

  @override
  LettersPageState createState() => LettersPageState();
}

class LettersPageState extends State<LettersPage> {
  String _userInput = '';
  List<String> _letters = [];
  //final _wordValidator = containsOnlyAvailableLetters('',[]);
  bool _isValidWord = false;

  Future<void> _generateLetters() async {
    await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter number of vowels'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context, '2'),
              child: const Text(
                '2',
                style: TextStyle(fontSize: 24), // Set font size here
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, '3'),
              child: const Text(
                '3',
                style: TextStyle(fontSize: 24), // Set font size here
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, '4'),
              child: const Text(
                '4',
                style: TextStyle(fontSize: 24), // Set font size here
              ),
            ),
          ],
        ),
      ),
    ).then((value) {
      if (value != null) {
        int numVowels = int.tryParse(value) ?? 2;
        _letters = generateRandomLetters(numVowels);
        setState(() {});
      }
    });
  }

  void checkWordValidity() {
    _isValidWord = containsOnlyAvailableLetters(_userInput, _letters);
    setState(() {}); // Update UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Des chiffres et des lettres'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Generated Letters: ${_letters.join(', ')}'),
            TextField(
              decoration: const InputDecoration(labelText: 'Enter a word'),
              onChanged: (value) => _userInput = value.toLowerCase(),
            ),
            ElevatedButton(
              onPressed: _generateLetters,
              child: const Text('Generate Letters'),
            ),
            ElevatedButton(
              onPressed: checkWordValidity,
              child: const Text('Check Word'),
            ),
            Text(_isValidWord ? 'Valid Word!' : 'Invalid Word'),
          ],
        ),
      ),
    );
  }
}
