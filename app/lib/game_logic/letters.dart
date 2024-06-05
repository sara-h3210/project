// ignore_for_file: avoid_print

//import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';

// TrieNode class represents a node in a Trie (prefix tree)
class TrieNode {
  // Map to hold children nodes
  final Map<String, TrieNode> children = {};
  // Boolean to check if it's the end of a word
  bool isEndOfWord = false;
}

// TreeNode class represents a node in a Binary Search Tree (BST)
class TreeNode {
  // Key for the node
  String key;
  // Left and right children nodes
  TreeNode? left, right;

  // Constructor to initialize node with key
  TreeNode(this.key);
}

// Tree class represents a Binary Search Tree (BST)
class Tree {
  // Root node of the tree
  TreeNode? root;

  // Method to insert a key into the BST
  void insert(String key) {
    // Call the recursive insert method
    root = _insertRec(root, key);
  }

  // Recursive method to insert a key into the BST
  TreeNode _insertRec(TreeNode? node, String key) {
    // Create a new node if current node is null
    if (node == null) {
      return TreeNode(key);
    }

    // Compare key with node's key
    int cmp = key.compareTo(node.key);

    // Insert in the left subtree if key is less
    if (cmp < 0) {
      node.left = _insertRec(node.left, key);
    } 
    // Insert in the right subtree if key is greater
    else if (cmp > 0) {
      node.right = _insertRec(node.right, key);
    }
    // Return the (possibly new) node reference
    return node;
  }

  // Method to search a key in the BST
  bool search(String key) {
    // Call the recursive search method
    return _searchRec(root, key);
  }

  // Recursive method to search a key in the BST
  bool _searchRec(TreeNode? node, String key) {
    // Key not found if node is null
    if (node == null) {
      return false;
    }

    // Compare key with node's key
    int cmp = key.compareTo(node.key);

    // Key found
    if (cmp == 0) {
      return true;
    } 
    // Search in the left subtree if key is less
    else if (cmp < 0) {
      return _searchRec(node.left, key);
    } 
    // Search in the right subtree if key is greater
    else {
      return _searchRec(node.right, key);
    }
  }
}

// Trie class represents a Trie (prefix tree)
class Trie {
  // Root node of the Trie
  final TrieNode _root = TrieNode();

  // Method to insert a word into the Trie
  void insert2(String word) {
    // Start from the root node
    var current = _root;
    for (var i = 0; i < word.length; i++) {
      var char = word[i];
      // Create new node if character is not present
      if (!current.children.containsKey(char)) {
        current.children[char] = TrieNode();
      }
      // Move to the next node
      current = current.children[char]!;
    }
    // Mark end of word
    current.isEndOfWord = true;
  }

  // Method to search a word in the Trie
  bool search2(String word) {
    // Start from the root node
    var current = _root;
    for (var i = 0; i < word.length; i++) {
      var char = word[i];
      // Word not found if character is not present
      if (!current.children.containsKey(char)) {
        return false;
      }
      // Move to the next node
      current = current.children[char]!;
    }
    // Return if it's the end of a word
    return current.isEndOfWord;
  }
}

// Method to read a tree from a file and insert its contents into a BST
Future<Tree> readTreeFromFile(String filePath) async {
  // Create a new tree
  var tree = Tree();

  try {
    // Read the file from the assets directory
    String fileContent = await rootBundle.loadString(filePath);

    // Split the file content into lines
    List<String> lines = fileContent.split('\n');

    // Insert each line into the tree
    for (var line in lines) {
      tree.insert(line);
    }
  } catch (e) {
    // Rethrow the exception
    rethrow;
  }

  // Return the tree
  return tree;
}

// Method to generate random letters
List<String> generateRandomLetters(int count) {
  // Check if count is non-negative
  if (count < 0) {
    throw ArgumentError('Count should be a non-negative number.');
  }

  // List of vowels
  List<String> vowels = ['a', 'e', 'i', 'o', 'u'];
  // List of consonants
  List<String> consonants = [
    'b', 'c', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm', 'n', 'p', 'q', 'r', 's', 't', 'v', 'w', 'x', 'y', 'z'
  ];

  // List to store the generated letters
  List<String> letters = [];
  // Random object for generating random numbers
  Random random = Random();

  // Add vowels to the list
  int vowelsCount = min(count ~/ 2, vowels.length);
  for (int i = 0; i < vowelsCount; i++) {
    letters.add(vowels[i]);
  }

  // Add consonants to the list
  int remainingCount = count - vowelsCount;
  for (int i = 0; i < remainingCount; i++) {
    letters.add(consonants[random.nextInt(consonants.length)]);
  }

  // Shuffle the letters
  letters.shuffle();

  // Return the list of letters
  return letters;
}

// Method to check if a word can be formed with given letters
bool isValidWord(String word, List<String> availableLetters) {
  // Convert word to lowercase
  word = word.toLowerCase();

  // Copy of available letters to modify
  List<String> remainingLetters = List.from(availableLetters);

  // Check each letter in the word
  for (int i = 0; i < word.length; i++) {
    String letter = word[i];

    // Letter not available
    if (!remainingLetters.contains(letter)) {
      return false;
    }

    // Remove used letter
    remainingLetters.remove(letter);
  }

  // All letters are available
  return true;
}

// Method to check a word and search in the BST
int checkWordAndSearch(Tree tree, String? word, List<String> randomLetters) {
  // Check if word is not null
  if (word != null) {
    // Convert word to lowercase
    word = word.toLowerCase();

    // Check if the word is valid
    if (isValidWord(word, randomLetters)) {
      // Check if the word exists in the tree
      if (tree.search(word.trim())) {
        return 1; // Word found in tree
      } else {
        return 2; // Word not found in tree
      }
    } else {
      return 3; // Invalid word
    }
  } else {
    return 4; // Word is null
  }
}

// Method to find words that can be formed with given letters in a Trie
List<String> findWordsWithLetters(Trie trie, List<String> letters) {
  // List to store the result
  List<String> result = [];
  // Recursive function to search words
  void searchWords(TrieNode node, String currentWord) {
    // Add word to result if it's the end of a word and contains only given letters
    if (node.isEndOfWord && containsOnlyLetters(currentWord, letters)) {
      result.add(currentWord);
    }
    // Recursively search each child node
    node.children.forEach((key, value) {
      searchWords(value, currentWord + key);
    });
  }

  // Start searching from the root
  searchWords(trie._root, "");
  // Return the result
  return result;
}

// Method to generate all possible sublists of a list
List<List<T>> generateSublists<T>(List<T> originalList) {
  // List to store the result
  List<List<T>> result = [];
  // Generate sublists of each length
  for (int i = originalList.length; i >= 1; i--) {
    result.addAll(combinations<T>(originalList, i));
  }
  // Return the result
  return result;
}

// Method to generate combinations of a list
List<List<T>> combinations<T>(List<T> list, int length) {
  // Base case: combinations of length 1
  if (length == 1) {
    return list.map((e) => [e]).toList();
  } else {
    // List to store the result
    List<List<T>> result = [];
    // Generate combinations for each element
    for (int i = 0; i < list.length; i++) {
      var start = list[i];
      var remaining = list.sublist(i + 1);
      result.addAll(
          combinations(remaining, length - 1).map((e) => [start, ...e]));
    }
    // Return the result
    return result;
  }
}
// Method to check if a word contains only given letters
bool containsOnlyLetters(String word, List<String> letters) {
  // Iterate over each letter in the word
  for (var letter in word.split('')) {
    // If a letter in the word is not in the letters list, return false
    if (!letters.contains(letter)) {
      return false;
    }
  }
  // Iterate over each letter in the letters list
  for (var letter in letters) {
    // If a letter in the letters list is not in the word, return false
    if (!word.contains(letter)) {
      return false;
    }
  }
  // Return true if all letters are matched correctly
  return true;
}