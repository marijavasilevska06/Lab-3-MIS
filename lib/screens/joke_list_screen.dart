import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jokes_app/models/joke.dart';
import 'package:jokes_app/providers/joke_provider.dart';
import 'package:jokes_app/widgets/custom_app_bar.dart';
import 'package:jokes_app/widgets/bottom_bar.dart';
import 'package:provider/provider.dart';
import '../services/api_services.dart';
import '../widgets/header.dart';


class JokesScreen extends StatefulWidget {
  const JokesScreen({super.key});

  @override
  State<JokesScreen> createState() => _JokesScreenState();
}

class _JokesScreenState extends State<JokesScreen> {
  List<Joke> jokes = [];
  String type = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments as String;
    setState(() {
      type = arguments;
    });
    if (type.isNotEmpty) {
      getAllJokesForTypeApi(type);
    }
  }

  void getAllJokesForTypeApi(String type) async {
    try {
      final response = await ApiService.getAllJokesForTypeFromAPI(type);
      var data = List.from(json.decode(response.body));
      setState(() {
        jokes = data.map<Joke>((element) => Joke.fromJson(element)).toList();
      });
    } catch (e) {
      print('Error loading jokes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final jokeProvider = Provider.of<JokeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$type Jokes',
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
        child: jokes.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: jokes.length,
          itemBuilder: (context, index) {
            final item = jokes[index];
            return Card(
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 8),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text(
                  item.setup,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    item.punchline,
                    style: TextStyle(fontSize: 14, color: Colors.purple),
                  ),
                ),
                leading: IconButton(
                  icon: Icon(
                    jokeProvider.favorites
                        .any((tmp) => tmp.id == item.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: jokeProvider.favorites
                        .any((tmp) => tmp.id == item.id)
                        ? Colors.red
                        : null,
                  ),
                  onPressed: () {
                    if (jokeProvider.favorites
                        .any((tmp) => tmp.id == item.id)) {
                      jokeProvider.removeFavoriteJoke(item);
                    } else {
                      jokeProvider.addFavoriteJoke(item);
                    }
                  },
                ),
                trailing: Text(
                  "ID: ${item.id}",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomBarWidget(),
    );
  }
}
