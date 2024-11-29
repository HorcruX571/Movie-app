import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List allMovies = []; // Store all movies fetched from the API
  List filteredMovies = []; // Store movies based on selected genre
  List<String> genres = [
    "All",
    "Drama",
    "Comedy",
    "Children",
    "Sports",
    "Anime"
  ]; // Predefined genres
  String selectedGenre = "All"; // Default genre
  bool isLoading = true; // Loading state
  bool isError = false; // Error state

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    try {
      final response = await http
          .get(Uri.parse('https://api.tvmaze.com/search/shows?q=all'));
      if (response.statusCode == 200) {
        List fetchedMovies = json.decode(response.body);

        setState(() {
          allMovies = fetchedMovies; // Save all movies
          filteredMovies = fetchedMovies; // Initially, show all movies
          isLoading = false; // Stop loading spinner
          isError = false; // Reset error state
        });
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      // Handle errors
      setState(() {
        isLoading = false;
        isError = true;
      });
      print('Error: $e');
    }
  }

  void filterMoviesByGenre(String genre) {
    setState(() {
      selectedGenre = genre;
      if (genre == "All") {
        filteredMovies = allMovies; // Show all movies
      } else {
        filteredMovies = allMovies
            .where((movie) =>
                movie['show']['genres'] != null &&
                movie['show']['genres'].contains(genre))
            .toList(); // Filter by selected genre
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black, // Top bar color
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'lib/assets/logo.png', // Ensure this path is correct
              height: 40,
            ),
            SizedBox(width: 20),
            Text(
              'Movies & TV', // App title
              style: TextStyle(
                color: Colors.white, // White text
                fontSize: 18, // Font size
                fontWeight: FontWeight.bold, // Bold text
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Genre selection bar
          Container(
            height: 50,
            color: Colors.black,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: genres.length,
              itemBuilder: (context, index) {
                final genre = genres[index];
                return GestureDetector(
                  onTap: () => filterMoviesByGenre(genre),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      genre,
                      style: TextStyle(
                        color: selectedGenre == genre
                            ? Color.fromARGB(197, 219, 23, 23)
                            : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator()) // Loading spinner
                : isError
                    ? Center(
                        child: Text(
                          'Failed to load movies. Please try again.',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      )
                    : filteredMovies.isEmpty
                        ? Center(
                            child: Text(
                              'No movies found!',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.7,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: filteredMovies.length,
                              itemBuilder: (context, index) {
                                final movie = filteredMovies[index]['show'];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/details',
                                        arguments: movie);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(10)),
                                          child: movie['image'] != null
                                              ? Image.network(
                                                  movie['image']['medium'],
                                                  height: 180,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.asset(
                                                  'lib/assets/logo.png',
                                                  height: 180,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                        SizedBox(height: 8),
                                        Center(
                                          child: Text(
                                            movie['name'] ?? 'No Title',
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            movie['summary']?.replaceAll(
                                                    RegExp(r'<[^>]*>'), '') ??
                                                'No Summary',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[300],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
      backgroundColor: Colors.black, // Match app theme
    );
  }
}
