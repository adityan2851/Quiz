import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quiz_answer/QuizHelper.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_answer/Resultscreen.dart';

class Quizscreen extends StatefulWidget {
  @override
  _QuizscreenState createState() => _QuizscreenState();
}

class _QuizscreenState extends State<Quizscreen> {
  static const url =
      "https://opentdb.com/api.php?amount=10&category=18&type=multiple";

  QuizHelper quizHelper;

  int currentQuestion = 0;

  int totalSeconds = 30;
  int elapsedSeconds = 0;

  Timer timer;
  int score = 0;

  @override
  void initState() {
    fetchAllQuiz();
    super.initState();
  }

  fetchAllQuiz() async {
    var response = await http.get(Uri.parse(url));
    var body = response.body;
    var json = jsonDecode(body);
    setState(() {
      quizHelper = QuizHelper.fromJson(json);
      quizHelper.results[currentQuestion].incorrectAnswers
          .add(quizHelper.results[currentQuestion].correctAnswer);
      quizHelper.results[currentQuestion].incorrectAnswers.shuffle();
    });
    initTimer();
  }

  initTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (t.tick == totalSeconds) {
        print("Time Completed");
        t.cancel();
        changeQuestion();
      } else {
        setState(() {
          elapsedSeconds = t.tick;
        });
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  checkAnswer(answer) {
    String correntAnswer = quizHelper.results[currentQuestion].correctAnswer;
    if (correntAnswer == answer) {
      score += 1;
      changeQuestion();
    } else {
      print("wrong");
      changeQuestion();
    }
  }

  changeQuestion() {
    timer.cancel();
    if (currentQuestion == quizHelper.results.length - 1) {
      print("Quiz Completed");
      print("Score: $score");
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => ResultScreen(score: score)));
    } else {
      setState(() {
        currentQuestion += 1;
        quizHelper.results[currentQuestion].incorrectAnswers
            .add(quizHelper.results[currentQuestion].correctAnswer);
        quizHelper.results[currentQuestion].incorrectAnswers.shuffle();
        initTimer();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (quizHelper != null) {
      return Scaffold(
        backgroundColor: Color(0xFF000080),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 60,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image(
                        image: AssetImage("assets/circle.png"),
                        width: 70,
                        height: 70,
                      ),
                      Text(
                        "$elapsedSeconds S",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Q.${quizHelper.results[currentQuestion].question}",
                    style: TextStyle(fontSize: 35, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 40,
                  ),
                  child: Column(
                    children: quizHelper
                        .results[currentQuestion].incorrectAnswers
                        .map((option) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                            onPressed: () {
                              checkAnswer(option);
                            },
                            // colorBrightness: Brightness.dark,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: 20,
                              ),
                            ),
                            child: Text(
                              option,
                              style: TextStyle(fontSize: 18),
                            )),
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Color(0xFF000080),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
