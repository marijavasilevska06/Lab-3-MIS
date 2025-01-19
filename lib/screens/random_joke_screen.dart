import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jokes_app/models/joke.dart';
import '../services/api_services.dart';

class RandomJoke extends StatefulWidget {
  const RandomJoke({super.key});

  @override
  State<RandomJoke> createState() => _RandomJokeState();
}

class _RandomJokeState extends State<RandomJoke> {
  Joke joke = Joke(id: 0, type: '', setup: '', punchline: '');

  @override
  void initState() {
    super.initState();
    getRandomJokeFromApi();
  }

  void getRandomJokeFromApi() async {
    try {
      final response = await ApiService.getRandomJokeFromAPI();
      var data = json.decode(response.body);
      setState(() {
        joke = Joke.fromJson(data);
      });
    } catch (e) {
      print('Error fetching random joke: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Random Joke 223159',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue.shade50, Colors.lightBlue.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  joke.setup.isNotEmpty ? joke.setup : 'Loading joke...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  joke.punchline.isNotEmpty ? joke.punchline : '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: getRandomJokeFromApi,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding:
                    EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Get Another Joke',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
