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
  final List<int> _numbers = generateNumbers();
  final int _target = generateTarget();
  List<String> _solutions = [];
  List<String> _closestSolution = [];
  bool _showSolutions = false;
  String _currentExpression = '';

  @override
  void initState() {
    super.initState();
  }

  void _findSolutions() {
    _solutions = findSolutions(_numbers, _target);
    if (_solutions.isNotEmpty) {
      final sortedSolutions = _solutions.toList()
        ..sort((a, b) => a.split(' ').length.compareTo(b.split(' ').length));
      _solutions = printSolution(sortedSolutions.first, _numbers, _target);
    } else {
      _closestSolution = findClosestSolution(_numbers, _target);
      final sortedSolutions = _closestSolution.toList()
        ..sort((a, b) => a.split(' ').length.compareTo(b.split(' ').length));
      _closestSolution = printSolution(sortedSolutions.first, _numbers, _target);
    }
    setState(() {
      _showSolutions = true;
    });
  }

  void _appendNumber(int number) {
    setState(() {
      _currentExpression += number.toString();
    });
  }

  void _appendOperation(String operation) {
    setState(() {
      _currentExpression += ' $operation ';
    });
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
            Text('Numbers: ${_numbers.join(', ')}'),
            const SizedBox(height: 16),
            Text('Target: $_target'),
            const SizedBox(height: 16),
            Text('Current Expression: $_currentExpression'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                ..._numbers.map((number) => ElevatedButton(
                      onPressed: () => _appendNumber(number),
                      child: Text(number.toString()),
                    )),
                ElevatedButton(
                  onPressed: () => _appendOperation('+'),
                  child: const Text('+'),
                ),
                ElevatedButton(
                  onPressed: () => _appendOperation('-'),
                  child: const Text('-'),
                ),
                ElevatedButton(
                  onPressed: () => _appendOperation('*'),
                  child: const Text('*'),
                ),
                ElevatedButton(
                  onPressed: () => _appendOperation('/'),
                  child: const Text('/'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _findSolutions,
              child: const Text('Find Solution'),
            ),
            if (_showSolutions && _solutions.isNotEmpty)
              Column(
                children: [
                  const Text('Solution:'),
                  ..._solutions.map((solution) => Text(solution)),
                ],
              ),
            if (_showSolutions && !_solutions.isNotEmpty)
              Column(
                children: [
                  const Text('Closest Solution:'),
                  ..._closestSolution.map((closestSolution) => Text(closestSolution)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

