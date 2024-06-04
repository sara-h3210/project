import 'dart:math';
import 'dart:io';

void main() {
    List<int> numbers = generateNumbers();
    int target = generateTarget();
    final solutions = findSolutions(numbers, target);
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
  playGame(numbers, target);
}

 List<int> generateNumbers() {
  Random random = Random();
  List<int> numbers = [];
  // Generate 6 random numbers between 1 and 100
  for (int i = 0; i < 6; i++) {
    numbers.add(random.nextInt(100) + 1);
  }

  print('Numbers: ${numbers.join(', ')}');

  return numbers;
}

int generateTarget() {
  Random random= Random();
// Generate a target number between 100 and 999
  int target = random.nextInt(900) +100;
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
      final num = i ~/ 2 + 1 < usedNumbers.length ? usedNumbers[i ~/ 2 + 1] :0;
      //final num = usedNumbers[i ~/ 2 + 1].int();
      result = _applyOperation(result, op, num);
    }
    return result;
  }

  

 List<String> findSolutions(List<int> numbers, int target) {
  solutions.clear();

  void generateExpressions(List<int> usedNumbers, String expression,List<int> intermediateResults) {
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
            if (op == '/' && (currentNumber == 0 || (lastResult % currentNumber!=0))) {
            continue;
            }

            if (op == '-' && (lastResult-currentNumber<0) ) {
            continue;
            }
            nextExpression = '$expression $op $currentNumber';
            nextResult = _applyOperation(lastResult, op, currentNumber);
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
    generateExpressions([start], start.toString(), [start]);
  }
  return solutions;
}

List<String> findClosestSolution(List<int> numbers, int target) {
  closestSolutions.clear();
  int closestDifference = double.maxFinite.toInt();; // Initialize with positive infinity

    void generateExpressions(List<int> usedNumbers, String expression, List<int> intermediateResults) {
        final result = evaluateExpression(expression, usedNumbers);
      if (closestSolutions.isEmpty) {
        closestSolutions.add(expression); // Add the first non-exact solution as the initial closest solution
      } else {
        final int currentDifference = result.abs() - target.abs();
        if (currentDifference.abs() < closestDifference) { // Check for smaller difference (absolute value)
      closestSolutions.clear(); // Clear previous solutions when closer is found
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
             if (op == '/' && (currentNumber == 0 || (lastResult % currentNumber!=0))) {
            continue;
            }
            if (op == '-' && (lastResult-currentNumber<0) ) {
            continue;
          }
            nextExpression = '$expression $op $currentNumber';
            nextResult = _applyOperation(lastResult, op, currentNumber);
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
    generateExpressions([start], start.toString(), [start]);
  }

  return closestSolutions;
}
int _applyOperation(int a, String op, int b) {
  switch (op) {
    case '+':
      return a + b;
    case '-':
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
      result = _applyOperation(result, op, num);
      solutions.add('$prevResult $op $num = $result');
      solutions.add('${prevResult.toStringAsFixed(2)} $op $num = ${result.toStringAsFixed(2)}');
      print('$prevResult $op $num = $result');
     } else {
      result = num;
     }
     }
      return solutions;
}


void playGame(List<int> numbers, int target) {
  print('Your goal is to reach the target number $target using mathematical operations.');
  print('The initial numbers are: $numbers\n');

  while (numbers.length > 1) {
     if (numbers.contains(target)) {
      print('Congratulations! You have reached the target number $target.');
      break;
    }
    printOperationMenu();
    int choice = int.parse(stdin.readLineSync()!);

    if (choice >= 1 && choice <= 4) {
      performOperation(choice, numbers);
    } else {
      print('Invalid choice. Please try again.\n');
    }
  }

  evaluateResult(numbers.first, target);
}

void printOperationMenu() {
  print('Choose a mathematical operation:');
  print('1. Addition\t2. Subtraction\t3. Multiplication\t4. Division');
}

void performOperation(int choice, List<int> numbers) {
  print('Enter two numbers from the list:');
  int num1 = int.parse(stdin.readLineSync()!);
  int num2 = int.parse(stdin.readLineSync()!);

  if (!numbers.contains(num1) || !numbers.contains(num2)) {
    print('Invalid input. Please enter valid numbers from the list.\n');
    return;
  }

  int result;
  switch (choice) {
    case 1:
      result = num1 + num2;
      print('$num1 + $num2 = $result');
      break;
    case 2:
      result = num1 - num2;
      print('$num1 - $num2 = $result');
      break;
    case 3:
      result = num1 * num2;
      print('$num1 * $num2 = $result');
      break;
    case 4:
      if (num2 == 0) {
        print('Cannot divide by zero.');
        return;
      }
      result = num1 ~/ num2;
      print('$num1 / $num2 = $result');
      break;
    default:
      return;
  }

  numbers.remove(num1);
  numbers.remove(num2);
  numbers.add(result);
  numbers.sort();

  print('Current numbers: $numbers\n');
}

void evaluateResult(int finalNumber, int target) {
  if (finalNumber == target) {
    print('Bravo! The numbers are equal.');
  } else if ((finalNumber <= target + 10 && finalNumber >= target - 10)) {
    print('You were too close!');
  } else {
    print('OOPS! You should try harder next time!');
  }
}
