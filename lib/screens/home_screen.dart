import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jokes_app/screens/register_sc.dart';
import 'package:jokes_app/widgets/custom_app_bar.dart';
import 'package:jokes_app/widgets/bottom_bar.dart';
import 'package:jokes_app/providers/joke_provider.dart';
import 'package:provider/provider.dart';
import 'package:jokes_app/services/api_services.dart';
import 'package:jokes_app/models/joke.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> types = [];
  List<Joke> jokes = [];
  String selectedType = "";

  @override
  void initState() {
    super.initState();
    getTypesFromApi();
  }

  void getTypesFromApi() async {
    try {
      final response = await ApiService.getTypesFromAPI();
      var data = List.from(json.decode(response.body));
      setState(() {
        types = List<String>.from(data);
      });
    } catch (e) {
      print('Error loading types: $e');
    }
  }

  void getAllJokesForType(String type) async {
    try {
      final response = await ApiService.getAllJokesForTypeFromAPI(type);
      var data = List.from(json.decode(response.body));
      setState(() {
        jokes = data.map((joke) => Joke.fromJson(joke)).toList();
        selectedType = type;
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
          '223159',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.shuffle, color: Colors.white),
            onPressed: () {
              // Add logic for random joke if needed
            },
          ),
          IconButton(
            icon: Icon(Icons.person_add, color: Colors.white),
            onPressed: () {
              // Пренасочување на екран за регистрација
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterPage()), // Променете го со RegisterScreen
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue.shade50, Colors.lightBlue.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: selectedType.isEmpty
            ? types.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          itemCount: types.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 8),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Icon(Icons.tag, color: Colors.blueAccent),
                title: Text(
                  types[index],
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                onTap: () {
                  getAllJokesForType(types[index]);
                },
              ),
            );
          },
        )
            : Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Text(
                  'Jokes',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ),
            jokes.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(10),
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
                            color: Colors.black87),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Text(
                          item.punchline,
                          style: TextStyle(
                              fontSize: 14, color: Colors.purple),
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
                          if (jokeProvider.favorites.any(
                                  (tmp) => tmp.id == item.id)) {
                            jokeProvider.removeFavoriteJoke(item);
                          } else {
                            jokeProvider.addFavoriteJoke(item);
                          }
                        },
                      ),
                      trailing: Text("ID: ${item.id}"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBarWidget(),
    );
  }
}

class RegisterScreen {
}

