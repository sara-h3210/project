
import 'dart:convert';
import 'dart:io';

import 'package:app/game_logic/letters.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';

class letterspage extends StatelessWidget {
  const letterspage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Word Finder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WordFinderScreen(),
    );
  }
}

class WordFinderScreen extends StatefulWidget {
  const WordFinderScreen({super.key});

  @override
  _WordFinderScreenState createState() => _WordFinderScreenState();
}

class _WordFinderScreenState extends State<WordFinderScreen> {
  String enteredWord = '';
  String longestWord = '';
  String Word = '';
  List<String> allFoundWords = [];
  List<String> w = [];
  List<String> randomLetters = generateRandomLetters(10);
  int test = 0;
  @override
  Widget build(BuildContext context) {
    List<List<String>> result = generateSublists(randomLetters);

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
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
                            MaterialPageRoute(
                                builder: (context) => const MyApp()),
                            (Route<dynamic> route) => false,
                          );
                        },
                      ),
                      Text(
                        'Letters',
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
                                builder: (context) => const letterspage()),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 120),
                          Wrap(
                            spacing: 20,
                            runSpacing: 15,
                            alignment: WrapAlignment.center,
                            children: [
                              for (var letter in randomLetters)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      enteredWord += letter;
                                    });
                                  },
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 4,
                                          offset: Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        letter.toUpperCase(),
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 255, 255, 247),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 70),
                          Container(
                            width: 350,
                            child: TextField(
                              onChanged: (value) {
                                enteredWord = value;
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter your word',
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontStyle: FontStyle.italic,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.blueAccent,
                                    width: 2.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 2.5,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 1.5,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                fillColor: Colors.white,
                                filled: true,
                              ),
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 50),
                          ElevatedButton(
                            onPressed: () async {
                              for (var sublist in result) {
                                var sublistLength = sublist.length;
                                var filePath =
                                    'C:/dictionnaire/w$sublistLength.txt';
                                var trie = Trie();
                                var file = File(filePath);
                                await for (var line in file
                                    .openRead()
                                    .transform(utf8.decoder)
                                    .transform(LineSplitter())) {
                                  var words = line.split(' ');
                                  for (var word in words) {
                                    trie.insert2(word);
                                  }
                                }
                                var foundWords =
                                    findWordsWithLetters(trie, sublist);
                                if (foundWords.isNotEmpty) {
                                  allFoundWords.addAll(foundWords);
                                  break;
                                }
                              }
                              if (enteredWord.isNotEmpty) {
                                int wordLength = enteredWord.length;
                                var tree = await readTreeFromFile(
                                    'C:/dictionnaire/w$wordLength.txt');

                                int x = checkWordAndSearch(
                                    tree, enteredWord, randomLetters);
                                if (x == 1) {
                                  test = 1;
                                  w.add(enteredWord);
                                } else if (x == 2) {
                                  test = 2;
                                } else if (x == 3) {
                                  test = 3;
                                } else if (x == 4) {
                                  test = 4;
                                }
                              }

                              setState(() {
                                longestWord = allFoundWords.isNotEmpty
                                    ? allFoundWords[0]
                                    : '';
                                Word = w.isNotEmpty ? w[0] : '';
                              });
                            },
                            child: Text(
                              'Validate Word',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 55, 125, 238),
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 12),
                            ),
                          ),
                          SizedBox(height: 70),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 49, 49, 49)
                                  .withOpacity(0.7),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (test == 1)
                                  _buildText(
                                      'BRAVO! $Word Is Valid , Longest valid word: $longestWord'),
                                if (test == 2)
                                  _buildText('YOUR WORD IS NOT VALID !'),
                                if (test == 3)
                                  _buildText(
                                      'Invalid word. Please use only the provided letters without repetition.'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}
