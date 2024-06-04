import 'dart:math';

void main() {
  List<int> numbers = generateNumbers();
  int target = generateTarget();

  final solutions = findSolutions(numbers, target);
  final solutions2 = finalSolution(numbers, target);
  print("Closest solution: $solutions2");
  if (solutions.isNotEmpty) {
    print("Solutions:");
    final sortedSolutions = solutions.toList()
      ..sort((a, b) => a.split(' ').length.compareTo(b.split(' ').length));
    printSolution(sortedSolutions.first, numbers, target);
  } else {
    print("No exact solution found");
    final closestSolution = findClosestSolution(numbers, target);
    printSolution(closestSolution.first, numbers, target);
    //print("Closest solution: $closestSolution");
  }
}

List<int> generateNumbers() {
  Random random = Random();
  Set<int> numbersSet =
      {}; // Create an empty set that does not allow duplicate elements.

  // Generate 6 random numbers between 1 and 100
  while (numbersSet.length < 6) {
    int randomNumber = random.nextInt(100) + 1;
    numbersSet.add(randomNumber); // Add the random number to the set
  }

  List<int> numbers = numbersSet.toList(); // Convert the set to a list
  print('Numbers: ${numbers.join(', ')}');
  return numbers;
}

int generateTarget() {
  Random random = Random();
// Generate a target number between 100 and 999
  int target = random.nextInt(900) + 100;
  print('Target: $target');
  return target;
}

List<String> solutions = [];
List<String> closestSolutions = [];

int evaluateExpression(String expression, List<int> usedNumbers) {
  final parts = expression.split(' ');
  int result = usedNumbers[0];
  for (int i = 1; i < parts.length; i += 2) {
    final op = parts[i];
    final num = i ~/ 2 + 1 < usedNumbers.length ? usedNumbers[i ~/ 2 + 1] : 0;
    //final num = usedNumbers[i ~/ 2 + 1].int();
    result = applyOperation(result, op, num);
  }
  return result;
}

List<String> findSolutions(List<int> numbers, int target) {
  solutions.clear();

  void generateExpressions(
      List<int> usedNumbers, String expression, List<int> intermediateResults) {
    final result = evaluateExpression(expression, usedNumbers);
    if (result == target) {
      solutions.add(expression);
    }
    for (var i = 0; i < numbers.length; i++) {
      final currentNumber = numbers[i];
      if (!usedNumbers.contains(currentNumber)) {
        for (var op in ['+', '-', '*', '/']) {
          String nextExpression;
          int nextResult;
          if (expression.isEmpty) {
            nextExpression = currentNumber.toString();
            nextResult = currentNumber;
          } else {
            final lastResult = intermediateResults.last;
            if (op == '/' &&
                (currentNumber == 0 || (lastResult % currentNumber != 0))) {
              continue;
            }

            if (op == '-' && (lastResult - currentNumber < 0)) {
              continue;
            }
            nextExpression = '$expression $op $currentNumber';
            nextResult = applyOperation(lastResult, op, currentNumber);
          }
          final newUsedNumbers = [...usedNumbers, currentNumber];
          final newIntermediateResults = [...intermediateResults, nextResult];
          generateExpressions(
              newUsedNumbers, nextExpression, newIntermediateResults);
        }
      }
    }
  }

  for (var i = 0; i < numbers.length; i++) {
    final start = numbers[i];
    generateExpressions([start], start.toString(), [start]);
  }
  return solutions;
}

List<String> findClosestSolution(List<int> numbers, int target) {
  closestSolutions.clear();
  int closestDifference =
      double.maxFinite.toInt(); // Initialize with positive infinity

  void generateExpressions(
      List<int> usedNumbers, String expression, List<int> intermediateResults) {
    final result = evaluateExpression(expression, usedNumbers);
    if (closestSolutions.isEmpty) {
      closestSolutions.add(
          expression); // Add the first non-exact solution as the initial closest solution
    } else {
      final int currentDifference = result.abs() - target.abs();
      if (currentDifference.abs() < closestDifference) {
        // Check for smaller difference (absolute value)
        closestSolutions
            .clear(); // Clear previous solutions when closer is found
        closestSolutions.add(expression);
        closestDifference = currentDifference.abs();
      } else if (currentDifference.abs() == closestDifference) {
        closestSolutions.add(expression);
      }
    }

    for (var i = 0; i < numbers.length; i++) {
      final currentNumber = numbers[i];
      if (!usedNumbers.contains(currentNumber)) {
        for (var op in ['+', '-', '*', '/']) {
          String nextExpression;
          int nextResult;
          if (expression.isEmpty) {
            nextExpression = currentNumber.toString();
            nextResult = currentNumber;
          } else {
            final lastResult = intermediateResults.last;
            if (op == '/' &&
                (currentNumber == 0 || (lastResult % currentNumber != 0))) {
              continue;
            }
            if (op == '-' && (lastResult - currentNumber < 0)) {
              continue;
            }
            nextExpression = '$expression $op $currentNumber';
            nextResult = applyOperation(lastResult, op, currentNumber);
          }
          final newUsedNumbers = [...usedNumbers, currentNumber];
          final newIntermediateResults = [...intermediateResults, nextResult];
          generateExpressions(
              newUsedNumbers, nextExpression, newIntermediateResults);
        }
      }
    }
  }

  for (var i = 0; i < numbers.length; i++) {
    final start = numbers[i];
    generateExpressions([start], start.toString(), [start]);
  }

  return closestSolutions;
}

int applyOperation(int a, String op, int b) {
  switch (op) {
    case '+':
      return a + b;
    case '-':
      if (b > a) {
        throw ArgumentError('Division by zero');
      }
      return a - b;
    case '*':
      return a * b;
    case '/':
      if (b == 0) {
        throw ArgumentError('Division by zero');
      }
      if (a % b != 0) {
        // Handle non-integer division result
        return (a / b).floor(); // Truncate the result to the nearest integer
      }
      return a ~/ b;
    default:
      throw ArgumentError('Invalid operation: $op');
  }
}

List<String> printSolution(String solution, List<int> numbers, int target) {
  final solutions = <String>[];
  final parts = solution.split(' ');
  final usedNumbers = <int>[];
  int result = 0;
  for (int i = 0; i < parts.length; i += 2) {
    final num = int.parse(parts[i]);
    usedNumbers.add(num);
    if (i > 0) {
      final op = parts[i - 1];
      final prevResult = result;
      result = applyOperation(result, op, num);
      solutions.add('$prevResult $op $num = $result');
      print('$prevResult $op $num = $result');
    } else {
      result = num;
    }
  }
  return solutions;
}

int getClosestResult(List<int> numbers, int target) {
  List<String> closestSolutions = findClosestSolution(numbers, target);
  if (closestSolutions.isNotEmpty) {
    String closestExpression = closestSolutions.first;
    final parts = closestExpression.split(' ');
    int result = int.parse(parts[0]);

    for (int i = 1; i < parts.length; i += 2) {
      final op = parts[i];
      final num = int.parse(parts[i + 1]);
      result = applyOperation(result, op, num);
    }

    return result;
  } else {
    return 0;
  }
}

List<String> finalSolution(List<int> numbers, int target) {
  List<String> solutions = findSolutions(numbers, target);
  if (solutions.isNotEmpty) {
    final sortedSolutions = solutions.toList()
      ..sort((a, b) => a.split(' ').length.compareTo(b.split(' ').length));
    return printSolution(sortedSolutions.first, numbers, target);
  } else {
    solutions = findClosestSolution(numbers, target);
    return printSolution(solutions.first, numbers, target);
  }
}
