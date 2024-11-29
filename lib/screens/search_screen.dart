import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List searchResults = [];
  TextEditingController _controller = TextEditingController();
  bool isLoading = false; // Loading spinner
  bool isError = false; // Error state

  Future<void> searchMovies(String query) async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    try {
      final response = await http
          .get(Uri.parse('https://api.tvmaze.com/search/shows?q=$query'));
      if (response.statusCode == 200) {
        setState(() {
          searchResults = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch search results');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Search',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _controller,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  hintText: 'Search for movies or TV shows',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                onSubmitted: (query) => searchMovies(query),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : isError
                    ? Center(
                        child: Text(
                          'Failed to load search results. Please try again.',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      )
                    : searchResults.isEmpty
                        ? Center(
                            child: Text(
                              'No results found!',
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
                              itemCount: searchResults.length,
                              itemBuilder: (context, index) {
                                final movie = searchResults[index]['show'];
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
                                        // Movie Thumbnail
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
                                        // Movie Title
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
                                        // Movie Summary
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
    );
  }
}
