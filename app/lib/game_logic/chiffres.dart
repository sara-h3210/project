import 'dart:math';

void main() {
    List<dynamic> result = generateNumbers();
    List<int> numbers = result[0];
    int target = result[1];
    final solutions = findSolutions(numbers, target);
    if (solutions.isNotEmpty) {
        print("Solutions:");
        final sortedSolutions = solutions.toList()
            ..sort((a, b) => a.split(' ').length.compareTo(b.split(' ').length));
        printSolution(sortedSolutions.first, numbers, target);
    } else {
        print("No exact solution found");
        final closestSolution = findClosestSolution(numbers, target);
        print("Closest solution: $closestSolution");
    
  }
}

List<dynamic> generateNumbers() {
  Random random = Random();
  List<int> numbers = [];
  // Generate 6 random numbers between 1 and 100
  for (int i = 0; i < 6; i++) {
    numbers.add(random.nextInt(100) + 1);
  }

  // Generate a target number between 100 and 999
  int target = random.nextInt(900) +100;

  print('Numbers: ${numbers.join(', ')}');
  print('Target: $target');

  return [numbers, target];
}

List<String> findSolutions(List<int> numbers, int target) {
  final solutions = <String>[];


  double evaluateExpression(String expression, List<int> usedNumbers) {
    final parts = expression.split(' ');
    double result = usedNumbers[0].toDouble();
    for (int i = 1; i < parts.length; i += 2) {
      final op = parts[i];
      final num = usedNumbers[i ~/ 2 + 1].toDouble();
      result = _applyOperation(result, op, num);
    }
    return result;
  }

  void generateExpressions(List<int> usedNumbers, String expression,List<double> intermediateResults) {
    final result = evaluateExpression(expression, usedNumbers);
    if (result == target.toDouble()) {
      solutions.add(expression);
    }
    for (var i = 0; i < numbers.length; i++) {
      final currentNumber = numbers[i];
      if (!usedNumbers.contains(currentNumber)) {
        for (var op in ['+', '-', '*', '/']) {
          if (op == '/' && currentNumber == 0) {
            continue;
          }
          String nextExpression;
          double nextResult;
          if (expression.isEmpty) {
            nextExpression = currentNumber.toString();
            nextResult = currentNumber.toDouble();
          } else {
            final lastResult = intermediateResults.last;
            nextExpression = '$expression $op $currentNumber';
            nextResult = _applyOperation(lastResult, op, currentNumber.toDouble());
          }
          final newUsedNumbers = [...usedNumbers, currentNumber];
          final newIntermediateResults = [...intermediateResults, nextResult];
          generateExpressions(newUsedNumbers, nextExpression, newIntermediateResults);
        }
      }
    }
  }

  for (var i = 0; i < numbers.length; i++) {
    final start = numbers[i];
    generateExpressions([start], start.toString(), [start.toDouble()]);
  }
  return solutions;
}

String findClosestSolution(List<int> numbers, int target) {
  String closestSolution = "";
  double minDifference = double.infinity;
  final solutions = findSolutions(numbers, target);
  for (final solution in solutions) {
    final result = _evaluateExpression(solution, numbers);
    final difference = (result - target).abs();
    if (difference < minDifference) {
      minDifference = difference;
      closestSolution = solution;
    }
  }
  return closestSolution.isNotEmpty ? closestSolution : "No solution found";
}
double _evaluateExpression(String expression, List<int> usedNumbers) {
  final parts = expression.split(' ');
  double result = usedNumbers[0].toDouble();
  for (int i = 1; i < parts.length; i += 2) {
    final op = parts[i];
    final num = usedNumbers[i ~/ 2 + 1].toDouble();
    result = _applyOperation(result, op, num);
  }
  return result;
}

double _applyOperation(double a, String op, double b) {
  switch (op) {
    case '+':
      return a + b;
    case '-':
      return a - b;
    case '*':
      return a * b;
    case '/':
      return a / b;
    default:
      throw ArgumentError('Invalid operation: $op');
  }
}

    List<String> printSolution(String solution, List<int> numbers, int target) {
      final solutions = <String>[];
      final parts = solution.split(' ');
      final usedNumbers = <int>[];
      double result = 0;
      for (int i = 0; i < parts.length; i += 2) {
      final num = int.parse(parts[i]);
      usedNumbers.add(num);
      if (i > 0) {
      final op = parts[i - 1];
      final prevResult = result;
      result = _applyOperation(result, op, num.toDouble());
      solutions.add('$prevResult $op $num = $result');
      solutions.add('${prevResult.toStringAsFixed(2)} $op $num = ${result.toStringAsFixed(2)}');
      print('$prevResult $op $num = $result');
     } else {
      result = num.toDouble();
     }
     }
      return solutions;
}
