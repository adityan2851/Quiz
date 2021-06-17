import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_answer/quizscreen.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "productsans"),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarBrightness: Brightness.dark));

    return Scaffold(
      backgroundColor: Color(0xFF000080),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),
              Center(
                child: Image(
                  image: AssetImage("assets/circle.png"),
                  width: 300,
                  height: 300,
                ),
              ),
              Text(
                "Quiz",
                style: TextStyle(color: Colors.white, fontSize: 90),
              ),
              SizedBox(
                height: 90,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                width: double.infinity,
                child: ElevatedButton(
                  child: Text(
                    "PLAY",
                    style: TextStyle(fontSize: 28),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Quizscreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    primary: Colors.amber,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
