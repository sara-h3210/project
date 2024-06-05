// ignore_for_file: library_private_types_in_public_api
import 'package:app/game_logic/numbers.dart';
import 'package:flutter/material.dart';
import 'start_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chiffres',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NumbersPage(),
    );
  }
}

class NumbersPage extends StatefulWidget {
  const NumbersPage({super.key});

  @override
  _NumbersPageState createState() => _NumbersPageState();
}

class _NumbersPageState extends State<NumbersPage> {
  final List<int> _numbers = generateNumbers();
  final int _target = generateTarget();
  List<String> _solutions = [];
  List<String> _closestSolution = [];
  String _currentExpression = '';
  final List<int> _currentNumbers = [];
  final List<int> _usedNumbers = [];
  final List<String> _expressions = [];

  @override
  void initState() {
    super.initState();
    _solutions = finalSolution(_numbers, _target);
    _currentNumbers.addAll(_numbers);
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
      _closestSolution =
          printSolution(sortedSolutions.first, _numbers, _target);
    }
  }

  void _appendNumber(int number) {
    setState(() {
      _currentExpression += number.toString();
      _usedNumbers.add(number);
    });
  }

  void _appendOperation(String operation) {
    setState(() {
      _currentExpression += ' $operation ';
    });
  }

  void _evaluateExpression() {
    final parts = _currentExpression.split(' ');
    if (parts.length >= 3) {
      final num1 = int.parse(parts[0]);
      final num2 = int.parse(parts[2]);
      final op = parts[1];

      if (_currentNumbers.contains(num1) && _currentNumbers.contains(num1)) {
        int result = applyOperation(num1, op, num2);
        setState(() {
          final expression = '$_currentExpression = $result';
          _expressions.add(expression);
          _currentNumbers.remove(num1);
          _usedNumbers.add(num1);
          _usedNumbers.add(num2);
          _currentNumbers.add(result);
          _currentExpression = '';
        });
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Invalid Numbers'),
            content: Text('Please select numbers from the current list.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  void _undoLastOperation() {
    setState(() {
      _currentNumbers.clear();
      _currentNumbers.addAll(_numbers);
      _currentExpression = '';
      _usedNumbers.clear();
      _expressions.clear();
    });
  }

  void _validateResponse() {
    if (_currentNumbers.contains(_target)) {
      _solutions = findSolutions(_numbers, _target);
      if (_solutions.isNotEmpty) {
        final sortedSolutions = _solutions.toList()
          ..sort((a, b) => a.split(' ').length.compareTo(b.split(' ').length));
        _solutions = printSolution(sortedSolutions.first, _numbers, _target);

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Congratulations!'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('You have reached the target: $_target'),
                const SizedBox(height: 16),
                const Text('Solution:'),
                ..._solutions.map(
                    (solution) => Text(solution)), //solution is just a variable
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the current dialog
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NumbersPage()),
                  );
                },
                child: const Text('Play Again'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Congratulations!'),
            content: Text('You have reached the target: $_target'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the current dialog
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NumbersPage()),
                  );
                },
                child: const Text('Play Again'),
              ),
            ],
          ),
        );
      }
    } else {
      List<String> closestSolution = findClosestSolution(_numbers, _target);
      int closestResult = getClosestResult(_numbers, _target);
      if (closestSolution.isNotEmpty &&
          _currentNumbers.contains(closestResult)) {
        final sortedSolutions = closestSolution.toList()
          ..sort((a, b) => a.split(' ').length.compareTo(b.split(' ').length));
        closestSolution =
            printSolution(sortedSolutions.first, _numbers, _target);

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Congratulations!'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('You have reached the closest solution: $closestResult'),
                const SizedBox(height: 16),
                const Text('Closest solution:'),
                ...closestSolution.map((solution) => Text(solution)),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the current dialog
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NumbersPage()),
                  );
                },
                child: const Text('Play Again'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Incorrect'),
            content: Text('You have not reached the target'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _resetGame();
                },
                child: const Text('Try Again'),
              ),
              TextButton(
                onPressed: () {
                  _findSolutions();
                  Navigator.of(context).pop();

                  // Close the current dialog

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Solution'),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_solutions.isNotEmpty)
                            Column(
                              children: [
                                const Text('Here is the Solution:'),
                                ..._solutions.map((solution) => Text(solution)),
                              ],
                            ),
                          if (!_solutions.isNotEmpty)
                            Column(
                              children: [
                                const Text(
                                    'There is no exact solution. \nClosest Solution:'),
                                ..._closestSolution.map(
                                    (closestSolution) => Text(closestSolution)),
                              ],
                            ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pop(); // Close the current dialog
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const NumbersPage()),
                            );
                          },
                          child: const Text('Play Again'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Show Solution'),
              ),
            ],
          ),
        );
      }
    }
  }

  void _resetGame() {
    setState(() {
      _currentNumbers.clear();
      _usedNumbers.clear();
      _currentNumbers.addAll(_numbers);
      _currentExpression = '';
      _expressions.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      SafeArea(
          child: Column(children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          height: kToolbarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.home),
                iconSize: 37.0,
                color: Colors.black,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const StartPage()),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
              Text(
                'NUMBERS',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Arial',
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: Icon(Icons.refresh),
                iconSize: 37.0,
                color: Colors.black,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NumbersPage()),
                  );
                },
              ),
            ],
          ),
        ),
        Expanded(
            child: Center(
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Wrap(
                              spacing: 10,
                              runSpacing: 20,
                              alignment: WrapAlignment.center,
                              children: [
                                for (var number in _numbers)
                                  GestureDetector(
                                    onTap: () {
                                      _appendNumber(number);
                                    },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 199, 156, 247),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          number.toString(),
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(width: 10), // Add some spacing here
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 177, 189, 254),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    _target.toString(),
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: Color.fromARGB(255, 132, 90, 215),
                                width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 200,
                            maxWidth: MediaQuery.of(context).size.width * 0.8,
                          ),
                          child: Text(
                            _currentExpression.isEmpty
                                ? 'Current Expression'
                                : _currentExpression,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: _currentExpression.isEmpty
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                              color: _currentExpression.isEmpty
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ..._currentNumbers.take(2).map(
                                      (number) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: ElevatedButton(
                                          onPressed:
                                              !_usedNumbers.contains(number)
                                                  ? () => _appendNumber(number)
                                                  : null,
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: FittedBox(
                                                child: Text(
                                                  number.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                const SizedBox(width: 16),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: ElevatedButton(
                                    onPressed: () => _appendOperation('+'),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          '+',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: ElevatedButton(
                                    onPressed: () => _appendOperation('-'),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          '-',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ..._currentNumbers.skip(2).take(2).map(
                                      (number) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: ElevatedButton(
                                          onPressed:
                                              !_usedNumbers.contains(number)
                                                  ? () => _appendNumber(number)
                                                  : null,
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: FittedBox(
                                                child: Text(
                                                  number.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                const SizedBox(width: 16),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: ElevatedButton(
                                    onPressed: () => _appendOperation('*'),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          '*',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: ElevatedButton(
                                    onPressed: () => _appendOperation('/'),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          '/',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ..._currentNumbers.skip(4).take(2).map(
                                      (number) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: ElevatedButton(
                                          onPressed:
                                              !_usedNumbers.contains(number)
                                                  ? () => _appendNumber(number)
                                                  : null,
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: FittedBox(
                                                child: Text(
                                                  number.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                const SizedBox(width: 16),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: ElevatedButton(
                                    onPressed: _evaluateExpression,
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          '=',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: ElevatedButton(
                                    onPressed: _undoLastOperation,
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: FittedBox(
                                          child: const Text('Undo',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _validateResponse,
                              style: ElevatedButton.styleFrom(
                                side: BorderSide(
                                  color: Color.fromARGB(255, 115, 46, 151),
                                  width: 2.0,
                                ),
                              ),
                              child: const Text('Validate'),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _expressions
                              .map(
                                (expression) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2.0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 217, 196, 245),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      expression,
                                      style: const TextStyle(fontSize: 16.0),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ))))
      ]))
    ]));
  }
}
