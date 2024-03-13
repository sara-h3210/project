import 'dart:io';
import 'dart:math';
import 'dart:developer' as developer;

void main() {
  List<String> letters = generateRandomLetters(0);

  developer.log('Random letters: $letters');

  developer.log('Please form a word:');
  String userInput = stdin.readLineSync()!.toLowerCase();

  // Check if the word contains only the letters provided
  if (!containsOnlyAvailableLetters(userInput, letters)) {
     developer.log('The word $userInput contains invalid letters.');
  } else if (isValidWordFromFile(userInput)) {
    developer.log('The word $userInput is valid.');
  } else {
     developer.log('The word $userInput is not valid.');
  }
}

List<String> generateRandomLetters(int numVowels) {
  List<String> vowels = ['a', 'e', 'i', 'o', 'u'];
  /* developer.log('Enter the desired number of vowels (between 2 and 4):');
  int numVowels = int.parse(stdin.readLineSync()!); // Parse directly to int

  while (numVowels < 2 || numVowels > 4)
  {
     developer.log('Invalid input. Please enter an integer between 2 and 4:');
    numVowels = int.parse(stdin.readLineSync()!); // Parse again
  */
  List<String> randomLetters = [];
  Random random = Random();

  for (int i = 0; i < numVowels; i++) {
    randomLetters.add(vowels[random.nextInt(vowels.length)]);
  }

  // Complete the rest of the letters up to 10 randomly
  while (randomLetters.length < 10) {
    int randomIndex = random.nextInt(26);
    String randomLetter = String.fromCharCode(97 + randomIndex);
    if (!vowels.contains(randomLetter)) {
      randomLetters.add(randomLetter);
    }
  }
  randomLetters.shuffle();
  
  return randomLetters;
}

bool isValidWordFromFile(String word) {
  File file = File('valid_words.txt');

  if (!file.existsSync()) {
     developer.log('Error: File not found.');
    return false;
  }

  try {
    List<String> validWords = file.readAsLinesSync();
    return validWords
        .any((validWord) => validWord.trim().toLowerCase() == word);
  } catch (e) {
     developer.log('Error: $e');
    return false;
  }
}

bool containsOnlyAvailableLetters(String word, List<String> letters) {
  for (int i = 0; i < word.length; i++) {
    if (!letters.contains(word[i])) {
      return false;
    }
  }
  return true;
}
