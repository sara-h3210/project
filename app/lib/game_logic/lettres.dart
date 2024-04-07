import 'dart:io';
import 'dart:math';
import 'dart:convert';

class TrieNode {
  final Map<String, TrieNode> children = {};
  bool isEndOfWord = false;
}

class TreeNode {
  String key;
  TreeNode? left, right;

  TreeNode(this.key);
}

class Tree {
  TreeNode? root;
  void insert(String key) {
    root = _insertRec(root, key);
  }

  TreeNode _insertRec(TreeNode? node, String key) {
    if (node == null) {
      return TreeNode(key);
    }

    int cmp = key.compareTo(node.key);

    if (cmp < 0) {
      node.left = _insertRec(node.left, key);
    } else if (cmp > 0) {
      node.right = _insertRec(node.right, key);
    }
    return node;
  }

  bool search(String key) {
    return _searchRec(root, key);
  }

  bool _searchRec(TreeNode? node, String key) {
    if (node == null) {
      return false;
    }

    int cmp = key.compareTo(node.key);

    if (cmp == 0) {
      return true;
    } else if (cmp < 0) {
      return _searchRec(node.left, key);
    } else {
      return _searchRec(node.right, key);
    }
  }
}

class Trie {
  final TrieNode _root = TrieNode();

  void insert2(String word) {
    var current = _root;
    for (var i = 0; i < word.length; i++) {
      var char = word[i];
      if (!current.children.containsKey(char)) {
        current.children[char] = TrieNode();
      }
      current = current.children[char]!;
    }
    current.isEndOfWord = true;
  }

  bool search2(String word) {
    var current = _root;
    for (var i = 0; i < word.length; i++) {
      var char = word[i];
      if (!current.children.containsKey(char)) {
        return false;
      }
      current = current.children[char]!;
    }
    return current.isEndOfWord;
  }
}

Future<Tree> readTreeFromFile(String filePath) async {
  var tree = Tree();
  var file = File(filePath);
  try {
    List<String> lines = await file.readAsLines();
    for (var line in lines) {
      tree.insert(line);
    }
  } catch (e) {
    print('Error reading file: $e');
  }
  return tree;
}

List<String> generateRandomLetters(int count) {
  List<String> vowels = ['a', 'e', 'i', 'o', 'u'];
  List<String> consonants = [
    'b',
    'c',
    'd',
    'f',
    'g',
    'h',
    'j',
    'k',
    'l',
    'm',
    'n',
    'p',
    'q',
    'r',
    's',
    't',
    'v',
    'w',
    'x',
    'y',
    'z'
  ];

  List<String> letters = [];
  Random random = Random();
  int vowelsCount = random.nextInt(3) + 4;

  // Add vowels
  for (int i = 0; i < vowelsCount; i++) {
    int randomVowelIndex = random.nextInt(vowels.length);
    String vowel = vowels[randomVowelIndex];
    if (!letters.contains(vowel)) {
      letters.add(vowel);
    }
  }

  // Add consonants
  for (int i = 0; i < count - vowelsCount; i++) {
    int randomConsonantIndex = random.nextInt(consonants.length);
    String consonant = consonants[randomConsonantIndex];
    if (!letters.contains(consonant)) {
      letters.add(consonant);
    }
  }

  letters.shuffle();

  return letters;
}

bool isValidWord(String word, List<String> availableLetters) {
  word = word.toLowerCase();

  List<String> remainingLetters = List.from(availableLetters);

  for (int i = 0; i < word.length; i++) {
    String letter = word[i];

    if (!remainingLetters.contains(letter)) {
      return false;
    }

    remainingLetters.remove(letter);
  }

  return true;
}

void checkWordAndSearch(Tree tree, String? word, List<String> randomLetters) {
  if (word != null) {
    word = word.toLowerCase();

    if (isValidWord(word, randomLetters)) {
      if (tree.search(word.trim())) {
        print('Word found in the tree.');
      } else {
        print('Word not found in the tree.');
      }
    } else {
      print(
          'Invalid word. Please use only the provided letters without repetition.');
    }
  } else {
    print('Invalid input. Please enter a word.');
  }
}

List<String> findWordsWithLetters(Trie trie, List<String> letters) {
  List<String> result = [];
  void searchWords(TrieNode node, String currentWord) {
    if (node.isEndOfWord && containsOnlyLetters(currentWord, letters)) {
      result.add(currentWord);
    }
    node.children.forEach((key, value) {
      searchWords(value, currentWord + key);
    });
  }

  searchWords(trie._root, "");
  return result;
}

List<List<T>> generateSublists<T>(List<T> originalList) {
  List<List<T>> result = [];
  for (int i = originalList.length; i >= 1; i--) {
    result.addAll(combinations<T>(originalList, i));
  }
  return result;
}

List<List<T>> combinations<T>(List<T> list, int length) {
  if (length == 1) {
    return list.map((e) => [e]).toList();
  } else {
    List<List<T>> result = [];
    for (int i = 0; i < list.length; i++) {
      var start = list[i];
      var remaining = list.sublist(i + 1);
      result.addAll(
          combinations(remaining, length - 1).map((e) => [start, ...e]));
    }
    return result;
  }
}

bool containsOnlyLetters(String word, List<String> letters) {
  for (var letter in word.split('')) {
    if (!letters.contains(letter)) {
      return false;
    }
  }
  for (var letter in letters) {
    if (!word.contains(letter)) {
      return false;
    }
  }
  return true;
}

Future<void> main() async {
  List<String> allFoundWords = [];
  List<String> w = [];
  List<String> randomLetters = generateRandomLetters(14);
  List<List<String>> result = generateSublists(randomLetters);
  print('Random letters: $randomLetters');
  print('Use these letters to form a word:');

  for (var sublist in result) {
    var sublistLength = sublist.length;
    var filePath = '/Users/lo9mane/Desktop/words2/w$sublistLength.txt';
    var trie = Trie();
    var file = File(filePath);
    await for (var line
        in file.openRead().transform(utf8.decoder).transform(LineSplitter())) {
      var words = line.split(' ');
      for (var word in words) {
        trie.insert2(word);
      }
    }
    var foundWords = findWordsWithLetters(trie, sublist);
    if (foundWords.isNotEmpty) {
      allFoundWords.addAll(foundWords);
      break;
    }
  }
  String? word = stdin.readLineSync();

  if (word != null) {
    int wordLength = word.length;
    var tree = await readTreeFromFile(
        '/Users/lo9mane/Desktop/words2/w$wordLength.txt');
    checkWordAndSearch(tree, word, randomLetters);
    w.add(word);
  }

  print('The longest words that can be formed : $allFoundWords');
  if (w.length < allFoundWords[0].length) {
    print('Next time try better');
  } else if (w.length == allFoundWords[0].length) {
    print('BRAVO !');
  }
}
