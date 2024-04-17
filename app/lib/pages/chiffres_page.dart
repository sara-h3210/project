import 'package:app/game_logic/chiffres.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Le compte est bon',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    final List<dynamic> results = generateNumbers();
    final List<int> _numbers = [];
    final int _target = 0;
   List<String> _solutions = [];
   String? _closestSolution;
    bool _showSolutions = false; // Flag to control solution visibility

  @override
  void initState() {
    super.initState();
    _findSolutions();
  }

  void _findSolutions() {
    final List<dynamic> results = generateNumbers();
    final List<int> _numbers = results[0];
    final int _target = results[1];
    _solutions = findSolutions(_numbers, _target);
    if (_solutions.isNotEmpty) {
      _closestSolution = null;
       final sortedSolutions = _solutions.toList()
      ..sort((a, b) => a.split(' ').length.compareTo(b.split(' ').length));
      _solutions = printSolution(sortedSolutions.first, _numbers, _target);
    } else {
      _closestSolution = findClosestSolution(_numbers, _target);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Le compte est bon : '),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Numbers: ${results[0].join(', ')}'),
            const SizedBox(height: 16),
            Text('Target: ${results[1]}'),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                _findSolutions(); // Call findSolutions on button press
                setState(() {
                  _showSolutions = true; // Show solutions after finding
                });
              },
              child: const Text('Find Solution'),
            ),
            if (_showSolutions) // Only show solutions if _showSolutions is true
              Column(
                children: [
                  const Text('Solution:'),
                  ..._solutions.map((solution) => Text(solution)),
                ],
              ),
            if (_closestSolution != null && !_showSolutions)
              Text('Closest Solution: $_closestSolution')
            else if (!_showSolutions)
              const Text('No Solution Found'),
          ],
        ),
      ),
    );
  }
}
